using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CBSSubmittal
{
    public partial class _Default : Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["defaultProject"] = 11;
        }
        protected void Update_Ordering(object sender, EventArgs e)
        {
            try
            {
                //int Ordering = Convert.ToInt32(txtOrdering.Text);
                //int Id = Convert.ToInt32(txtId.Text);
                int Ordering = Convert.ToInt32(5);
                int Id = Convert.ToInt32(15);

                dbConnection.Open();
                string query = "UPDATE [dbo].[Document] SET [Ordering]=" + Ordering + " WHERE Id=" + @Id;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Response.Write("error" + ex.ToString());
            }
            finally
            {
                dbConnection.Close();
            }
        }
    }
}