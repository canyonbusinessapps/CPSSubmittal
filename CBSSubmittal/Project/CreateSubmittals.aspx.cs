using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;
using System.Web.UI.WebControls;
using PdfSharp;
using PdfSharp.Drawing;
using PdfSharp.Drawing.Layout;
using PdfSharp.Pdf;
using PdfSharp.Pdf.Advanced;
using PdfSharp.Pdf.IO;

namespace CBSSubmittal.Project
{
    public partial class CreateSubmittals : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        string path = HttpContext.Current.Request.PhysicalApplicationPath;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindGrid();
            }

            string docId = Request.QueryString["Id"];
            if (docId != null)
            {
                int DID = Convert.ToInt32(docId);
                string query = "SELECT DocumentFile FROM [dbo].[Document] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string fileName = cmd.ExecuteScalar().ToString();

                Response.ContentType = "Application/pdf";
                Response.AppendHeader("Content-Disposition", "attachment; filename=~/Uploads/Documents/" + fileName);
                Response.TransmitFile(Server.MapPath(@"~/Uploads/Documents/" + fileName));
                Response.End();
                dbConnection.Close();
            }

        }

        private void BindGrid()
        {
            dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand("SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details FROM [dbo].[Document] D LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id", dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    grdDocument.DataSource = dt;
                    grdDocument.DataBind();

                    if (grdDocument.Rows.Count > 0)
                    {
                        //Adds THEAD and TBODY Section.
                        grdDocument.HeaderRow.TableSection = TableRowSection.TableHeader;

                        //Adds TH element in Header Row.  
                        grdDocument.UseAccessibleHeader = true;

                        //Adds TFOOT section. 
                        grdDocument.FooterRow.TableSection = TableRowSection.TableFooter;
                    }
                }
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string strSaveFileAs = "";

            strSaveFileAs = Server.MapPath("~/Uploads/Documents/" + fileDocumentFile.FileName.Replace(" ", "_").ToLower());

            try
            {
                if (fileDocumentFile.HasFile)
                {
                    fileDocumentFile.SaveAs(strSaveFileAs);

                    dbConnection.Open();
                    string query = "INSERT INTO [dbo].[Document] ([ProjectId],[DocumentName],[DocumentFile],[Details]) VALUES (@ProjectId,@DocumentName,@DocumentFile,@Details)";

                    SqlCommand cmd = new SqlCommand(query, dbConnection);
                    cmd.Parameters.AddWithValue("@ProjectId", Convert.ToInt32(txtProjectId.Text).ToString());
                    cmd.Parameters.AddWithValue("@DocumentName", txtDocumentName.Text);
                    cmd.Parameters.AddWithValue("@DocumentFile", fileDocumentFile.FileName.Replace(" ", "_").ToLower());
                    cmd.Parameters.AddWithValue("@Details", txtDetails.Text);
                    cmd.ExecuteNonQuery();
                    Response.Redirect("~/Project/CreateDocument.aspx");
                }
                else
                {
                    Response.Write("No file was uploaded.");
                }
            }
            catch (Exception ex)
            {
                Response.Write("error" + ex.ToString());
            }
            finally
            {
                dbConnection.Close();
            }
        }
        protected void btnCreateSubmittals_Click(object sender, EventArgs e)
        {
            int _projectId = Convert.ToInt32(Session["defaultProject"]);
            string projectName = "Project 1";
            // Create the output document
            PdfDocument outputDocument = new PdfDocument();

            // Show consecutive pages facing. Requires Acrobat 5 or higher.
            outputDocument.PageLayout = PdfPageLayout.SinglePage;
            
            XFont font = new XFont("Verdana", 10, XFontStyle.Bold);
            XStringFormat format = new XStringFormat();
            format.Alignment = XStringAlignment.Center;
            format.LineAlignment = XLineAlignment.Far;
            XGraphics gfx;
            XRect box;

            // Create an empty page
            PdfPage page = outputDocument.AddPage();
            // Create a font
            font = new XFont("Verdana", 15, XFontStyle.Bold);
            // Get an XGraphics object for drawing
            gfx = XGraphics.FromPdfPage(page);

            //// Draw the text - Table of Contentd
            gfx.DrawString("TABLE OF CONTENTS ", font, XBrushes.Black,
              new XRect(100, 60, page.Width, 20),
              XStringFormats.TopLeft);

            int positionY = 90;
            int indexCount = 2;
            int pageNo = 2;
            string strSQL = @"SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details 
            FROM [dbo].[Document] D 
            LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id 
            WHERE P.Id=" + _projectId + @"
            ORDER BY Ordering ASC";
            dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        outputDocument.Info.Title = dt.Rows[0]["ProjectName"].ToString();;

                        foreach (DataRow row in dt.Rows)
                        {
                            string filex = row["DocumentName"].ToString() + "        " + indexCount;
                            
                            string filenamex = path + "/Uploads/Documents/" + row["DocumentFile"].ToString();
                            PdfDocument inputDocumentx = PdfReader.Open(filenamex, PdfDocumentOpenMode.Import);
                            int count = inputDocumentx.PageCount;

                            //// Draw the text
                            //gfx.DrawString(filex, font, XBrushes.Black,
                            //  new XRect(0, positionY, page.Width, page.Height),
                            //  XStringFormats.Center);
                            
                            XFont fontNormal = new XFont("Verdana", 15, XFontStyle.Regular);
                            
                            //Set link position
                            var xrect = new XRect(100, positionY, page.Width, 20);
                            var rect = gfx.Transformer.WorldToDefaultPage(xrect);
                            var pdfrect = new PdfRectangle(rect);

                            //file link
                            //page.AddFileLink(pdfrect, filename3);
                            //gfx2.DrawString("open file CompareDocument1_tempfile.pdf", fontNormal, XBrushes.Black, xrect, XStringFormats.TopLeft);

                            //Goto  Page 2
                            page.AddDocumentLink(pdfrect, indexCount);
                            gfx.DrawString(filex, fontNormal, XBrushes.Black, xrect, XStringFormats.TopLeft);

                            //TheArtOfDev.HtmlRenderer.PdfSharp.HtmlContainer c = new TheArtOfDev.HtmlRenderer.PdfSharp.HtmlContainer();
                            //c.SetHtml("<html><body style='font-size:20px'>Whatever</body></html>");
                            //c.PerformPaint(gfx);

                            positionY += 20;
                            indexCount += count;
                        }

                        font = new XFont("Verdana", 10, XFontStyle.Bold);
                        foreach (DataRow row in dt.Rows)
                        {
                            string filex = row["DocumentFile"].ToString();
                            string filenamex = path + "/Uploads/Documents/" + filex;
                            PdfDocument inputDocumentx = PdfReader.Open(filenamex, PdfDocumentOpenMode.Import);
                            int count2 = inputDocumentx.PageCount;
                            for (int idx = 0; idx < count2; idx++)
                            {
                                // Get page from 1st document
                                PdfPage page1 = inputDocumentx.PageCount > idx ?
                                  inputDocumentx.Pages[idx] : new PdfPage();

                                // Add pages to the output document
                                page1 = outputDocument.AddPage(page1);

                                // Write document file name and page number on each page
                                gfx = XGraphics.FromPdfPage(page1);
                                box = page1.MediaBox.ToXRect();
                                box.Inflate(0, -10);
                                gfx.DrawString(String.Format("{0}  {1}", "Page - ", pageNo),
                                  font, XBrushes.Red, box, format);
                                pageNo += 1;
                            }
                        }

                        // Save the document...
                        string filename3 = path+"/Uploads/Documents/" + projectName+ ".pdf";
                        outputDocument.Save(filename3);
                        Process.Start(filename3);
                    }
                }
            }
        }

        protected void GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                dbConnection.Open();
                int DID = Convert.ToInt32(grdDocument.DataKeys[e.RowIndex].Value);
                string query = "DELETE FROM [dbo].[Document] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
                Response.Redirect("~/Project/CreateDocument.aspx");
            }
            catch (Exception ex)
            {
                Response.Write("error" + ex.ToString());
            }
            finally
            {
                dbConnection.Close();

            }
        }
    }
}