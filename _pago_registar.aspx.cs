using sanderson.backend.DAL;
using sanderson.backend.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _pago_registar : System.Web.UI.Page
    {
        public Guid pago_id
        {

            get
            {
                if (RouteData.Values["pago_id"] != null)
                {
                    return Guid.Parse( RouteData.Values["pago_id"].ToString());
                }else
                {
                    Response.Redirect(GetRouteUrl("", new { }));
                }
                return Guid.Empty;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && pago_id != null)
            {
                CargarDatosPago(pago_id);
            }
        }

        private void CargarDatosPago(Guid pagoId)
        {
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var pago = db.Pagos.Find(pagoId);
                lblAlumno.Text = $"{pago.Alumnos.nombre} {pago.Alumnos.apellido_paterno}";
                lblConcepto.Text = pago.ConceptosPago.nombre;
                lblMonto.Text = (pago.monto ).ToString("C2");
                lblRecargo.Text = (pago.recargo??0).ToString("C2");
                lblDescuento.Text = ( pago.descuento??0).ToString("C2");
                lblMontoAPagar.Text = (pago.monto + (pago.recargo ?? 0) -( pago.descuento??0)).ToString("C2");
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            var servicio = new PagoService();
           

            servicio.RegistrarPago(
                pago_id,
                cmbMetodoPago.Value.ToString(),
                txtReferencia.Text, decimal.Parse(lblMontoAPagar.Text.Replace("$","").Replace(",","")));

          
        
            // Habilitar descarga
            lnkComprobante.NavigateUrl = $"~/handler/handlerReport.ashx?id={pago_id}";
            lnkComprobante.Visible = true;

            ClientScript.RegisterStartupScript(
                GetType(),
                "success",
                "alert('Pago registrado correctamente');",
                true);
        }
    }
}