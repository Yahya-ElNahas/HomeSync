using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSLSample
{
    public partial class Home : System.Web.UI.Page
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

                Label setGuestsL = new Label();
                setGuestsL.Text = "Set Allowed Guests: ";
                setGuestsLabel.Controls.Add(setGuestsL);

                Label deleteGuestsL = new Label();
                deleteGuestsL.Text = "Delete Guest: ";
                deleteGuestLabel.Controls.Add(deleteGuestsL);
            }
        }

        protected void logOut(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("HomeSync.aspx");
        }

        protected void goRooms(object sender, EventArgs e)
        {
            Response.Redirect("RoomPage.aspx");
        }

        protected void goTasks(object sender, EventArgs e)
        {
            Response.Redirect("TasksPage.aspx");
        }

        protected void goEvents(object sender, EventArgs e)
        {
            Response.Redirect("EventsPage.aspx");
        }

        protected void goDevices(object sender, EventArgs e)
        {
            Response.Redirect("DevicePage.aspx");
        }

        protected void goFinance(object sender, EventArgs e)
        {
            Response.Redirect("FinanceComm.aspx");
        }

        protected void setNumOfGuests(object sender, EventArgs e)
        {
            if (!tp.ToLower().Equals("admin"))
            {
                Label l = new Label();
                l.Text = "You are a Guest";
                mainLabel.Controls.Add(l);
                return;
            }
            if (setGuests.Text == "" || setGuests.Text == null)
                return;
            SqlCommand setGuestsProc = new SqlCommand("GuestsAllowed", conn);
            setGuestsProc.CommandType = CommandType.StoredProcedure;
            setGuestsProc.Parameters.Add(new SqlParameter("@admin_id", user_id));
            setGuestsProc.Parameters.Add(new SqlParameter("@number_of_guests", Int16.Parse(setGuests.Text)));
            conn.Open();
            setGuestsProc.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("Home.aspx");
        }

        protected void deleteGuest(object sender, EventArgs e)
        {
            if (!tp.ToLower().Equals("admin"))
            {
                Label l = new Label();
                l.Text = "You are a Guest";
                mainLabel.Controls.Add(l);
                return;
            }
            if (deleteGuestTxt.Text == "" || deleteGuestTxt.Text == null)
                return;
            SqlCommand deleteGuestProc = new SqlCommand("GuestRemove", conn);
            deleteGuestProc.CommandType = CommandType.StoredProcedure;
            deleteGuestProc.Parameters.Add(new SqlParameter("@admin_id", user_id));
            deleteGuestProc.Parameters.Add(new SqlParameter("@guest_id", Int16.Parse(deleteGuestTxt.Text)));
            SqlParameter allowedGuests = deleteGuestProc.Parameters.Add("@number_of_allowed_guests", SqlDbType.Int);
            allowedGuests.Direction = ParameterDirection.Output;
            conn.Open();
            deleteGuestProc.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("Home.aspx");
        }
    }
}