<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TasksPage.aspx.cs" Inherits="SSLSample.TasksPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tasks</title>    
    <link href ="HomeStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form4" runat="server">
        <div id="head" class="head" runat="server">
            <asp:Button runat="server" Text="Home Page" OnClick="goHome"></asp:Button>
            <label id="userFirstName" runat="server"></label>
            <label id="userLastName" runat="server"></label>
        </div>
        <div id="leftBar" class="leftBar" runat="server">
            <label id="userID" runat="server">User ID: </label><br /><br />
            <label id="userType" runat="server">User Type: </label><br /><br />
            <label id="userEmail" runat="server">Email: </label><br /><br />
            <label id="userRoom" runat="server">Room: </label><br /><br />
            <label id="userAge" runat="server">Age: </label><br /><br />

            <label id="numOfGuests" runat="server"></label><br /><br />
            <label id="numAllowedGuests" runat="server"></label><br /><br />

        </div>
        <div id="rightBar" class="rightBar" runat="server">
            <h1>Tasks: </h1>
            <label>View Tasks: </label><br />
            <asp:Button runat="server" Text="View Tasks" OnClick="viewTasks"></asp:Button><br /><br />
            <label>Finish Task: </label><br />
            <asp:TextBox ID="finishTitle" placeholder="Task Title" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Finish Task" OnClick="finishTask"></asp:Button><br /><br />
            <label>View Task Status: </label><br />
            <asp:TextBox ID="statusTitle" placeholder="Task Title" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="View Task Status" OnClick="viewTaskStatus"></asp:Button><br /><br />
            <label>Set Task Reminder: </label><br />
            <asp:TextBox ID="reminderId" placeholder="Task ID" runat="server"></asp:TextBox><br />
            <asp:TextBox ID="reminderDate" placeholder="Reminder Date" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Set Reminder" OnClick="setReminder"></asp:Button><br /><br />
            <label>Set Task Deadline: </label><br />
            <asp:TextBox ID="deadId" placeholder="Task ID" runat="server"></asp:TextBox><br />
            <asp:TextBox ID="deadDate" placeholder="DeadLine" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Set Deadline" OnClick="setDeadline"></asp:Button><br /><br />
        </div>
        <div id="mainS" class="main" runat="server">
            <div id="table" class="table" runat="server">
                <label id="mainLabel" runat="server"></label><br />
                <div id="tableGrid" class="tableGrid" runat="server">
                    <asp:GridView ID="gridMessages" class="gridT" runat="server" AutoGenerateColumns="true"></asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
