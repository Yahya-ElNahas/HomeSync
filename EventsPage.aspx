<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventsPage.aspx.cs" Inherits="SSLSample.EventsPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Events</title>
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
            <h1>Events: </h1>

            <asp:TextBox ID="EventName" placeholder="Event Name" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="EventID" placeholder="Event ID" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="EventUserID" placeholder="Invited User ID" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="EventDesc" placeholder="Event Description" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="EventLoc" placeholder="Event Location" runat="server"></asp:TextBox><br />
            <asp:TextBox ID="EventRem" placeholder="Event Reminder" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Create Event" OnClick="CreateEvent_Click"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Assign User to Event" OnClick="AssignUser_Click"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Uninvite User" OnClick="UninviteUser_Click"></asp:Button><br /><br />
            <asp:Button runat="server" Text="View Event" OnClick="ViewEvent_Click"></asp:Button><br /><br />
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
