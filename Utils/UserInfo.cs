using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using sanderson.backend.DAL;

namespace sanderson.backend.Utils
{
    public class UserInfo
    {

        public static string UserName { get { return HttpContext.Current.User.Identity.Name; } }
        public static Usuarios InformacionPersonal
        {
            get
            {
                using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
                {
                    return db.Usuarios.Where(x => x.username == UserName).FirstOrDefault() ?? new Usuarios();
                }
            }
        }
        public static bool EsDirectorGral
        {
            get
            {
                using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
                {
                    return (db.Usuarios.Where(x => x. username== UserName).FirstOrDefault() ?? new Usuarios()).rol_id == ConstantePerfil.DirectorGeneral;
                }
            }
        }

        public static List<Guid> EscuelasByUsuario
        {
            get
            {
                using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
                {
                    

                    return db.UsuariosEscuelas.Where(x => x.usuario_id == InformacionPersonal.usuario_id).Select(x => x.escuela_id).ToList();



                }

            }
        }
    }
}