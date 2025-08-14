using sanderson.backend.DAL;
using sanderson.backend.Services;
using sanderson.backend.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _pagos_pendientes_byalumno : System.Web.UI.Page
    {

        public Guid alumno_id
        {
            get
            {
                if (RouteData.Values["alumno_id"] != null)
                {
                    return Guid.Parse(RouteData.Values["alumno_id"].ToString());
                }
                else
                {
                    Response.Redirect(GetRouteUrl("", new { }));
                }
                return Guid.Empty;
            }
        }

        public Alumnos alumno
        {
            get
            {
                using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
                {
                    return db.Alumnos.Where(x => x.alumno_id == alumno_id).FirstOrDefault();
                }
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            
      
            var servicio = new PagoService();
         
            servicio.GenerarPagosAutomaticos(DateTime.Now.Date,UserInfo.EscuelasByUsuario);
            servicio.AplicarRecargosAutomaticos( UserInfo.EscuelasByUsuario);


            servicio.CargarConceptosUnicosEnLote(Guid.Parse("2C230E25-F5E5-4E07-B58C-A99C5044B9B3"), UserInfo.EscuelasByUsuario, alumno.nivel_id,  alumno.grado_id);
            servicio.CargarConceptosUnicosEnLote(Guid.Parse("B272CF33-C78C-4751-91A8-F3DB6F81E025"), UserInfo.EscuelasByUsuario, alumno.nivel_id, alumno.grado_id);
            CargarPagosPendientes();
        }

        private void CargarPagosPendientes()
        {
            var servicio = new PagoService();
            gvPagosPendientes.DataSource = servicio.GetPagosPendientes(alumno_id);
            gvPagosPendientes.DataBind();
        }

        protected void gvPagosPendientes_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "btnPagar")
            {
                Guid pagoId = (Guid)gvPagosPendientes.GetRowValues(e.VisibleIndex, "PagoId");
                // Lógica para registrar el pago...
            }
        }
    }
}