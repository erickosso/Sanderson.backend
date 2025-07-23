using sanderson.backend.DAL;
using sanderson.backend.Helpers.SistemaEscuelas.Utils;
using sanderson.backend.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (SessionHelper.UsuarioActual != null)
                {
                    //lblUsuario.Text = $"Bienvenido, {SessionHelper.UsuarioActual.Nombre} " +
                    //                 $"[{SessionHelper.UsuarioActual.Rol}]";
                }
                else
                {
                    Response.Redirect("~/Account/Login.aspx");
                }
            }

        }

        public string Nombre
        {
            get
            {
                return SessionHelper.UsuarioActual.Nombre;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Account/Login.aspx");
        }

    }
}