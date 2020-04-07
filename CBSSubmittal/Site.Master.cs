using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CBSSubmittal
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string webPath = ConfigurationManager.AppSettings["webPath"];

            if (Session["UserName"] == null)
            {
                Response.Redirect(webPath+"Logout.aspx");
            }            

            if (Session["defaultProject"] == null)
                Session["defaultProject"] = 0;

            if (Int32.Parse(Session["defaultProject"].ToString()) == 0)
            {
                string Path = ResolveUrl(webPath+ "Project/Projects.aspx");
                Response.Redirect(Path);
            }
        }
    }
}