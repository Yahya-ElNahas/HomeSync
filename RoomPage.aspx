<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoomPage.aspx.cs" Inherits="SSLSample.RoomPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rooms</title>
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
            <h1>Rooms: </h1>

            <asp:TextBox ID="RoomID" placeholder="Room ID" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="SchedStart" placeholder="Start Time" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="SchedEnd" placeholder="End Time" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="SchedAct" placeholder="Action" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="Rstatus" placeholder="Status" runat="server"></asp:TextBox>
            <br />
            <asp:Button runat="server" Text="View Assigned Room" OnClick="ViewAssignedRoom"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Book Room" OnClick="AssignRoom"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Create Schedule" OnClick="CreateSchedule"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Set Status For a Room" OnClick="RoomAvailability"></asp:Button><br /><br />
            <asp:Button runat="server" Text="View Available Rooms" OnClick="ViewRoom"></asp:Button><br /><br />
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
