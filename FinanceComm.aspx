<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinanceComm.aspx.cs" Inherits="SSLSample.FinanceComm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Finance and Communication</title>
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
            <h1>Finance: </h1>

            <asp:TextBox ID="FinType" placeholder="Type" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="FinAmount" placeholder="Amount" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="FinDesc" placeholder="Description" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="FinDate" placeholder="Date" runat="server"></asp:TextBox>
            <br />
            <asp:TextBox ID="FinRec" placeholder="Receiver ID" runat="server"></asp:TextBox><br />
            <asp:TextBox ID="FinDue" placeholder="Due Date" runat="server"></asp:TextBox><br />
            <asp:TextBox ID="FinStatus" placeholder="Status" runat="server"></asp:TextBox><br /><br />
            <asp:Button runat="server" Text="Recieve Money" OnClick="ReceiveTransaction"></asp:Button><br />
            <asp:Button runat="server" Text="Send Money" OnClick="SendMoney"></asp:Button><br />

            <h2>Communication: </h2>
            <asp:TextBox ID="CommRec" placeholder="Receiver ID" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="CommTitle" placeholder="Title" runat="server"></asp:TextBox>
            <br />

            <asp:TextBox ID="CommCont" placeholder="Content" runat="server"></asp:TextBox><br /><br />
            <asp:Button runat="server" Text="Send Message" OnClick="SendMessage_Click"></asp:Button><br />
            <asp:Button runat="server" Text="Show Received" OnClick="ShowMessages_Click"></asp:Button><br />
            <asp:Button runat="server" Text="Delete Last Sent" OnClick="DeleteLastMessage_Click"></asp:Button><br />
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
