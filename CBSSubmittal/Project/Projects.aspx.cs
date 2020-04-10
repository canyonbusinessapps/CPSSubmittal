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
    public partial class Projects : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        string path = HttpContext.Current.Request.PhysicalApplicationPath;
        string webPath = ConfigurationManager.AppSettings["webPath"];
        UserActivityLog userActivityLog = new UserActivityLog();

        protected void Page_Load(object sender, EventArgs e)
        {
            string reqProject = Request.QueryString["view"];
            if (reqProject != null)
            {
                userActivityLog.UserActivityLogs("Projects", "Select default project");

                Session["defaultProject"] = Convert.ToInt32(reqProject).ToString();
                Response.Redirect(webPath + "Default.aspx");
            }
        }
    }
}