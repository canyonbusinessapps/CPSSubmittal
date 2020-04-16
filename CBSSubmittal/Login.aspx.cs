using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.SessionState;

namespace CBSSubmittal
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (AuthenticateUser(txtUserName.Text, txtPassword.Text))
            {
                Session["FullName"] = getUserDetails(txtUserName.Text, "FullName");
                Session["UserName"] = txtUserName.Text;
                Session["Email"] = getUserDetails(txtUserName.Text, "Email");
                Session["RoleId"] = getUserDetails(txtUserName.Text, "RoleId");
                FormsAuthentication.RedirectFromLoginPage(txtUserName.Text, chkBoxRememberMe.Checked);
            }
            else
            {
                lblMessage.Text = "Invalid User Name and/or Password";
            }
        }

        private bool AuthenticateUser(string username, string password)
        {
            // ConfigurationManager class is in System.Configuration namespace
            string CS = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
            // SqlConnection is in System.Data.SqlClient namespace
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("spAuthenticateUser", con);
                cmd.CommandType = CommandType.StoredProcedure;

                // FormsAuthentication is in System.Web.Security
                string EncryptedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(password, "SHA1");
                // SqlParameter is in System.Data namespace
                SqlParameter paramUsername = new SqlParameter("@UserName", username);
                SqlParameter paramPassword = new SqlParameter("@Password", EncryptedPassword);

                cmd.Parameters.Add(paramUsername);
                cmd.Parameters.Add(paramPassword);

                con.Open();
                int ReturnCode = (int)cmd.ExecuteScalar();
                return ReturnCode == 1;
            }
        }

        public static string getUserDetails(string UserName, string columnName)
        {
            string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
            SqlConnection con = new SqlConnection(cnnString);
            string query = "SELECT " + columnName + " FROM [User] WHERE UserName = '" + UserName+"'";
            SqlCommand cmd = new SqlCommand(query, con);
            con.Open();
            string Output = cmd.ExecuteScalar().ToString();
            con.Close();
            return Output;
        }
    }
}