<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SSLSample.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register</title>
    <link href ="RegStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form2" runat="server">
        <div class="head">
            <h1>HomeSync</h1>
        </div>
        <div class="main">
            <h1>Register</h1>
            <div class="txt_field">
                <asp:TextBox ID="regFirstName" placeholder="First Name" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="regLastName" placeholder="Last Name" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="regEmail" placeholder="Email" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="regType" placeholder="User Type" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="regBirthDate" placeholder="Birth Date" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="regPassword" placeholder="Password" runat="server"></asp:TextBox>
            </div>
            <label id="fillAll" runat="server">Please Fill in All Data</label>
            <div class="msg">
                <label id="existsLabel" runat="server"></label>
            </div>
            <asp:Button runat="server" Text="Register" OnClick="register"></asp:Button>
            <div class="back">
                <asp:Button runat="server" Text="Go Back" OnClick="goBack"></asp:Button>
            </div>
        </div>
    </form>
</body>
</html>
