using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using PdfSharp;
using PdfSharp.Drawing;
using PdfSharp.Drawing.Layout;
using PdfSharp.Pdf;
using PdfSharp.Pdf.Advanced;
using PdfSharp.Pdf.IO;
using System.Diagnostics;

namespace CBSSubmittal
{
    public partial class _Default : Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        string path = HttpContext.Current.Request.PhysicalApplicationPath;
        string webPath = ConfigurationManager.AppSettings["webPath"];
        protected void Page_Load(object sender, EventArgs e)
        {
            string reqProject = Request.QueryString["view"];
            if (reqProject != null)
            {
                Session["defaultProject"] = Convert.ToInt32(reqProject).ToString();
                Response.Redirect(webPath + "Default.aspx");
            }
        }

        protected void Update_Ordering(object sender, EventArgs e)
        {
            try
            {
                var txtOrdering = (TextBox)sender;
                var row = (GridViewRow)txtOrdering.NamingContainer;
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = ((sender as TextBox).NamingContainer as GridViewRow).RowIndex;
                int Ordering = Convert.ToInt32(txtOrdering.Text);
                int Id = Convert.ToInt32(grdDocuments.DataKeys[rowIndex].Values[0]);

                dbConnection.Open();
                string query = "UPDATE [dbo].[Document] SET [Ordering]=" + Ordering + " WHERE Id=" + @Id;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
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

        protected void Update_Ordering_SpecSheet(object sender, EventArgs e)
        {
            try
            {
                var txtOrdering = (TextBox)sender;
                var row = (GridViewRow)txtOrdering.NamingContainer;
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = ((sender as TextBox).NamingContainer as GridViewRow).RowIndex;
                int Ordering = Convert.ToInt32(txtOrdering.Text);
                int Id = Convert.ToInt32(GridViewSpecSheet.DataKeys[rowIndex].Values[0]);

                dbConnection.Open();
                string query = "UPDATE [dbo].[SpecSheet] SET [Ordering]=" + Ordering + " WHERE Id=" + @Id;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
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

        protected void Update_Ordering_OMSheet(object sender, EventArgs e)
        {
            try
            {
                var txtOrdering = (TextBox)sender;
                var row = (GridViewRow)txtOrdering.NamingContainer;
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = ((sender as TextBox).NamingContainer as GridViewRow).RowIndex;
                int Ordering = Convert.ToInt32(txtOrdering.Text);
                int Id = Convert.ToInt32(GridViewOMSheet.DataKeys[rowIndex].Values[0]);

                dbConnection.Open();
                string query = "UPDATE [dbo].[OMSheet] SET [Ordering]=" + Ordering + " WHERE Id=" + @Id;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
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


            // Create and Save Table of Contents...
            //// Draw the text - Table of Contentd
            gfx.DrawString("TABLE OF CONTENTS ", font, XBrushes.Black,
              new XRect(100, 60, page.Width, 20),
              XStringFormats.TopLeft);

            int positionY = 90;
            int indexCount = 2;
            string strSQL = @"SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details 
            FROM [dbo].[Document] D 
            LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id 
            WHERE P.Id=" + _projectId + @"
            AND Ordering!=0
            ORDER BY Ordering ASC";
            string filename3 = "";
            dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        projectName = dt.Rows[0]["ProjectName"].ToString();
                        outputDocument.Info.Title = dt.Rows[0]["ProjectName"].ToString();

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

                        // Create and Save Table of Contents...
                        filename3 = path + "/Uploads/Documents/" + projectName + ".pdf";
                        outputDocument.Save(filename3);

                    }
                }
            }
            //Initial the doc so its starts new
            //Add cover page
            outputDocument = new PdfDocument();
            strSQL = @"SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details 
            FROM [dbo].[Document] D 
            LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id 
            WHERE P.Id=" + _projectId + @" 
            AND Ordering=0
            ORDER BY Ordering ASC";

            //dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        projectName = dt.Rows[0]["ProjectName"].ToString();
                        outputDocument.Info.Title = dt.Rows[0]["ProjectName"].ToString();

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
                                
                            }
                        }

                        //// Save the document...
                        //string filename3 = path + "/Uploads/Documents/" + projectName + ".pdf";
                        //outputDocument.Save(filename3);
                    }
                }
            }

            // Add table content page
            //string filex2 = "Index";
            string filenamex2 = filename3;
            PdfDocument inputDocumentx2 = PdfReader.Open(filenamex2, PdfDocumentOpenMode.Import);
            int count22 = inputDocumentx2.PageCount;
            for (int idx = 0; idx < count22; idx++)
            {
                // Get page from 1st document
                PdfPage page1 = inputDocumentx2.PageCount > idx ?
                  inputDocumentx2.Pages[idx] : new PdfPage();

                // Add pages to the output document
                page1 = outputDocument.AddPage(page1);

                // Write document file name and page number on each page
                gfx = XGraphics.FromPdfPage(page1);
                box = page1.MediaBox.ToXRect();
                box.Inflate(0, -10);

            }

            // Add other pages
            int pageNo = 2;
            strSQL = @"SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details 
            FROM [dbo].[Document] D 
            LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id 
            WHERE P.Id=" + _projectId + @"
            AND Ordering!=0
            ORDER BY Ordering ASC";

            //dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        projectName = dt.Rows[0]["ProjectName"].ToString();
                        outputDocument.Info.Title = dt.Rows[0]["ProjectName"].ToString();

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
                        dbConnection.Dispose();
                        // Save the document...
                        filename3 = path + "/Uploads/Documents/" + projectName + ".pdf";
                        outputDocument.Save(filename3);

                        Response.ContentType = "Application/pdf";
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + projectName + ".pdf");
                        Response.TransmitFile(Server.MapPath(@"~/Uploads/Documents/" + projectName + ".pdf"));
                        Response.End();
                    }
                }
            }
        }
    }
}