using DevExpress.Web;

using sanderson.backend.DAL;
using sanderson.backend.Models;
using sanderson.backend.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _cortes_caja : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCortesAbiertos();
                CargarEscuelas();
                deFecha.Date = DateTime.Today;
                gvCortesAbiertos.DataBind();
            }

        }
        private void CargarEscuelas()
        {
            using (var context = new EscuelasSandersonSatoriEntities())
            {
                cbEscuelas.DataSource = context.Escuelas.Where(x => x.activo == true).ToList();
                cbEscuelas.DataBind();
            }
        }

        private void CargarCortesAbiertos()
        {


        }

        protected void cpMain_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter == "abrir")
            {

                using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
                {
                    CortesCaja cj = new CortesCaja();
                    cj.corte_id = Guid.NewGuid();
                    cj.escuela_id = (Guid)cbEscuelas.Value;
                    cj.fecha_corte = DateTime.Now;
                    cj.estado = "Cerrado";
                    cj.hora_fin = DateTime.Now.TimeOfDay;
                    cj.hora_fin = DateTime.Now.TimeOfDay;
                    cj.saldo_inicial = 0;
                    cj.saldo_final = 0;
                    cj.usuario_id = UserInfo.InformacionPersonal.usuario_id;




                    var gastos = db.GastosNoRegistrados.Where(x => x.IdEscuela == cj.escuela_id && x.EsGastoGeneral == false).ToList();
                    var ingresos = db.IngresosNoRegistrados.Where(x => x.escuela_id == cj.escuela_id && x.estado == "Pagado").ToList();
                    cj.total_gastos = gastos.Sum(x => x.Monto);
                    cj.total_ingresos = ingresos.Sum(x => x.monto_pagado ?? 0);
                    db.CortesCaja.Add(cj);
                    db.SaveChanges();
                    var gastosxcorte = gastos.Select(x => new CorteCajaGastos
                    {
                        concepto = x.Concepto,
                        corte_id = cj.corte_id,
                        detalle_id = Guid.NewGuid(),
                        es_gasto_general = x.EsGastoGeneral,
                        fecha_gasto = x.FechaGasto ?? DateTime.Now,
                        gasto_id = x.IdGasto,
                        justificacion = x.Justificacion,
                        monto = x.Monto,
                        tipo_gasto = db.TiposGasto.Find(x.IdTipoGasto).Nombre,
                        usuario_registro = x.UsuarioRegistro,



                    }).ToList();
                    db.CorteCajaGastos.AddRange(gastosxcorte);
                    db.SaveChanges();

                    var ingresosxcorte = ingresos.Select(x => new CorteCajaIngresos
                    {
                        alumno_id = x.alumno_id,
                        alumno_nombre = $"{db.Alumnos.Find(x.alumno_id).nombre} {db.Alumnos.Find(x.alumno_id).apellido_paterno} {db.Alumnos.Find(x.alumno_id).apellido_materno} ",
                        concepto_id = x.concepto_id,
                        concepto_nombre = db.ConceptosPago.Find(x.concepto_id).nombre,
                        corte_id = cj.corte_id,
                        descuento = x.descuento ?? 0,
                        detalle_id = Guid.NewGuid(),
                        fecha_pago = x.fecha_pago ?? DateTime.Now,
                        metodo_pago = x.metodo_pago,
                        pago_id = x.pago_id,
                        periodo = x.periodo,
                        monto_original = x.monto,
                        monto_pagado = x.monto_pagado ?? 0,
                        recargo = x.recargo ?? 0,
                        referencia = x.referencia

                    }).ToList();
                    db.CorteCajaIngresos.AddRange(ingresosxcorte);
                    db.SaveChanges();



                }



            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            CargarCortesAbiertos();
            LimpiarFormulario();
        }

        private void LimpiarFormulario()
        {

            mmObservaciones.Text = string.Empty;
        }

        protected void btnCerrar_Click(object sender, EventArgs e)
        {
            var btn = (ASPxButton)sender;
            var corteId = Guid.Parse(btn.CommandArgument);

         

            // Redirigir a pantalla de cierre de corte
            Response.Redirect(Page.ResolveUrl($"~/handler/handlerReportCorte.ashx?id={corteId}"));
        }

        protected void gvEgresos_DataBinding(object sender, EventArgs e)
        {

            var db = new EscuelasSandersonSatoriEntities();
            var gv = (sender as ASPxGridView);
            Guid corte_id = (Guid)gv.GetMasterRowKeyValue();
            var pagosCorte = db.CorteCajaIngresos.Where(x => x.corte_id == corte_id).Select(x => x.pago_id).ToList();

            gv.DataSource = db.Pagos.Where(x => pagosCorte.Contains(x.pago_id)).ToList();
            gv.KeyFieldName = "pago_id";
        }

        protected void gvIngresos_DataBinding(object sender, EventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            var gv = (sender as ASPxGridView);
            Guid corte_id = (Guid)gv.GetMasterRowKeyValue();
            var pagosCorte = db.CorteCajaGastos.Where(x => x.corte_id == corte_id).Select(x => x.gasto_id).ToList();

            gv.DataSource = db.Gastos.Where(x => pagosCorte.Contains(x.IdGasto)).ToList();
            gv.KeyFieldName = "pago_id";
        }

        protected void gvCortesAbiertos_DataBinding(object sender, EventArgs e)
        {
            EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities();

            gvCortesAbiertos.DataSource = db.V_CorteCaja.Select(x => x).ToList();
            gvCortesAbiertos.KeyFieldName = "corte_id";

        }
    }
}