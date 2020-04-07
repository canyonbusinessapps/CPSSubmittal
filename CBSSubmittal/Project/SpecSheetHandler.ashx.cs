using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

namespace CBSSubmittal.Project
{
    /// <summary>
    /// Summary description for SpecSheetHandler
    /// </summary>
    public class SpecSheetHandler : IHttpHandler
    {

        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

        public void ProcessRequest(HttpContext context)
        {
            if (context.Request.Files.Count > 0)
            {
                dbConnection.Open();
                HttpFileCollection selectedFiles = context.Request.Files;
                for (int i = 0; i < selectedFiles.Count; i++)
                {
                    //save files to the specifiede folder
                    string rndnumber = String.Format("{0:d9}", (DateTime.Now.Ticks / 10) % 1000000000);
                    System.Threading.Thread.Sleep(1000);
                    HttpPostedFile PostedFile = selectedFiles[i];
                    //string FileName = context.Server.MapPath("~/Uploads/SpecSheet/" + Path.GetFileName(PostedFile.FileName));
                    string FileName = context.Server.MapPath("~/Uploads/SpecSheet/" + rndnumber + "_" + Path.GetFileName(PostedFile.FileName).Replace(" ", "_").ToLower());
                    PostedFile.SaveAs(FileName);

                    //save file name to the database table                    
                    string query = "INSERT INTO [dbo].[SpecSheet] ([DocumentName],[DocumentFile],[Details]) VALUES (@DocumentName,@DocumentFile,@Details)";
                    SqlCommand cmd = new SqlCommand(query, dbConnection);
                    //get file name without extension
                    string strFileName = Path.GetFileName(PostedFile.FileName);
                    string strFileNameFinal = strFileName.Substring(0, strFileName.Length - 4);

                    cmd.Parameters.AddWithValue("@DocumentName", strFileNameFinal.ToString());
                    cmd.Parameters.AddWithValue("@DocumentFile", rndnumber + "_" + Path.GetFileName(PostedFile.FileName).Replace(" ", "_").ToLower());
                    cmd.Parameters.AddWithValue("@Details", strFileNameFinal.ToString());
                    cmd.ExecuteNonQuery();
                }
            }
            dbConnection.Close();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}