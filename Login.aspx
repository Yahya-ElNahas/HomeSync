<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SSLSample.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link href ="RegStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form3" runat="server">
        <div class="head">
            <h1>HomeSync</h1>
        </div>
        <div class="main">
            <h1>Login</h1>
            <div class="txt_field">
                <asp:TextBox ID="loginEmail" placeholder="Email" runat="server"></asp:TextBox>
            </div>
            <div class="txt_field">
                <asp:TextBox ID="loginPassword" placeholder="Password" runat="server"></asp:TextBox>
            </div>
            <div class="fill_all">
                <label>Please Fill in All Data</label>
            </div>
            <div class="msg">
                <label id="errorMsg" runat="server"></label>
            </div>
            <asp:Button runat="server" Text="Login" OnClick="login"></asp:Button>
            <div class="back">
                <asp:Button runat="server" Text="Go Back" OnClick="goBack"></asp:Button>
            </div>
        </div>
    </form>
</body>
</html>
