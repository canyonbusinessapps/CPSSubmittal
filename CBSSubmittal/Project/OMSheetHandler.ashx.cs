using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace CBSSubmittal.Project
{
    /// <summary>
    /// Summary description for OMSheetHandler
    /// </summary>
    public class OMSheetHandler : IHttpHandler
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);
        UserActivityLog userActivityLog = new UserActivityLog();

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
                    //string FileName = context.Server.MapPath("~/Uploads/OMSheet/" + Path.GetFileName(PostedFile.FileName));
                    string FileName = context.Server.MapPath("~/Uploads/OMSheet/" + rndnumber + "_" + Path.GetFileName(PostedFile.FileName).Replace(" ", "_").ToLower());
                    PostedFile.SaveAs(FileName);

                    //save file name to the database table                    
                    string query = "INSERT INTO [dbo].[OMSheet] ([DocumentName],[DocumentFile],[Details]) VALUES (@DocumentName,@DocumentFile,@Details)";
                    SqlCommand cmd = new SqlCommand(query, dbConnection);
                    //get file name without extension
                    string strFileName = Path.GetFileName(PostedFile.FileName);
                    string strFileNameFinal = strFileName.Substring(0, strFileName.Length - 4);

                    cmd.Parameters.AddWithValue("@DocumentName", strFileNameFinal.ToString());
                    cmd.Parameters.AddWithValue("@DocumentFile", rndnumber + "_" + Path.GetFileName(PostedFile.FileName).Replace(" ", "_").ToLower());
                    cmd.Parameters.AddWithValue("@Details", strFileNameFinal.ToString());
                    cmd.ExecuteNonQuery();

                    //userActivityLog.UserActivityLogs("O&M Sheets", "Upload Sheet " + strFileNameFinal.ToString());
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