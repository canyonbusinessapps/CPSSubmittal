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
    public partial class SpecSheet : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

        protected void Page_PreInit(object sender, EventArgs e)
        {

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
                string query = "SELECT DocumentFile FROM [dbo].[SpecSheet] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string fileName = cmd.ExecuteScalar().ToString();

                Response.ContentType = "Application/pdf";
                Response.AppendHeader("Content-Disposition", "attachment; filename=~/Uploads/SpecSheet/" + fileName);
                Response.TransmitFile(Server.MapPath(@"~/Uploads/SpecSheet/" + fileName));
                Response.End();
                dbConnection.Close();
            }

        }

        private void BindGrid()
        {
            dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand("SELECT D.Id, D.DocumentName, substring(D.DocumentFile,11,250) AS DocumentFile, D.Details FROM [dbo].[SpecSheet] D", dbConnection))
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

        protected void GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {

                dbConnection.Open();
                int DID = Convert.ToInt32(grdDocument.DataKeys[e.RowIndex].Value);

                //retive file name
                string queryDelete = "SELECT DocumentFile FROM SpecSheet WHERE Id = " + DID;
                SqlCommand cmdDelete = new SqlCommand(queryDelete, dbConnection);
                string fileName = cmdDelete.ExecuteScalar().ToString();

                //delete data from database                
                string query = "DELETE FROM [dbo].[SpecSheet] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string path = HttpContext.Current.Request.PhysicalApplicationPath;
                cmd.ExecuteNonQuery();

                //delete related file                
                if (File.Exists(path + "/Uploads/SpecSheet/" + fileName))
                {
                    File.Delete(path + "/Uploads/SpecSheet/" + fileName);
                }

                Response.Redirect("~/Project/SpecSheet.aspx");
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