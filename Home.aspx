<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="SSLSample.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home</title>
    <link href ="HomeStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form4" runat="server">
        <div id="head" class="head" runat="server">
            <asp:Button runat="server" Text="Log Out" OnClick="logOut"></asp:Button>
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
            <label id="setGuestsLabel" runat="server"></label><br />
            <asp:TextBox ID="setGuests" placeholder="Allowed Guests" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Set Allowed Guests" OnClick="setNumOfGuests"></asp:Button><br /><br />
            <label id="deleteGuestLabel" runat="server"></label><br />
            <asp:TextBox ID="deleteGuestTxt" placeholder="Guest ID" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="Delete Guest" OnClick="deleteGuest"></asp:Button><br /><br />

        </div>
        <div id="rightBar" class="rightBar" runat="server">
            <label>Rooms: </label><br />
            <asp:Button runat="server" Text="Rooms Component" OnClick="goRooms"></asp:Button><br /><br />

            <label>Tasks: </label><br />
            <asp:Button runat="server" Text="Tasks Component" OnClick="goTasks"></asp:Button><br /><br />
            
            <label>Events: </label><br />
            <asp:Button runat="server" Text="Events Component" OnClick="goEvents"></asp:Button><br /><br />

            <label>Devices: </label><br />
            <asp:Button runat="server" Text="Devices Component" OnClick="goDevices"></asp:Button><br /><br />

            <label> Finance and Communication: </label><br />
            <asp:Button runat="server" Text=" Finance & Comm." OnClick="goFinance"></asp:Button><br /><br />
        </div>
        <div id="mainS" class="main" runat="server">
            <div id="table" class="table" runat="server">
                <label id="mainLabel" runat="server"></label><br />
            </div>
        </div>
    </form>
</body>
</html>
