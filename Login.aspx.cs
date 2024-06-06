using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace SSLSample
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void login(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["HomeSyncDB"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            string email = loginEmail.Text;
            string password = loginPassword.Text;
            if (email == "" || password == "")
                return;

            SqlCommand loginProc = new SqlCommand("UserLogin", conn);
            loginProc.CommandType = CommandType.StoredProcedure;
            loginProc.Parameters.Add(new SqlParameter("@email", email));
            loginProc.Parameters.Add(new SqlParameter("@password", password));
            SqlParameter success = loginProc.Parameters.Add("@success", SqlDbType.Int);
            SqlParameter idOut = loginProc.Parameters.Add("@user_id", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;
            idOut.Direction = ParameterDirection.Output;

            SqlCommand checkLoginProc = new SqlCommand("CheckLogin", conn);
            checkLoginProc.CommandType = CommandType.StoredProcedure;
            checkLoginProc.Parameters.Add(new SqlParameter("@email", email));
            checkLoginProc.Parameters.Add(new SqlParameter("@password", password));
            SqlParameter exists = checkLoginProc.Parameters.Add("@out", SqlDbType.Int);
            exists.Direction = ParameterDirection.Output;

            conn.Open();
            loginProc.ExecuteNonQuery();
            checkLoginProc.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "1")
            {
                try
                {
                    int id = Int32.Parse(idOut.Value.ToString());
                    Session["User"] = id;
                }
                catch (Exception) { }
                Response.Redirect("home.aspx");
            }
            else if(exists.Value.ToString() == "1")
            {
                Label l = new Label();
                l.Text = "Incorrect Email";
                errorMsg.Controls.Add(l);
            }
            else if (exists.Value.ToString() == "2")
            {
                Label l = new Label();
                l.Text = "Incorrect Password";
                errorMsg.Controls.Add(l);
            }
            else if (exists.Value.ToString() == "3")
            {
                Label l = new Label();
                l.Text = "Account Deleted, Doesn't Exist";
                errorMsg.Controls.Add(l);
            }
        }

        protected void goBack(object sender, EventArgs e)
        {
            Response.Redirect("HomeSync.aspx");
        }
    }
}