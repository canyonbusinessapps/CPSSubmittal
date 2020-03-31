using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

public class Common
{
    //SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

    public static string getProjectName(string Id)
    {
        string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
        SqlConnection con = new SqlConnection(cnnString);
        string query = "SELECT ProjectName FROM Project WHERE Id = " + Id;
        SqlCommand cmd = new SqlCommand(query, con);
        con.Open();
        string Output = cmd.ExecuteScalar().ToString();
        con.Close();
        return Output;
    }
}
