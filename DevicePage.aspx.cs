using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;

namespace SSLSample
{
    public partial class DevicePage : System.Web.UI.Page
    {
        string tp = "";
        int user_id;
        string connStr;
        SqlConnection conn;
        protected void Page_Load(object sender, EventArgs e)
        {
            user_id = Int32.Parse(Session["User"] + "");
            connStr = WebConfigurationManager.ConnectionStrings["HomeSyncDB"].ToString();
            conn = new SqlConnection(connStr);

            SqlCommand viewProfile = new SqlCommand("ViewProfile", conn);
            viewProfile.CommandType = CommandType.StoredProcedure;
            viewProfile.Parameters.Add(new SqlParameter("@user_id", user_id));
            conn.Open();
            SqlDataReader reader = viewProfile.ExecuteReader(CommandBehavior.CloseConnection);
            if (reader.Read())
            {
                Label lf = new Label();
                Label ll = new Label();
                lf.Text = reader.GetString(reader.GetOrdinal("first_name")) + " ";
                ll.Text = reader.GetString(reader.GetOrdinal("last_name"));
                userFirstName.Controls.Add(lf);
                userLastName.Controls.Add(ll);

                Label l1 = new Label();
                l1.Text = reader.GetInt32(reader.GetOrdinal("user_id")).ToString();
                userID.Controls.Add(l1);
                Label lt = new Label();
                tp = reader.GetString(reader.GetOrdinal("type"));
                lt.Text = tp;
                userType.Controls.Add(lt);
                Label l2 = new Label();
                l2.Text = reader.GetString(reader.GetOrdinal("email"));
                userEmail.Controls.Add(l2);
                Label l3 = new Label();
                l3.Text = reader.GetValue(reader.GetOrdinal("room")).ToString();
                userRoom.Controls.Add(l3);
                Label l4 = new Label();
                l4.Text = reader.GetInt32(reader.GetOrdinal("age")).ToString();
                userAge.Controls.Add(l4);
            }
            conn.Close();
            if (tp.ToLower().Equals("admin"))
            {
                SqlCommand getNumGuestsProc = new SqlCommand("GuestNumber", conn);
                getNumGuestsProc.CommandType = CommandType.StoredProcedure;
                getNumGuestsProc.Parameters.Add(new SqlParameter("@admin_id", user_id));
                SqlParameter numGuests = getNumGuestsProc.Parameters.Add("@guest_num", SqlDbType.Int);
                numGuests.Direction = ParameterDirection.Output;

                SqlCommand getAllowedGuestsProc = new SqlCommand("GetAllowedGuests", conn);
                getAllowedGuestsProc.CommandType = CommandType.StoredProcedure;
                getAllowedGuestsProc.Parameters.Add(new SqlParameter("@admin_id", user_id));
                SqlParameter allowedGuests = getAllowedGuestsProc.Parameters.Add("@allowedGuests", SqlDbType.Int);
                allowedGuests.Direction = ParameterDirection.Output;

                conn.Open();
                getNumGuestsProc.ExecuteNonQuery();
                getAllowedGuestsProc.ExecuteNonQuery();
                conn.Close();
                Label nGuests = new Label();
                nGuests.Text = "Number of Guests: " + numGuests.Value.ToString();
                numOfGuests.Controls.Add(nGuests);

                Label aGuests = new Label();
                aGuests.Text = "Allowed Guests: " + allowedGuests.Value.ToString();
                numAllowedGuests.Controls.Add(aGuests);
            }
        }
        protected void goHome(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }

        protected void ExecuteViewMyDeviceCharge(object sender, EventArgs e)
        {
            if (DeviceID.Text == "")
                return;
            int device_id = Int32.Parse(DeviceID.Text);
            SqlCommand viewMyDeviceCharge = new SqlCommand("ViewMyDeviceCharge", conn);
            viewMyDeviceCharge.CommandType = CommandType.StoredProcedure;
            viewMyDeviceCharge.Parameters.AddWithValue("@device_id", device_id); 
            viewMyDeviceCharge.Parameters.Add("@charge", SqlDbType.Int).Direction = ParameterDirection.Output;
            viewMyDeviceCharge.Parameters.Add("@location", SqlDbType.Int).Direction = ParameterDirection.Output;

            conn.Open();
            viewMyDeviceCharge.ExecuteNonQuery();
            conn.Close() ;

            int charge = Convert.ToInt32(viewMyDeviceCharge.Parameters["@charge"].Value);
            int location = Convert.ToInt32(viewMyDeviceCharge.Parameters["@location"].Value);

            Label l = new Label();
            l.Text = "Charge: " + charge + ", In Room: " + location;
            mainLabel.Controls.Add(l);
        }

        protected void ExecuteAddDevice(object sender, EventArgs e)
        {
            if(tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            if (DeviceID.Text == "" || DeviceBattery.Text == "" || DeviceLoc.Text == "")
                return;
            int device_id = Int32.Parse(DeviceID.Text);
            string status = DeviceStatus.Text;
            int battery = Convert.ToInt32(DeviceBattery.Text);
            int location = Convert.ToInt32(DeviceLoc.Text);
            string type = DeviceType.Text;
            SqlCommand addDevice = new SqlCommand("AddDevice", conn);
            addDevice.CommandType = CommandType.StoredProcedure;
            addDevice.Parameters.AddWithValue("@device_id", device_id); 
            addDevice.Parameters.AddWithValue("@status", status); 
            addDevice.Parameters.AddWithValue("@battery", battery); 
            addDevice.Parameters.AddWithValue("@location", location); 
            addDevice.Parameters.AddWithValue("@type", type); 

            conn.Open();
            addDevice.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("DevicePage.aspx");
        }

        protected void ExecuteOutOfBattery(object sender, EventArgs e)
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            SqlCommand outOfBattery = new SqlCommand("OutOfBattery", conn);
            outOfBattery.CommandType = CommandType.StoredProcedure;

            conn.Open();
            SqlDataReader reader = outOfBattery.ExecuteReader();

            while (reader.Read())
            {
                string room = reader["room"].ToString();
                Label r = new Label();
                r.Text = "Room Number: " + room;
                mainLabel.Controls.Add(r);
            }

            conn.Close();
        }

        protected void ExecuteCharging(object sender, EventArgs e)
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            SqlCommand charging = new SqlCommand("Charging", conn);
            charging.CommandType = CommandType.StoredProcedure;

            conn.Open();
            charging.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("DevicePage.aspx");
        }

        protected void ExecuteNeedCharge(object sender, EventArgs e)
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            SqlCommand needCharge = new SqlCommand("NeedCharge", conn);
            needCharge.CommandType = CommandType.StoredProcedure;

            conn.Open();
            SqlDataReader reader = needCharge.ExecuteReader();

            while (reader.Read())
            {
                Label r = new Label();
                Label no = new Label();

                r.Text = "Room Number: " + reader.GetInt32(reader.GetOrdinal("room")).ToString() + ", ";
                mainLabel.Controls.Add(r);

                no.Text = "Number of dead devices: " + reader.GetInt32(reader.GetOrdinal("Number of dead devices")).ToString();
                nameLabel.Controls.Add(no);
            }

            conn.Close();
        }

    }
}