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
        UserActivityLog userActivityLog = new UserActivityLog();

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
                string query = "SELECT DocumentFile FROM [dbo].[Document] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string fileName = cmd.ExecuteScalar().ToString();

                userActivityLog.UserActivityLogs("Documents", "Download Document ID: " + DID);

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
                }
            }
        }

        protected void srcButton_Click(object sender, EventArgs e)
        {
            dbConnection.Open();
            SqlCommand sqlComm = new SqlCommand();
            string sqlQuery = "SELECT D.Id, P.ProjectName, D.DocumentName, D.DocumentFile, D.Details FROM [dbo].[Document] D LEFT JOIN [dbo].[Project] P ON D.ProjectId=P.Id WHERE D.ProjectId=" + Session["defaultProject"]+ " AND (D.DocumentName LIKE '%'+@DocumentName+'%' OR D.DocumentFile LIKE '%'+@DocumentName+'%' OR D.Details LIKE '%'+@DocumentName+'%')";
            sqlComm.CommandText = sqlQuery;
            sqlComm.Connection = dbConnection;
            sqlComm.Parameters.AddWithValue("DocumentName", txtSearch.Text);
            DataTable dt = new DataTable();
            SqlDataAdapter sda = new SqlDataAdapter(sqlComm);
            sda.Fill(dt);
            grdDocument.DataSource = dt;
            grdDocument.DataBind();
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

                    userActivityLog.UserActivityLogs("Documents", "Upload Document " + txtDocumentName.Text);

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

                userActivityLog.UserActivityLogs("Documents", "Delete Document " + fileName);

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

        protected void grdDocument_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdDocument.PageIndex = e.NewPageIndex;
            this.BindGrid();
        }

        protected void grdDocument_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdDocument.EditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void grdDocument_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            grdDocument.EditIndex = -1;
            this.BindGrid();

        }

        protected void grdDocument_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Find Id of edit row
            string id = grdDocument.DataKeys[e.RowIndex].Value.ToString();
            //Find updated values for update
            TextBox documentName = (TextBox)grdDocument.Rows[e.RowIndex].FindControl("txtDocumentName");
            TextBox details = (TextBox)grdDocument.Rows[e.RowIndex].FindControl("txtDetails");
            //Update query
            SqlCommand cmd = new SqlCommand("UPDATE [Document] SET [DocumentName]='" + documentName.Text + "', [Details]='" + details.Text + "' WHERE ID = " + id, dbConnection);

            dbConnection.Open();
            cmd.ExecuteNonQuery();
            dbConnection.Close();
            //Back to the grid
            grdDocument.EditIndex = -1;
            this.BindGrid();
        }

    }
}