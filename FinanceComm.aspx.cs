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
    public partial class FinanceComm : System.Web.UI.Page
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

        protected void ReceiveTransaction(object sender, EventArgs e)
        {
            if (FinAmount.Text == "")
                return;
            string type = FinType.Text;
            int amount = Int32.Parse(FinAmount.Text);
            string description = FinDesc.Text;
            string date = FinDate.Text;
            using (SqlCommand cmd = new SqlCommand("ReceiveMoney", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@receiver_id", user_id));
                cmd.Parameters.Add(new SqlParameter("@type", type));
                cmd.Parameters.Add(new SqlParameter("@amount", amount));
                cmd.Parameters.Add(new SqlParameter("@description", description));
                cmd.Parameters.Add(new SqlParameter("@date", date));

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("FinanceComm.aspx");
        }

        protected void SendMoney(object sender, EventArgs e)
        {
            if (FinRec.Text == "" || FinAmount.Text == "")
                return;
            int receiverId = Int32.Parse(FinRec.Text);
            int amount = Int32.Parse(FinAmount.Text);
            string status = FinStatus.Text;
            string deadline = FinDue.Text;
            using (SqlCommand cmd = new SqlCommand("PlanPayment", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@sender_id", user_id));
                cmd.Parameters.Add(new SqlParameter("@reciever_id", receiverId));
                cmd.Parameters.Add(new SqlParameter("@amount", amount));
                cmd.Parameters.Add(new SqlParameter("@status", status));
                cmd.Parameters.Add(new SqlParameter("@deadline", deadline));

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("FinanceComm.aspx");
        }

        protected void SendMessage_Click(object sender, EventArgs e)
        {
            if (CommRec.Text == "")
                return;
            int receiverID = Int32.Parse(CommRec.Text);
            string title = CommTitle.Text;
            string content = CommCont.Text;
            using (SqlCommand cmd = new SqlCommand("SendMessage", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Add parameters
                cmd.Parameters.Add(new SqlParameter("@sender_id", user_id));
                cmd.Parameters.Add(new SqlParameter("@receiver_id", receiverID));
                cmd.Parameters.Add(new SqlParameter("@title", title));
                cmd.Parameters.Add(new SqlParameter("@content", content));
                cmd.Parameters.Add(new SqlParameter("@timesent", DateTime.Now));
                cmd.Parameters.Add(new SqlParameter("@timereceived", DateTime.Now));

                // Open connection and execute the stored procedure
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("FinanceComm.aspx");
        }

        protected void ShowMessages_Click(object sender, EventArgs e)
        {
            if (CommRec.Text == "")
                return;
            // Call the stored procedure
            DataTable messages = GetMessagesFromDatabase(user_id, Int32.Parse(CommRec.Text));

            // Bind the retrieved messages to the GridView
            gridMessages.DataSource = messages;
            gridMessages.DataBind();
        }

        private DataTable GetMessagesFromDatabase(int userID, int senderID)
        {
            DataTable messages = new DataTable();

            using (SqlCommand cmd = new SqlCommand("ShowMessages", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Add parameters
                cmd.Parameters.Add(new SqlParameter("@user_id", userID));
                cmd.Parameters.Add(new SqlParameter("@sender_id", senderID));

                // Open connection and execute the stored procedure
                conn.Open();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    // Fill the DataTable with the results
                    adapter.Fill(messages);
                }
            }
            conn.Close() ;
            return messages;
        }

        protected void DeleteLastMessage_Click(object sender, EventArgs e)
        {
            // Call the stored procedure to delete the last message
            DeleteLastMessageFromDatabase();

            // Add any additional logic or redirect the user as needed
        }

        private void DeleteLastMessageFromDatabase()
        {
            if (tp.ToLower() != "admin")
            {
                Label l = new Label();
                l.Text = "You are not an Admin";
                mainLabel.Controls.Add(l);
                return;
            }
            using (SqlCommand cmd = new SqlCommand("DeleteMsg", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            Response.Redirect("FinanceComm.aspx");
        }

    }
}