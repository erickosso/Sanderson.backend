using System;
using System.IO;
using System.Linq;
using DevExpress.Web;
using sanderson.backend.DAL;
using sanderson.backend.Utils;

namespace sanderson.backend
{
    public partial class _gastos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gvGastos.DataBind();
            }
        }

        protected void gvGastos_DataBinding(object sender, EventArgs e)
        {
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                gvGastos.KeyFieldName = "IdGasto";
                gvGastos.DataSource = db.Gastos.ToList();
            }
        }

        protected void gvGastos_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var nuevoGasto = new Gastos
                {
                    IdGasto = Guid.NewGuid(),
                    IdEscuela = (Guid?)e.NewValues["IdEscuela"],
                    IdTipoGasto = (int)e.NewValues["IdTipoGasto"],
                    Concepto = e.NewValues["Concepto"].ToString(),
                    Monto = Convert.ToDecimal(e.NewValues["Monto"]),
                    Justificacion = e.NewValues["Justificacion"].ToString(),
                    EsGastoGeneral = Convert.ToBoolean(e.NewValues["EsGastoGeneral"]),
                    FechaGasto = Convert.ToDateTime(e.NewValues["FechaGasto"]),

                    FechaRegistro = DateTime.Now,
                    UsuarioRegistro = User.Identity.Name
                };

                db.Gastos.Add(nuevoGasto);
                db.SaveChanges();
            }

            e.Cancel = true;
            gvGastos.CancelEdit();
            gvGastos.DataBind();
        }

        protected void gvGastos_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var idGasto = Guid.Parse(e.Keys["IdGasto"].ToString());

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var gasto = db.Gastos.Find(idGasto);
                if (gasto != null)
                {
                    gasto.IdEscuela = (Guid?)e.NewValues["IdEscuela"];
                    gasto.IdTipoGasto = (int)e.NewValues["IdTipoGasto"];
                    gasto.Concepto = e.NewValues["Concepto"].ToString();
                    gasto.Monto = Convert.ToDecimal(e.NewValues["Monto"]);
                    gasto.Justificacion = e.NewValues["Justificacion"].ToString();
                    gasto.EsGastoGeneral = Convert.ToBoolean(e.NewValues["EsGastoGeneral"]);
                    gasto.FechaGasto = Convert.ToDateTime(e.NewValues["FechaGasto"]);
                    gasto.FechaModificacion = DateTime.Now;
                    gasto.UsuarioModificacion = User.Identity.Name;

                    db.SaveChanges();
                }
            }

            e.Cancel = true;
            gvGastos.CancelEdit();
            gvGastos.DataBind();
        }

        protected void gvGastos_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            var idGasto = Guid.Parse(e.Keys["IdGasto"].ToString());

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var gasto = db.Gastos.Find(idGasto);
                if (gasto != null)
                {
                    db.Gastos.Remove(gasto);
                    db.SaveChanges();
                }
            }

            e.Cancel = true;
            gvGastos.DataBind();
        }

        protected void gvGastos_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            // Validación personalizada si es necesario
            if (e.NewValues["IdTipoGasto"] == null)
            {
                e.EditorPropertiesErrors.Add((sender as ASPxGridView).Columns["IdTipoGasto"], "Seleccione un tipo de gasto");
            }

            if (string.IsNullOrEmpty(e.NewValues["Concepto"]?.ToString()))
            {
                e.EditorPropertiesErrors.Add((sender as ASPxGridView).Columns["Concepto"], "El concepto es obligatorio");

            }

            if (e.NewValues["Monto"] == null || Convert.ToDecimal(e.NewValues["Monto"]) <= 0)
            {
                e.EditorPropertiesErrors.Add((sender as ASPxGridView).Columns["Monto"], "Ingrese un monto válido");

            }



        }

        protected void dsEscuelas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {

            e.KeyExpression = "escuela_id";
            e.QueryableSource = new EscuelasSandersonSatoriEntities().Escuelas.Where(x => x.activo == true).OrderBy(x => x.nombre);
        }

        protected void dsTiposGasto_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "IdTipoGasto";
            e.QueryableSource = new EscuelasSandersonSatoriEntities().TiposGasto.OrderBy(x => x.Nombre);

        }
        protected void uploadEvidencia_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            // 1. Intentar obtener de los additionalFields primero
            string idGasto = Context.Request.Params["IdGasto"];

            // 2. Si no está, intentar de Session
            if (string.IsNullOrEmpty(idGasto) && Session["CurrentIdGasto"] != null)
            {
                idGasto = Session["CurrentIdGasto"].ToString();
            }

            // 3. Como último recurso, intentar de ViewState
            if (string.IsNullOrEmpty(idGasto) && ViewState["CurrentIdGasto"] != null)
            {
                idGasto = ViewState["CurrentIdGasto"].ToString();
            }

            if (!string.IsNullOrEmpty(idGasto) && Guid.TryParse(idGasto, out Guid gastoId))
            {
                try
                {
                    string oPath = AppUtils.FolderArchivos;
                    Guid IdEvidencia = Guid.NewGuid();
                    string nombreOriginal = e.UploadedFile.FileName;
                    string extension = Path.GetExtension(nombreOriginal);
                    string nuevoNombre = $"{IdEvidencia}{extension}";
                    string ofullFileName = Path.Combine(oPath, nuevoNombre);

                    // Guardar archivo
                    if(!Directory.Exists(oPath))
                    Directory.CreateDirectory(oPath);


                    e.UploadedFile.SaveAs(ofullFileName);

                    // Guardar en base de datos
                    using (var db = new EscuelasSandersonSatoriEntities())
                    {
                        var evidencia = new EvidenciaGasto
                        {
                            IdEvidencia = IdEvidencia,
                            IdGasto = gastoId,
                            NombreArchivo = nombreOriginal,
                            RutaArchivo = oPath,
                            Tamanio = Convert.ToInt32(e.UploadedFile.ContentLength / 1024),
                            TipoArchivo = extension,
                            FechaCarga = DateTime.Now,
                            UsuarioCarga = User.Identity.Name
                        };

                        db.EvidenciaGasto.Add(evidencia);
                        db.SaveChanges();
                    }

                    e.CallbackData = "success";
                }
                catch (Exception ex)
                {
                    e.ErrorText = $"Error al guardar: {ex.Message}";
                }
            }
            else
            {
                e.ErrorText = "No se pudo identificar el gasto asociado";
            }
        }

        protected void gvArchivos_DataBinding(object sender, EventArgs e)
        {
            if (hfIdGasto["IdGasto"] != null)
            {
                Guid idGasto = Guid.Parse(hfIdGasto["IdGasto"].ToString());
                using (var db = new EscuelasSandersonSatoriEntities())
                {
                    gvArchivos.DataSource = db.EvidenciaGasto
                        .Where(ev => ev.IdGasto == idGasto)
                        .OrderByDescending(ev => ev.FechaCarga)
                        .ToList();
                }
            }
        }

        protected void gvArchivos_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            Guid idEvidencia = Guid.Parse(e.Keys["IdEvidencia"].ToString());

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var evidencia = db.EvidenciaGasto.Find(idEvidencia);
                if (evidencia != null)
                {
                    // Eliminar archivo físico
                    string rutaFisica = Server.MapPath(evidencia.RutaArchivo);
                    if (File.Exists(rutaFisica))
                    {
                        File.Delete(rutaFisica);
                    }

                    // Eliminar registro de BD
                    db.EvidenciaGasto.Remove(evidencia);
                    db.SaveChanges();
                }
            }

            e.Cancel = true;
            gvArchivos.DataBind();
        }

        protected void gvGastos_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            // Puedes agregar lógica adicional si es necesario
        }

        protected void cbGuardarIdGasto_Callback(object sender, CallbackEventArgs e)
        {
            Session["CurrentIdGasto"] = e.Parameter;
            ViewState["CurrentIdGasto"] = e.Parameter;
        }
    }

}
