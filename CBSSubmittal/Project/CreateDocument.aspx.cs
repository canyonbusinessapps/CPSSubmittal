using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services.Description;
using System.Text.RegularExpressions;
using System.IO;

namespace CBSSubmittal.Project
{
    public partial class CreateDocument : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        //string cnnString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            //if (Int32.Parse(Session["defaultProject"].ToString()) == 0)
            //{
            //    string Path = ResolveUrl("~/Default.aspx");
            //    Response.Redirect(Path);
            //}
        }

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
            using (SqlCommand cmd = new SqlCommand("SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details FROM [dbo].[Document] D LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id WHERE D.ProjectId=" + Session["defaultProject"], dbConnection))
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
            string rndnumber = String.Format("{0:d9}", (DateTime.Now.Ticks / 10) % 1000000000);
            strSaveFileAs = Server.MapPath("~/Uploads/Documents/" + rndnumber + "_" + fileDocumentFile.FileName.Replace(" ", "_").ToLower());

            try
            {
                if (fileDocumentFile.HasFile)
                {
                    fileDocumentFile.SaveAs(strSaveFileAs);

                    dbConnection.Open();
                    string query = "INSERT INTO [dbo].[Document] ([ProjectId],[DocumentName],[DocumentFile],[Details]) VALUES (@ProjectId,@DocumentName,@DocumentFile,@Details)";

                    SqlCommand cmd = new SqlCommand(query, dbConnection);
                    //cmd.Parameters.AddWithValue("@ProjectId", Convert.ToInt32(txtProjectId.Text).ToString());
                    cmd.Parameters.AddWithValue("@ProjectId", Convert.ToInt32(Session["defaultProject"]).ToString());
                    cmd.Parameters.AddWithValue("@DocumentName", txtDocumentName.Text);
                    cmd.Parameters.AddWithValue("@DocumentFile", rndnumber + "_" + fileDocumentFile.FileName.Replace(" ", "_").ToLower());
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

        protected void GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {

                dbConnection.Open();
                int DID = Convert.ToInt32(grdDocument.DataKeys[e.RowIndex].Value);

                //retive file name
                string queryDelete = "SELECT DocumentFile FROM Document WHERE Id = " + DID;
                SqlCommand cmdDelete = new SqlCommand(queryDelete, dbConnection);
                string fileName = cmdDelete.ExecuteScalar().ToString();

                //delete data from database                
                string query = "DELETE FROM [dbo].[Document] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string path = HttpContext.Current.Request.PhysicalApplicationPath;
                cmd.ExecuteNonQuery();

                //delete related file                
                if (File.Exists(path + "/Uploads/Documents/" + fileName))
                {
                    File.Delete(path + "/Uploads/Documents/" + fileName);
                }

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