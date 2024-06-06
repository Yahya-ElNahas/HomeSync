using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSLSample
{
    public partial class EventsPage : System.Web.UI.Page
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

        protected void CreateEvent_Click(object sender, EventArgs e)
        {
            if (EventUserID.Text == "")
                return;
            int otherUserID = Convert.ToInt32(EventUserID.Text); 
            string eventName = EventName.Text.Trim();
            string desc = EventDesc.Text.Trim();
            string loc = EventLoc.Text.Trim();
            string rem = EventRem.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "CreateEvent";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@user_id", user_id);
                    cmd.Parameters.AddWithValue("@name", eventName);
                    cmd.Parameters.AddWithValue("@description", desc);
                    cmd.Parameters.AddWithValue("@location", loc);
                    cmd.Parameters.AddWithValue("@reminder_date", rem);
                    cmd.Parameters.AddWithValue("@other_user_id", otherUserID);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    conn.Close();
                }
                Response.Redirect("EventsPage.aspx");
            }
        }

        protected void AssignUser_Click(object sender, EventArgs e)
        {
            if (EventUserID.Text == "")
                return;
            int eventID = Convert.ToInt32(EventID.Text);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "AssignUser";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@user_id", user_id);
                    cmd.Parameters.AddWithValue("@event_id", eventID);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                    

                }
            }
            Response.Redirect("EventsPage.aspx");
        }

        protected void UninviteUser_Click(object sender, EventArgs e)
        {
            if (EventUserID.Text == "")
                return;
            int eventID = Convert.ToInt32(EventID.Text);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "Uninvited";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@event_id", eventID);
                    cmd.Parameters.AddWithValue("@user_id", user_id);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
            Response.Redirect("EventsPage.aspx");
        }

        protected void ViewEvent_Click(object sender, EventArgs e)
        {
            int eventID = 0;
            if (EventID.Text != "")
                eventID = Convert.ToInt32(EventID.Text);

            DataTable events = GetEvents(eventID);
            gridMessages.DataSource = events;
            gridMessages.DataBind();
        }

        private DataTable GetEvents(int eventID)
        {
            DataTable events = new DataTable();

            SqlCommand cmd = new SqlCommand("ViewEvent", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@event_id", eventID)); 
            cmd.Parameters.AddWithValue("@user_id", user_id);
            conn.Open();

            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(events);
            }
            conn.Close();
            return events;
        }
    }
}