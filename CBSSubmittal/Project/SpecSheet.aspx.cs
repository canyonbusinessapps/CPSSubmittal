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
        UserActivityLog userActivityLog = new UserActivityLog();

        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
            }
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
                dbConnection.Open();
                int DID = Convert.ToInt32(docId);
                string query = "SELECT DocumentFile FROM [dbo].[SpecSheet] WHERE Id=" + DID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string fileName = cmd.ExecuteScalar().ToString();

                userActivityLog.UserActivityLogs("Spec Sheets", "Download Sheet ID: " + DID);

                Response.ContentType = "Application/pdf";
                Response.AppendHeader("Content-Disposition", "attachment; filename=~/Uploads/SpecSheet/" + fileName);
                Response.TransmitFile(Server.MapPath(@"~/Uploads/SpecSheet/" + fileName));
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
                    string delQuery = "SELECT COUNT(*) FROM [dbo].[DocumentRelation] WHERE DocumentType='SpecSheet' AND ProjectId=" + defaultProject + " AND DocumentId=" + Convert.ToInt32(docId.Text);
                    SqlCommand delcmd = new SqlCommand(delQuery, dbConnection);
                    int rowCount = Convert.ToInt32(delcmd.ExecuteScalar());
                    if (rowCount <= 0)
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO [DocumentRelation] ([DocumentType],[ProjectId],[DocumentId]) VALUES (@DocumentType,@ProjectId,@DocumentId)", dbConnection);
                        cmd.Parameters.AddWithValue("DocumentType", "SpecSheet");
                        cmd.Parameters.AddWithValue("ProjectId", defaultProject);
                        cmd.Parameters.AddWithValue("DocumentId", docId.Text);
                        int i = cmd.ExecuteNonQuery();
                    }
                }

            }
            dbConnection.Close();
            Response.Redirect("~/Project/SpecSheet.aspx");
        }

        protected void grdDocument_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {

                dbConnection.Open();
                Label dId = grdDocument.Rows[e.RowIndex].FindControl("DocumentId") as Label;
                //retive file name
                string queryDelete = "SELECT DocumentFile FROM SpecSheet WHERE Id = @docIdDel";
                SqlCommand cmdDelete = new SqlCommand(queryDelete, dbConnection);
                cmdDelete.Parameters.AddWithValue("@docIdDel", dId.Text);
                string fileName = cmdDelete.ExecuteScalar().ToString();

                //delete data from database                
                string query = "DELETE FROM [dbo].[SpecSheet] WHERE Id = @docId";
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                string path = HttpContext.Current.Request.PhysicalApplicationPath;
                cmd.Parameters.AddWithValue("@docId", dId.Text);
                cmd.ExecuteNonQuery();
                BindGrid();

                userActivityLog.UserActivityLogs("Spec Sheets", "Delete Sheet " + fileName);

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

        private void BindGrid()
        {
            using (SqlCommand cmd = new SqlCommand("SELECT SS.[Id], SS.[DocumentName], substring(SS.[DocumentFile],11,250) AS DocumentFile,(SELECT STUFF((SELECT  ', ' + [ProjectName] FROM (SELECT PRO.[ProjectName] AS [ProjectName] from [DocumentRelation] DRR LEFT JOIN [Project] PRO ON PRO.[Id] = DRR.[ProjectId]  WHERE DRR.[DocumentType]='SpecSheet' AND DRR.[DocumentId]=SS.[Id]) AS T FOR XML PATH('')),1,1,'')) AS [ProjectName] FROM [SpecSheet] SS", dbConnection))
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

        protected void grdDocument_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdDocument.PageIndex = e.NewPageIndex;
            this.BindGrid();
        }

        protected void srcButton_Click(object sender, EventArgs e)
        {
            dbConnection.Open();
            SqlCommand sqlComm = new SqlCommand();
            string sqlQuery = "SELECT SS.[Id], SS.[DocumentName], substring(SS.[DocumentFile],11,250) AS DocumentFile,(SELECT STUFF((SELECT  ', ' + [ProjectName] FROM (SELECT PRO.[ProjectName] AS [ProjectName] from [DocumentRelation] DRR LEFT JOIN [Project] PRO ON PRO.[Id] = DRR.[ProjectId]  WHERE DRR.[DocumentType]='SpecSheet' AND DRR.[DocumentId]=SS.[Id]) AS T FOR XML PATH('')),1,1,'')) AS [ProjectName] FROM [SpecSheet] SS WHERE SS.[DocumentName] LIKE '%'+@DocumentName+'%'";
            sqlComm.CommandText = sqlQuery;
            sqlComm.Connection = dbConnection;
            sqlComm.Parameters.AddWithValue("DocumentName", txtSearch.Text);
            DataTable dt = new DataTable();
            SqlDataAdapter sda = new SqlDataAdapter(sqlComm);
            sda.Fill(dt);
            grdDocument.DataSource = dt;
            grdDocument.DataBind();
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
            //Update query
            SqlCommand cmd = new SqlCommand("UPDATE [SpecSheet] SET [DocumentName]='" + documentName.Text + "' WHERE ID = " + id, dbConnection);

            dbConnection.Open();
            cmd.ExecuteNonQuery();
            dbConnection.Close();
            //Back to the grid
            grdDocument.EditIndex = -1;
            this.BindGrid();
        }

    }
}