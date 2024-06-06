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
    public partial class RoomPage : System.Web.UI.Page
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

        protected void ViewAssignedRoom(object sender, EventArgs e)
        {
            DataTable room = getAssignedRoom();
            gridMessages.DataSource = room;
            gridMessages.DataBind();
        }

        private DataTable getAssignedRoom()
        {
            DataTable room = new DataTable();

            SqlCommand command = new SqlCommand("ViewAssignedRoom", conn);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@user_id", user_id));
            conn.Open();

            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
              
                adapter.Fill(room);
            }
            conn.Close();
            return room;
        }

        protected void AssignRoom(object sender, EventArgs e)
        {
            if (RoomID.Text == "")
                return;
            int roomID = Int32.Parse(RoomID.Text);
            using (SqlCommand command = new SqlCommand("AssignRoom", conn))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@user_id", user_id));
                command.Parameters.Add(new SqlParameter("@room_id", roomID));

                conn.Open();
                command.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("RoomPage.aspx");
        }

        protected void CreateSchedule(object sender, EventArgs e)
        {
            if(tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            if (RoomID.Text == "")
                return;
            int roomID = Int32.Parse(RoomID.Text);
            string startTime = SchedStart.Text;
            string endTime = SchedEnd.Text;
            string action = SchedAct.Text;
            using (SqlCommand command = new SqlCommand("CreateSchedule", conn))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@creator_id", user_id));
                command.Parameters.Add(new SqlParameter("@room_id", roomID));
                command.Parameters.Add(new SqlParameter("@start_time", startTime));
                command.Parameters.Add(new SqlParameter("@end_time", endTime));
                command.Parameters.Add(new SqlParameter("@action", action));

                conn.Open();
                command.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("RoomPage.aspx");
        }

        protected void RoomAvailability(object sender, EventArgs e)
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            if (RoomID.Text == "")
                return;
            int location = Int32.Parse(RoomID.Text);
            string status = Rstatus.Text;
            using (SqlCommand command = new SqlCommand("RoomAvailability", conn))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@location", location));
                command.Parameters.Add(new SqlParameter("@status", status));

                conn.Open();
                command.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("RoomPage.aspx");
        }

        protected void ViewRoom(object sender, EventArgs e)
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            DataTable room = getRoom();
            gridMessages.DataSource = room;
            gridMessages.DataBind();
        }

        private DataTable getRoom()
        {
            DataTable room = new DataTable();

            SqlCommand command = new SqlCommand("ViewRoom", conn);
            command.CommandType = CommandType.StoredProcedure;
            conn.Open();

            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                // Fill the DataTable with the results
                adapter.Fill(room);
            }
            conn.Close();
            return room;
        }
    }
}