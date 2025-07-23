using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using sanderson.backend.DAL;
using sanderson.backend.Utils;

namespace sanderson.backend.WServices
{
    /// <summary>
    /// Descripción breve de WSAlumnos
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
     [System.Web.Script.Services.ScriptService]
    public class WSAlumnos : System.Web.Services.WebService
    {

        private DBSandersonSchoolEntities db = new DBSandersonSchoolEntities();

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<object> GetAlumnos()
        {
            var alumnos = db.T_Alumnos.Where(x=>x.Activo==true).Select(a => new {
                a.IdAlumno,
                a.NombreCompleto,
                a.CURP,
                a.Grado,
                Escuela = a.T_Escuela.Nombre
            }).ToList<object>();

            return alumnos;
        }
        [WebMethod]
        public string GuardarAlumno(Guid? IdAlumno, string NombreCompleto, string CURP, int Grado, Guid IdEscuela)
        {

            CURP = CURP.ToUpper();
            if (IdAlumno.HasValue)
            {
                // Editar
                var alumno = db.T_Alumnos.FirstOrDefault(a => a.IdAlumno == IdAlumno);
                if (alumno == null) return "Alumno no encontrado";

                alumno.NombreCompleto = NombreCompleto;
                alumno.CURP = CURP;
                alumno.Grado = Grado;
                alumno.IdEscuela = IdEscuela;
            }
            else
            {

      
                var oexisteAlumno = db.T_Alumnos.Where(x => x.IdEscuela == IdEscuela && x.CURP == CURP && x.Activo == true).Any();

                if (oexisteAlumno)
                    return $"Ya se ha registrado un alumno con la CURP :{CURP}";

                // Agregar
                db.T_Alumnos.Add(new T_Alumnos
                {
                    IdAlumno = Guid.NewGuid(),
                    NombreCompleto = NombreCompleto,
                    CURP = CURP,
                    Grado = Grado,
                    Activo=true,
                    IdNivel = db.T_NivelesAcademicos.FirstOrDefault()?.IdNivel??Guid.NewGuid(),
                    IdEscuela = IdEscuela,
                    IdCicloEscolar = db.C_CicloEscolar.FirstOrDefault(c => c.Activo)?.IdCicloEscolar ?? Guid.NewGuid()
                });
            }

            db.SaveChanges();
            return "OK";
        }

        [WebMethod]
        public string EliminarAlumno(Guid IdAlumno)
        {
            var alumno = db.T_Alumnos.FirstOrDefault(a => a.IdAlumno == IdAlumno);
            if (alumno == null) return "Alumno no encontrado";

            alumno.FechaEliminacion = DateTime.Now;
            alumno.UsuarioElimina = UserInfo.UserName;
            alumno.Activo = false;
            db.SaveChanges();

            return "OK";
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<object> GetEscuelas()
        {
            var escuelas = db.T_Escuela
                .OrderBy(e => e.Nombre)
                .Select(e => new {
                    e.IdEscuela,
                    e.Nombre
                }).ToList<object>();

            return escuelas;
        }


    }
}
