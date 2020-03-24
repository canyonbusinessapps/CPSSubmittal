using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace CPSSubmittal.Project
{
    public partial class CreateProject : System.Web.UI.Page
    {
        SqlConnection dbConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContext"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindGrid();
            }
        }

        private void BindGrid()
        {
            dbConnection.Open();
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM [dbo].[Project]", dbConnection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    grdProject.DataSource = dt;
                    grdProject.DataBind();

                    if (grdProject.Rows.Count > 0)
                    {
                        //Adds THEAD and TBODY Section.
                        grdProject.HeaderRow.TableSection = TableRowSection.TableHeader;

                        //Adds TH element in Header Row.  
                        grdProject.UseAccessibleHeader = true;

                        //Adds TFOOT section. 
                        grdProject.FooterRow.TableSection = TableRowSection.TableFooter;
                    }
                }
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            try
            {
                dbConnection.Open();
                string query = "INSERT INTO [dbo].[Project] ([ProjectName],[Details],[Status]) VALUES (@ProjectName,@Details,@Status)";

                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.Parameters.AddWithValue("@ProjectName", txtProjectName.Text);
                cmd.Parameters.AddWithValue("@Details", txtDetails.Text);
                cmd.Parameters.AddWithValue("@Status", txtStatus.Text);
                cmd.ExecuteNonQuery();
                Response.Redirect("~/Project/CreateProject.aspx");
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

        protected void GridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                dbConnection.Open();
                int PID = Convert.ToInt32(grdProject.DataKeys[e.RowIndex].Value);
                string query = "DELETE FROM [dbo].[Project] WHERE Id=" + PID;
                SqlCommand cmd = new SqlCommand(query, dbConnection);
                cmd.ExecuteNonQuery();
                Response.Redirect("~/Project/CreateProject.aspx");                
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