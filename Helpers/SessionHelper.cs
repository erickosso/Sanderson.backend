using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
  using sanderson.backend.DAL;
namespace sanderson.backend.Helpers
{
    // Utils/SessionHelper.cs
  

    namespace SistemaEscuelas.Utils
    {
        public static class SessionHelper
        {
            public static UsuarioInfo UsuarioActual
            {
                get
                {
                    return System.Web.HttpContext.Current.Session["UsuarioActual"] as UsuarioInfo;
                }
            }

            public static bool TienePermiso(string permiso)
            {
                if (UsuarioActual == null) return false;
                return UsuarioActual.Permisos.Contains(permiso);
            }

            public static bool EsRol(string rol)
            {
                if (UsuarioActual == null) return false;
                return UsuarioActual.Rol.Equals(rol, StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}