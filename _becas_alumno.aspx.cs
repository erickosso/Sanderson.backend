using sanderson.backend.DAL;
using sanderson.backend.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _becas_alumno : System.Web.UI.Page
    {
        private EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarAsignaciones();
            }
        }

        private void CargarAsignaciones()
        {

            List<Guid> alumnos = db.Alumnos.Where(x => UserInfo.EscuelasByUsuario.Contains(x.escuela_id)).Select(x=>x.alumno_id).ToList();

            var query = db.AlumnosBecas
                .Include("Alumnos")
                .Include("Becas").Where(x=>alumnos.Contains(x.alumno_id))
                .OrderBy(ab => ab.Alumnos.nombre)
            
                .ToList();

            gvAlumnosBecas.DataSource = query;
            gvAlumnosBecas.DataBind();
        }

        protected void gvAlumnosBecas_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            try
            {
                var nuevaAsignacion = new AlumnosBecas
                {
                    alumno_beca_id = Guid.NewGuid(),
                    alumno_id = (Guid)e.NewValues["alumno_id"],
                    beca_id = (Guid)e.NewValues["beca_id"],
                    porcentaje_aplicado = (decimal)e.NewValues["porcentaje_aplicado"],
                    fecha_vencimiento = (DateTime?)e.NewValues["fecha_vencimiento"],
                    fecha_asignacion = DateTime.Now,
                    activo = true,
                    usuario_registro = User.Identity.Name
                };

                // Validar porcentaje máximo según la beca
                var beca = db.Becas.Find(nuevaAsignacion.beca_id);
                if (nuevaAsignacion.porcentaje_aplicado > beca.porcentaje)
                {
                    throw new Exception($"El porcentaje no puede exceder el {beca.porcentaje}% definido para esta beca");
                }

                db.AlumnosBecas.Add(nuevaAsignacion);
                db.SaveChanges();

                e.Cancel = true;
                gvAlumnosBecas.CancelEdit();
                CargarAsignaciones();

      
            }
            catch (Exception ex)
            {
                e.Cancel = true;

            }
        }

        protected void gvAlumnosBecas_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            try
            {
                Guid id = Guid.Parse(e.Keys["alumno_beca_id"].ToString());
                var asignacion = db.AlumnosBecas.Find(id);

                if (asignacion != null)
                {
                    // Validar cambio de porcentaje
                    var nuevoPorcentaje = (decimal)e.NewValues["porcentaje_aplicado"];
                    var beca = db.Becas.Find(asignacion.beca_id);

                    if (nuevoPorcentaje > beca.porcentaje)
                    {
                        throw new Exception($"El porcentaje no puede exceder el {beca.porcentaje}%");
                    }

                    asignacion.porcentaje_aplicado = nuevoPorcentaje;
                    asignacion.fecha_vencimiento = (DateTime?)e.NewValues["fecha_vencimiento"];
                    asignacion.activo = (bool)e.NewValues["activo"];

                    db.SaveChanges();

                    e.Cancel = true;
                    gvAlumnosBecas.CancelEdit();
                    CargarAsignaciones();

                }
            }
            catch (Exception ex)
            {
                e.Cancel = true;
        
            }
        }

        protected void gvAlumnosBecas_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            try
            {
                Guid id = Guid.Parse(e.Keys["alumno_beca_id"].ToString());
                var asignacion = db.AlumnosBecas.Find(id);

                if (asignacion != null)
                {
                    // Validar si hay pagos asociados
                    //bool tienePagos = db.Pagos.Any(p => p.AlumnosBecas.Any(ab => ab.alumno_beca_id == id));

                    //if (tienePagos)
                    //{
                    //    throw new Exception("No se puede eliminar: Existen pagos asociados a esta beca");
                    //}

                    db.AlumnosBecas.Remove(asignacion);
                    db.SaveChanges();

                    e.Cancel = true;
                    CargarAsignaciones();

                
                }
            }
            catch (Exception ex)
            {
                e.Cancel = true;
       
            }
        }

        protected void gvAlumnosBecas_DataBinding(object sender, EventArgs e)
        {
            // Solo se ejecuta si no hay datos ya cargados
            if (gvAlumnosBecas.DataSource == null)
            {
                CargarAsignaciones();
            }
        }

       

        protected void dsalumno_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "alumno_id";
            e.QueryableSource = db.VAlumnos.Where(x => x.activo == true);
        }

        protected void dsBecas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "beca_id";
            e.QueryableSource = db.Becas.Where(x => x.activo == true);
        }
    }
}