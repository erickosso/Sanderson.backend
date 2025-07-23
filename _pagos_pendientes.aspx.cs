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
    public partial class _pagos_pendientes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            
      
            var servicio = new PagoService();
         
            servicio.GenerarPagosAutomaticos(DateTime.Now.Date,UserInfo.EscuelasByUsuario);
            servicio.AplicarRecargosAutomaticos( UserInfo.EscuelasByUsuario);

            servicio.CargarConceptosUnicosEnLote(Guid.Parse("EACF30B4-F692-4168-BB18-5B6B60B4C7DE"),  UserInfo.EscuelasByUsuario, 2, 1);
            CargarPagosPendientes();
        }

        private void CargarPagosPendientes()
        {
            var servicio = new PagoService();
            gvPagosPendientes.DataSource = servicio.GetPagosPendientes();
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