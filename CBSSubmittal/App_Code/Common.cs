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
        string webPath = ConfigurationManager.AppSettings["webPath"];
        string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
        SqlConnection con = new SqlConnection(cnnString);
        String Output = " ";
        SqlDataReader dataReader;
        string query = "SELECT [Id], [ProjectName] FROM [Project] ORDER BY [ProjectName] ASC";
        SqlCommand cmd = new SqlCommand(query, con);
        con.Open();
        dataReader = cmd.ExecuteReader();
        Output += "<select id='my_selection' class='form-control form-control-sm' onchange='window.location.href = this.value;'>";
        Output += "<option value='" + webPath + "Default.aspx?view=0'>Select a Project</option>";
        while (dataReader.Read())
        {
            if (priceLevel == dataReader.GetValue(0).ToString())
            {
                Output += "<option selected value='" + webPath + "Default.aspx?view=" + dataReader.GetValue(0) + "'>" + dataReader.GetValue(1) + "</option>";
            }
            else
            {
                Output += "<option value='" + webPath + "Default.aspx?view=" + dataReader.GetValue(0) + "'>" + dataReader.GetValue(1) + "</option>";
            }

        }
        Output += "</select>";
        dataReader.Close();
        dataReader.Dispose();
        con.Close();
        return Output;
    }

    public static string getDocumentFileName(string Id)
    {
        string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
        SqlConnection con = new SqlConnection(cnnString);
        string query = "SELECT DocumentFile FROM Document WHERE Id = " + Id;
        SqlCommand cmd = new SqlCommand(query, con);
        con.Open();
        string Output = cmd.ExecuteScalar().ToString();
        con.Close();
        return Output;
    }

    public static string getAllProjectsName(string docType, string Id)
    {
        string cnnString = ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString;
        SqlConnection con = new SqlConnection(cnnString);
        string query = "SELECT [ProjectId] FROM DocumentRelation WHERE [DocumentType]='" + docType + "' AND [DocumentId] = " + Id;
        SqlCommand cmd = new SqlCommand(query, con);
        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();
        string proName = null;
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                var tempName = reader.GetInt32(0);
                proName += Common.getProjectName(Convert.ToInt32(tempName).ToString()) + ", ";
            }
        }
        else
        {
            proName += "Not Linked";
        }
        reader.Close();

        return proName;
    }
}