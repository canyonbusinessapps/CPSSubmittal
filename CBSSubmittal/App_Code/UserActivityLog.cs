using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace CBSSubmittal
{
    public class UserActivityLog
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

        public void UserActivityLogs(string _PageName, string _Action)
        {
            string strSQL = @"INSERT INTO [UserActivityLog](name, pageName, Activity, UserIP) values('" + HttpContext.Current.User.Identity.Name.ToString() + @"', '" + _PageName + @"', '" + _Action + @"', '" + GetIPAddress() + @"');";
            dbConnection.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(strSQL, dbConnection);
            object objResult = null;

            SqlCommand dbCommand = adpt.SelectCommand;
            dbCommand.CommandText = strSQL;
            dbCommand.CommandType = CommandType.Text;

            objResult = dbCommand.ExecuteScalar();
            adpt.Dispose();
            dbCommand.Dispose();
            dbConnection.Dispose();
        }

        protected string GetIPAddress()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

    }
}