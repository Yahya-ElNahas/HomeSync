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
    public partial class TasksPage : System.Web.UI.Page
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

        protected void viewTasks(object sender, EventArgs e)
        {
            DataTable tasks = GetTasks(user_id);
            gridMessages.DataSource = tasks;
            gridMessages.DataBind();
        }

        private DataTable GetTasks(int userID)
        {
            DataTable tasks = new DataTable();

            SqlCommand viewTasksProc = new SqlCommand("ViewTaskTable", conn);
            viewTasksProc.CommandType = CommandType.StoredProcedure;
            viewTasksProc.Parameters.Add(new SqlParameter("@user_id", user_id));
            conn.Open();

            using (SqlDataAdapter adapter = new SqlDataAdapter(viewTasksProc))
            {
                // Fill the DataTable with the results
                adapter.Fill(tasks);
            }
            conn.Close();
            return tasks;
        }

        protected void finishTask(object sender, EventArgs e)
        {
            string taskTitle = finishTitle.Text;
            SqlCommand finishTaskProc = new SqlCommand("FinishMyTask", conn);
            finishTaskProc.CommandType = CommandType.StoredProcedure;
            finishTaskProc.Parameters.Add(new SqlParameter("@user_id", user_id));
            finishTaskProc.Parameters.Add(new SqlParameter("@title", taskTitle));
            conn.Open();
            finishTaskProc.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("TasksPage.aspx");
        }

        protected void viewTaskStatus(object sender, EventArgs e)
        {
            string taskTitle = statusTitle.Text;
            SqlCommand viewTaskStatusProc = new SqlCommand("ViewTaskStatus", conn);
            viewTaskStatusProc.CommandType = CommandType.StoredProcedure;
            viewTaskStatusProc.Parameters.Add(new SqlParameter("@user_id", user_id));
            viewTaskStatusProc.Parameters.Add(new SqlParameter("@title", taskTitle));
            SqlParameter taskStatus = viewTaskStatusProc.Parameters.Add("@status", SqlDbType.Int);
            taskStatus.Direction = ParameterDirection.Output;

            conn.Open();
            viewTaskStatusProc.ExecuteNonQuery();
            conn.Close();

            Label l = new Label();
            switch (taskStatus.Value.ToString())
            {
                case "0": l.Text = "Not Done"; break;
                case "1": l.Text = "Done"; break;
                default: l.Text = "Task Not Found"; break;
            }
            mainLabel.Controls.Add(l);
        }

        protected void setReminder(object o, EventArgs e)
        {
            if (reminderId.Text == "")
                return;
            int taskID = Int32.Parse(reminderId.Text);
            string reminder = reminderDate.Text;
            SqlCommand setReminderProc = new SqlCommand("AddReminder", conn);
            setReminderProc.CommandType = CommandType.StoredProcedure;
            setReminderProc.Parameters.Add(new SqlParameter("@task_id", taskID));
            setReminderProc.Parameters.Add(new SqlParameter("@reminder", reminder));

            conn.Open();
            setReminderProc.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("TasksPage.aspx");
        }

        protected void setDeadline(object o, EventArgs e)
        {
            if (deadId.Text == "")
                return;
            int taskID = Int32.Parse(deadId.Text);
            string deadline = deadDate.Text;
            SqlCommand setDeadlineProc = new SqlCommand("UpdateTaskDeadline", conn);
            setDeadlineProc.CommandType = CommandType.StoredProcedure;
            setDeadlineProc.Parameters.Add(new SqlParameter("@deadline", deadline));
            setDeadlineProc.Parameters.Add(new SqlParameter("@task_id", taskID));

            conn.Open();
            setDeadlineProc.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("TasksPage.aspx");
        }
    }
}