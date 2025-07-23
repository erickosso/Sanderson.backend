using sanderson.backend.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _becas : System.Web.UI.Page
    {
        private EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarBecas();
            }
        }

        private void CargarBecas()
        {
            gvBecas.DataSource = db.Becas.ToList();
            gvBecas.DataBind();
        }

        protected void gvBecas_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            try
            {
                var nuevaBeca = new Becas
                {
                    beca_id = Guid.NewGuid(),
                    nombre = e.NewValues["nombre"].ToString(),
                    tipo = e.NewValues["tipo"].ToString(),
                    porcentaje = Convert.ToDecimal(e.NewValues["porcentaje"]),
                    descripcion = e.NewValues["descripcion"]?.ToString(),
                    activo = Convert.ToBoolean(e.NewValues["activo"])
                };

                db.Becas.Add(nuevaBeca);
                db.SaveChanges();

                e.Cancel = true;
                gvBecas.CancelEdit();
                CargarBecas();

         
            }
            catch (Exception ex)
            {
                e.Cancel = true;
               
            }
        }

        protected void gvBecas_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            try
            {
                Guid becaId = Guid.Parse(e.Keys["beca_id"].ToString());
                var beca = db.Becas.Find(becaId);

                if (beca != null)
                {
                    beca.nombre = e.NewValues["nombre"].ToString();
                    beca.tipo = e.NewValues["tipo"].ToString();
                    beca.porcentaje = Convert.ToDecimal(e.NewValues["porcentaje"]);
                    beca.descripcion = e.NewValues["descripcion"]?.ToString();
                    beca.activo = Convert.ToBoolean(e.NewValues["activo"]);

                    db.SaveChanges();

                    e.Cancel = true;
                    gvBecas.CancelEdit();
                    CargarBecas();

                 
                }
            }
            catch (Exception ex)
            {
                e.Cancel = true;
         
            }
        }

        protected void gvBecas_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            try
            {
                Guid becaId = Guid.Parse(e.Keys["beca_id"].ToString());
                var beca = db.Becas.Find(becaId);

                if (beca != null)
                {
                    // Verificar si la beca está asignada a algún alumno
                    bool tieneAsignaciones = db.AlumnosBecas.Any(ab => ab.beca_id == becaId && ab.activo);

                    if (tieneAsignaciones)
                    {
                        e.Cancel = true;
              
                        return;
                    }

                    db.Becas.Remove(beca);
                    db.SaveChanges();

                    e.Cancel = true;
                    CargarBecas();

             
                }
            }
            catch (Exception ex)
            {
                e.Cancel = true;
        
            }
        }

        protected void gvBecas_DataBinding(object sender, EventArgs e)
        {
            gvBecas.DataSource = db.Becas.ToList();
        }
    }
}