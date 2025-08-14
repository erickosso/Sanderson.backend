using DevExpress.Web;
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
    public partial class _conceptos_pago : System.Web.UI.Page
    {
        private EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarConceptos();
            }
        }

        private void CargarConceptos()
        {
            gvConceptos.DataSource = db.ConceptosPago.ToList();
            gvConceptos.DataBind();
        }

        protected void gvConceptos_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            ConceptosPago nuevoConcepto = new ConceptosPago
            {
                concepto_id = Guid.NewGuid(),
                nombre = e.NewValues["nombre"].ToString(),
                descripcion = e.NewValues["descripcion"]?.ToString(),
                tipo = e.NewValues["tipo"].ToString(),
                monto_base = Convert.ToDecimal(e.NewValues["monto_base"]),
                aplica_descuento = Convert.ToBoolean(e.NewValues["aplica_descuento"]),
                aplica_beca = Convert.ToBoolean(e.NewValues["aplica_beca"]),
                escuela_id = (Guid.Parse(e.NewValues["escuela_id"].ToString())),
                activo = Convert.ToBoolean(e.NewValues["activo"])
            };

            db.ConceptosPago.Add(nuevoConcepto);
            db.SaveChanges();
            e.Cancel = true;
            gvConceptos.CancelEdit();
            CargarConceptos();
        }

        protected void gvConceptos_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            Guid id = Guid.Parse(e.Keys["concepto_id"].ToString());
            var concepto = db.ConceptosPago.Find(id);

            if (concepto != null)
            {
                concepto.nombre = e.NewValues["nombre"].ToString();
                concepto.descripcion = e.NewValues["descripcion"]?.ToString();
                concepto.tipo = e.NewValues["tipo"].ToString();
                concepto.monto_base = Convert.ToDecimal(e.NewValues["monto_base"]);
                concepto.aplica_descuento = Convert.ToBoolean(e.NewValues["aplica_descuento"]);
                concepto.aplica_beca = Convert.ToBoolean(e.NewValues["aplica_beca"]);
                concepto.activo = Convert.ToBoolean(e.NewValues["activo"]);

                db.SaveChanges();
            }

            e.Cancel = true;
            gvConceptos.CancelEdit();
            CargarConceptos();
        }

        protected void gvConceptos_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            Guid id = Guid.Parse(e.Keys["concepto_id"].ToString());
            var concepto = db.ConceptosPago.Find(id);

            if (concepto != null)
            {
                db.ConceptosPago.Remove(concepto);
                db.SaveChanges();
            }

            e.Cancel = true;
            CargarConceptos();
        }

        protected void gvConceptos_DataBinding(object sender, EventArgs e)
        {
            gvConceptos.DataSource = db.ConceptosPago.ToList();
        }

        protected void dsEscuelas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            e.KeyExpression = "escuela_id";

            e.QueryableSource = db.Escuelas.Where(x => x.activo == true).Select(x => x).OrderBy(c => c.nombre).Where(x => UserInfo.EscuelasByUsuario.Contains(x.escuela_id));

        }

    }
}