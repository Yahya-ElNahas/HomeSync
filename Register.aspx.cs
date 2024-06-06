using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSLSample
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void register(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["HomeSyncDB"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            string fname = regFirstName.Text;
            string lname = regLastName.Text;
            string email = regEmail.Text;
            string type = regType.Text;
            string birthDate = regBirthDate.Text;
            string password = regPassword.Text;
            if(fname == "" || lname == "" || email == "" || type == "" || birthDate == "" || password == "")
                return;

            SqlCommand checkEmailProc = new SqlCommand("CheckEmailExists", conn);
            checkEmailProc.CommandType = CommandType.StoredProcedure;
            checkEmailProc.Parameters.Add(new SqlParameter("@email", email));
            SqlParameter exists = checkEmailProc.Parameters.Add("@emailExists", SqlDbType.Int);
            exists.Direction = ParameterDirection.Output;

            conn.Open();
            checkEmailProc.ExecuteNonQuery();
            conn.Close();

            if(exists.Value.ToString() == "1")
            {
                Label label = new Label();
                label.Text = "Email Already Exists";
                existsLabel.Controls.Add(label);
                return;
            }

            SqlCommand registerProc = new SqlCommand("UserRegister", conn);
            registerProc.CommandType = CommandType.StoredProcedure;
            registerProc.Parameters.Add(new SqlParameter("@usertype", type));
            registerProc.Parameters.Add(new SqlParameter("@email", email));
            registerProc.Parameters.Add(new SqlParameter("@first_name", fname));
            registerProc.Parameters.Add(new SqlParameter("@last_name", lname));
            registerProc.Parameters.Add(new SqlParameter("@birth_date", birthDate));
            registerProc.Parameters.Add(new SqlParameter("@password", password));

            SqlParameter idOut = registerProc.Parameters.Add("@user_id", SqlDbType.Int);
            idOut.Direction = ParameterDirection.Output;

            conn.Open();
            registerProc.ExecuteNonQuery();
            conn.Close();

            try
            {
                int id = Int32.Parse(idOut.Value.ToString());
                Session["User"] = id;
            }
            catch (Exception) { }
            Response.Redirect("Home.aspx");
        }
        protected void goBack(object sender, EventArgs e)
        {
            Response.Redirect("HomeSync.aspx");
        }
    }
}