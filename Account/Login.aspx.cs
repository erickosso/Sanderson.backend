using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using sanderson.backend.DAL;
using sanderson.backend.Helpers;
using sanderson.backend.Utils;

namespace sanderson.backend.Account
{
    public partial class Login : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated && Session["IdUsuario"] != null)
            {
                Response.Redirect(GetRouteUrl("", new { }));
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!IsValid) return;

            string username = txtUsuario.Text.Trim();
            string password =  txtPassword.Text;

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var usuario = db.Usuarios
                    .Include("roles")
                    .Include("roles.permisos")
                    .FirstOrDefault(u => u.username == username && u.activo == true);

                password = "ABCD1234";
               // PasswordHelper.SetNewPassword(db, usuario.usuario_id, password);


                if (usuario != null &&PasswordHelper.VerifyAnyPassword(password, usuario.password_hash))
                {
                    // Crear ticket de autenticación
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                        1,
                        usuario.username.ToString(),
                        DateTime.Now,
                        DateTime.Now.AddMinutes(720),
                        true,
                        usuario.Roles.nombre,
                        FormsAuthentication.FormsCookiePath);

                    string encryptedTicket = FormsAuthentication.Encrypt(ticket);
                    HttpCookie authCookie = new HttpCookie(
                        FormsAuthentication.FormsCookieName,
                        encryptedTicket);

                    Response.Cookies.Add(authCookie);

                    // Guardar datos de usuario en sesión
                    Session["UsuarioActual"] = new UsuarioInfo
                    {
                        UsuarioId = usuario.usuario_id,
                        Nombre = usuario.nombre,
                        Rol = usuario.Roles.nombre,
                        Permisos = usuario.Roles.Permisos.Select(p => p.nombre).ToList()
                    };

                    Response.Redirect(FormsAuthentication.GetRedirectUrl(username, false));
                }
                else
                {
                    lblError.Text = "Usuario o contraseña incorrectos";
                    lblError.Visible = true;
                }
            }
        }

    }


}
public class UsuarioInfo
{
    public Guid UsuarioId { get; set; }
    public string Nombre { get; set; }
    public string Rol { get; set; }
    public List<string> Permisos { get; set; }
}

