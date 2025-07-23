using sanderson.backend.DAL;
using sanderson.backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace sanderson.backend.Utils
{


    public static class Autenticacion
    {
        public static UsuarioDto ValidarUsuario(string usuario, string contrasena)
        {
            using (var context = new DBSandersonSchoolEntities())
            {
                var hash = AppUtils.ObtenerSHA256(contrasena); // Usa un hash SHA256, por ejemplo

                var u = context.T_Usuario
                    .Where(x => x.Usuario == usuario && x.ContraseñaHash == hash)
                    .Select(x => new UsuarioDto
                    {
                        IdUsuario = x.IdUsuario,
                        Nombre = x.Nombre,
                        NombreUsuario = x.Usuario,
                        NombreRol = x.C_Rol.NombreRol,
                        IdEscuela = x.IdEscuela
                    })
                    .FirstOrDefault();

                return u;
            }
        }
    }


}