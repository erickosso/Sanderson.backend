using DevExpress.Web;
using sanderson.backend.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace sanderson.backend
{
    public partial class _pagos_realizados_byalumno : System.Web.UI.Page
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
            if (!IsPostBack)
            {
                // Configurar fechas por defecto (últimos 30 días)
                deFechaDesde.Date = DateTime.Today.AddDays(-30).Date;
                deFechaHasta.Date = DateTime.Today.AddDays(1).AddSeconds(-1);
            }
            CargarPagos();

        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            CargarPagos();
        }

        private void CargarPagos()
        {
            using (var context = new EscuelasSandersonSatoriEntities())
            {
                var desde = deFechaDesde.Date;
                var Hasta = deFechaHasta.Date.AddDays(1).AddSeconds(-1);

                var query = context.VistaPagosAlumno.Where(x => x.alumno_id==alumno_id&& x.fecha_pago >= desde && x.fecha_pago <= Hasta).ToList();
                gvPagos.DataSource = query.ToList();
                gvPagos.KeyFieldName = "pago_id;alumno_id";
                gvPagos.DataBind();
            }
        }





        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            gvExporter.WriteXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx
            {
                ExportType = DevExpress.Export.ExportType.WYSIWYG,
                SheetName = "Pagos Recibidos"
            });
        }






    }
}