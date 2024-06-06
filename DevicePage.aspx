<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DevicePage.aspx.cs" Inherits="SSLSample.DevicePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Device</title>
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
            <h1>Device: </h1>

            <asp:TextBox ID="DeviceID" placeholder="Device ID" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="DeviceStatus" placeholder="Device Status" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="DeviceBattery" placeholder="Device Battery" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="DeviceLoc" placeholder="Room Number" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="DeviceType" placeholder="Device Type" runat="server"></asp:TextBox><br />
            <asp:Button runat="server" Text="View Charge" OnClick="ExecuteViewMyDeviceCharge"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Add New Device" OnClick="ExecuteAddDevice"></asp:Button><br /><br />
            <asp:Button runat="server" Text="Charge Devices" OnClick="ExecuteCharging"></asp:Button><br /><br />
        </div>
        <div id="mainS" class="main" runat="server">
            <div id="table" class="table" runat="server">
                <label id="mainLabel" runat="server"></label><br />
                <label id="nameLabel" runat="server"></label><br />
                <label id="cDateLabel" runat="server"></label><br />
                <label id="dDateLabel" runat="server"></label><br />
                <label id="sLabel" runat="server"></label><br />
                <label id="rDateLabel" runat="server"></label><br />
                <label id="pLabel" runat="server"></label><br />
            </div>
        </div>
    </form>
</body>
</html>
