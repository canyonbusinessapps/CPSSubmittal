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
    public partial class CreateUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            /// If the Page has no validation errors
            if (Page.IsValid)
            {
                // Read the connection string from web.config.
                // ConfigurationManager class is in System.Configuration namespace
                string CS = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
                // SqlConnection is in System.Data.SqlClient namespace
                using (SqlConnection con = new SqlConnection(CS))
                {
                    SqlCommand cmd = new SqlCommand("spCreateUser", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter fullname = new SqlParameter("@FullName", txtFullName.Text);
                    SqlParameter username = new SqlParameter("@UserName", txtUserName.Text);
                    // FormsAuthentication calss is in System.Web.Security namespace
                    string encryptedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Text, "SHA1");
                    SqlParameter password = new SqlParameter("@Password", encryptedPassword);
                    SqlParameter email = new SqlParameter("@Email", txtEmail.Text);

                    cmd.Parameters.Add(fullname);
                    cmd.Parameters.Add(username);
                    cmd.Parameters.Add(password);
                    cmd.Parameters.Add(email);

                    con.Open();
                    int ReturnCode = (int)cmd.ExecuteScalar();
                    if (ReturnCode == -1)
                    {
                        lblMessage.Text = "User Name already in use, please choose another user name";
                    }
                    else
                    {
                        Response.Redirect("~/Account/Users.aspx");
                    }
                }
            }
        }
    }
}