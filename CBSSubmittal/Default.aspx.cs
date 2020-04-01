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
            string reqProject = Request.QueryString["view"];
            if (reqProject != null)
            {
                Session["defaultProject"] = Convert.ToInt32(reqProject).ToString();
                string Path = ResolveUrl("Default.aspx");
                Response.Redirect(Path);
            }
        }

        protected void Update_Ordering(object sender, EventArgs e)
        {
            try
            {
                var txtOrdering = (TextBox)sender;
                var row = (GridViewRow)txtOrdering.NamingContainer;
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = ((sender as TextBox).NamingContainer as GridViewRow).RowIndex;
                int Ordering = Convert.ToInt32(txtOrdering.Text);
                int Id = Convert.ToInt32(grdDocuments.DataKeys[rowIndex].Values[0]);

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