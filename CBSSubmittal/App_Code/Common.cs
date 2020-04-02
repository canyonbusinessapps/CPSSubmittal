using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

public class Common
{

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

    public static string ddlProjects(string priceLevel)
    {
        string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
        SqlConnection con = new SqlConnection(cnnString);
        String Output = " ";
        SqlDataReader dataReader;
        string query = "SELECT [Id], [ProjectName] FROM [Project] ORDER BY [ProjectName] ASC";
        SqlCommand cmd = new SqlCommand(query, con);
        con.Open();
        dataReader = cmd.ExecuteReader();
        Output += "<select id='my_selection' class='form-control form-control-sm' onchange='window.location.href = this.value;'>";
        Output += "<option value='../Default.aspx?view=0'>Select a Project</option>";
        while (dataReader.Read())
        {
            if (priceLevel == dataReader.GetValue(0).ToString())
            {
                Output += "<option selected value='../Default.aspx?view=" + dataReader.GetValue(0) + "'>" + dataReader.GetValue(1) + "</option>";
            }
            else
            {
                Output += "<option value='../Default.aspx?view=" + dataReader.GetValue(0) + "'>" + dataReader.GetValue(1) + "</option>";
            }

        }
        Output += "</select>";
        dataReader.Close();
        dataReader.Dispose();
        con.Close();
        return Output;
    }
}
