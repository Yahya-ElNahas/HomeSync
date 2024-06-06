<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomeSync.aspx.cs" Inherits="SSLSample.HomeSync" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HomeSync</title>
    <link href ="RegStyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="head">
            <h1>HomeSync</h1>
        </div>
        <div class="main">
            <h1>Welcome</h1>
            <asp:Button runat="server" Text="Register" OnClick="register"></asp:Button>
            <asp:Button runat="server" Text="Login" OnClick="login"></asp:Button>
        </div>
    </form>
    
</body>
</html>
