using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CBSSubmittal.Account
{
    public partial class ChangePasswordUser : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var userName = HttpContext.Current.Session["UserName"].ToString();

            if (userName != "" && ChangeUserPasswordUsingCurrentPassword())
            {
                lblMessage.Text = "Password Changed Successfully!";
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid Current Password!";
            }
        }

        private bool ExecuteSP(string SPName, List<SqlParameter> SPParameters)
        {
            string CS = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand(SPName, con);
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (SqlParameter parameter in SPParameters)
                {
                    cmd.Parameters.Add(parameter);
                }

                con.Open();
                return Convert.ToBoolean(cmd.ExecuteScalar());
            }
        }

        private bool ChangeUserPasswordUsingCurrentPassword()
        {
            List<SqlParameter> paramList = new List<SqlParameter>()
            {
                new SqlParameter()
                {
                    ParameterName = "@UserName",
                    Value = HttpContext.Current.Session["UserName"].ToString()
        },
                new SqlParameter()
                {
                    ParameterName = "@CurrentPassword",
                    Value = FormsAuthentication.HashPasswordForStoringInConfigFile(txtCurrentPassword.Text, "SHA1")
                },
                new SqlParameter()
                {
                    ParameterName = "@NewPassword",
                    Value = FormsAuthentication.HashPasswordForStoringInConfigFile(txtNewPassword.Text, "SHA1")
                }
            };

            return ExecuteSP("spChangePasswordUsingCurrentPassword", paramList);
        }
    }
}