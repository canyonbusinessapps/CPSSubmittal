using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace CBSSubmittal.Project
{
    public partial class CreateProject : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        UserActivityLog userActivityLog = new UserActivityLog();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            try
            {
                dbConnection.Open();
                string query = "INSERT INTO [dbo].[Project] ([ProjectName],[Details],[Status]) VALUES (@ProjectName,@Details,@Status)";

                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.Parameters.AddWithValue("@ProjectName", txtProjectName.Text);
                cmd.Parameters.AddWithValue("@Details", txtDetails.Text);
                cmd.Parameters.AddWithValue("@Status", txtStatus.Text);
                cmd.ExecuteNonQuery();

                userActivityLog.UserActivityLogs("Project", "Create project " + txtProjectName.Text);

                Response.Redirect("~/Project/CreateProject.aspx");
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