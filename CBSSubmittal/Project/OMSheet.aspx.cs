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
    public partial class OMSheet : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        UserActivityLog userActivityLog = new UserActivityLog();

        protected void Page_PreInit(object sender, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
            }

            string docId = Request.QueryString["Id"];
            if (docId != null)
            {
                dbConnection.Open();
                int DID = Convert.ToInt32(docId);
                string query = "SELECT DocumentFile FROM [dbo].[OMSheet] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string fileName = cmd.ExecuteScalar().ToString();

                userActivityLog.UserActivityLogs("O&M Sheets", "Download Sheet ID: " + DID);

                Response.ContentType = "Application/pdf";
                Response.AppendHeader("Content-Disposition", "attachment; filename=~/Uploads/OMSheet/" + fileName);
                Response.TransmitFile(Server.MapPath(@"~/Uploads/OMSheet/" + fileName));
                Response.End();
                dbConnection.Close();
            }

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            dbConnection.Open();
            foreach (GridViewRow gvrow in grdDocument.Rows)
            {
                var checkbox = gvrow.FindControl("CheckBoxId") as CheckBox;
                if (checkbox.Checked)
                {
                    var defaultProject = Convert.ToInt32(Session["defaultProject"]).ToString();
                    var docId = gvrow.FindControl("DocumentId") as Label;

                    //check already attched with project or not
                    string delQuery = "SELECT COUNT(*) FROM [dbo].[DocumentRelation] WHERE DocumentType='OMSheet' AND ProjectId=" + defaultProject + " AND DocumentId=" + Convert.ToInt32(docId.Text);
                    SqlCommand delcmd = new SqlCommand(delQuery, dbConnection);
                    int rowCount = Convert.ToInt32(delcmd.ExecuteScalar());
                    if (rowCount <= 0)
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO [DocumentRelation] ([DocumentType],[ProjectId],[DocumentId]) VALUES (@DocumentType,@ProjectId,@DocumentId)", dbConnection);
                        cmd.Parameters.AddWithValue("DocumentType", "OMSheet");
                        cmd.Parameters.AddWithValue("ProjectId", defaultProject);
                        cmd.Parameters.AddWithValue("DocumentId", docId.Text);
                        int i = cmd.ExecuteNonQuery();
                    }
                }

            }
            dbConnection.Close();
            Response.Redirect("~/Project/OMSheet.aspx");
        }

        protected void GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {

                dbConnection.Open();
                int DID = Convert.ToInt32(grdDocument.DataKeys[e.RowIndex].Value);

                //retive file name
                string queryDelete = "SELECT DocumentFile FROM OMSheet WHERE Id = " + DID;
                SqlCommand cmdDelete = new SqlCommand(queryDelete, dbConnection);
                string fileName = cmdDelete.ExecuteScalar().ToString();

                //delete data from database                
                string query = "DELETE FROM [dbo].[OMSheet] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string path = HttpContext.Current.Request.PhysicalApplicationPath;
                cmd.ExecuteNonQuery();

                userActivityLog.UserActivityLogs("O&M Sheets", "Delete Sheet " + fileName);

                //delete related file                
                if (File.Exists(path + "/Uploads/OMSheet/" + fileName))
                {
                    File.Delete(path + "/Uploads/OMSheet/" + fileName);
                }

                Response.Redirect("~/Project/OMSheet.aspx");
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