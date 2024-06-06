using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSLSample
{
    public partial class HomeSync : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void register(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }

        protected void login(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}