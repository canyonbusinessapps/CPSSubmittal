using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CBSSubmittal
{
    public partial class ProjectMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("~/Logout.aspx");
            }

            if (Session["defaultProject"] == null)
                Session["defaultProject"] = 0;
        }
    }
}