using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using sanderson.backend.DAL;
using sanderson.backend.Helpers.SistemaEscuelas.Utils;
using sanderson.backend.Utils;

namespace sanderson.backend
{
    public partial class _alumnos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarAlumnos();
            }
        }
        private void CargarAlumnos()
        {
            gvAlumnos.DataBind();
        }
        protected void gvAlumnos_DataBinding(object sender, EventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();

            (sender as ASPxGridView).DataSource = db.VAlumnos.Where(x => x.activo == true && UserInfo.EscuelasByUsuario.Contains(x.escuela_id)).ToList();
            (sender as ASPxGridView).KeyFieldName = "alumno_id";

        }
        protected void gvAlumnos_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                string gradoNivel = e.NewValues["GradoNivel"]?.ToString();
                var nivelGrado = db.VNivelGrado.FirstOrDefault(x => x.GradoNivel == gradoNivel);
                if (nivelGrado == null)
                {
                    e.Cancel = true;
                    return;
                }

                var nuevo = new Alumnos
                {
                    alumno_id = Guid.NewGuid(),
                    nombre = e.NewValues["nombre"]?.ToString().Trim(),
                    apellido_paterno = e.NewValues["apellido_paterno"]?.ToString().Trim(),
                    apellido_materno = e.NewValues["apellido_materno"]?.ToString().Trim(),
                    fecha_nacimiento = e.NewValues["fecha_nacimiento"] != null
                        ? Convert.ToDateTime(e.NewValues["fecha_nacimiento"]).Date
                        : (DateTime.MinValue),
                    curp = e.NewValues["curp"]?.ToString().Trim().ToUpper(),
                    nivel_id = nivelGrado.nivel_id,
                    grado_id = nivelGrado.grado_id,
                    alergias = e.NewValues["alergias"]?.ToString().Trim(),
                    observaciones = e.NewValues["observaciones"]?.ToString().Trim(),
                    telefono_emergencia = e.NewValues["telefono_emergencia"]?.ToString().Trim(),
                    contacto_emergencia = e.NewValues["contacto_emergencia"]?.ToString().Trim(),
                    escuela_id = (Guid)e.NewValues["escuela_id"],
                    plan_pagos = "11_MESES",
                    activo = true
                };

                db.Alumnos.Add(nuevo);
                db.SaveChanges();
            }

            gvAlumnos.CancelEdit();
            e.Cancel = true;
            gvAlumnos.DataBind();
        }
        protected void gvAlumnos_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            Guid alumnoId = (Guid)e.Keys["alumno_id"];

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var alumno = db.Alumnos.FirstOrDefault(a => a.alumno_id == alumnoId);
                if (alumno == null)
                {
                    e.Cancel = true;
                    return;
                }

                string gradoNivel = e.NewValues["GradoNivel"]?.ToString();
                var nivelGrado = db.VNivelGrado.FirstOrDefault(x => x.GradoNivel == gradoNivel);
                if (nivelGrado == null)
                {
                    e.Cancel = true;
                    return;
                }

                // Validaciones básicas (puedes expandirlas si lo deseas)
                if (string.IsNullOrWhiteSpace(e.NewValues["nombre"]?.ToString()) ||
                    string.IsNullOrWhiteSpace(e.NewValues["apellido_paterno"]?.ToString()) ||
                    string.IsNullOrWhiteSpace(e.NewValues["curp"]?.ToString()) ||
                    e.NewValues["curp"].ToString().Length != 18)
                {
                    e.Cancel = true;
                    return;
                }

                alumno.nombre = e.NewValues["nombre"]?.ToString().Trim();
                alumno.apellido_paterno = e.NewValues["apellido_paterno"]?.ToString().Trim();
                alumno.apellido_materno = e.NewValues["apellido_materno"]?.ToString().Trim();
                alumno.fecha_nacimiento = e.NewValues["fecha_nacimiento"] != null
                    ? Convert.ToDateTime(e.NewValues["fecha_nacimiento"]).Date
                    : (DateTime.MinValue);
                alumno.curp = e.NewValues["curp"]?.ToString().Trim().ToUpper();
                alumno.nivel_id = nivelGrado.nivel_id;
                alumno.grado_id = nivelGrado.grado_id;
                alumno.alergias = e.NewValues["alergias"]?.ToString().Trim();
                alumno.observaciones = e.NewValues["observaciones"]?.ToString().Trim();
                alumno.telefono_emergencia = e.NewValues["telefono_emergencia"]?.ToString().Trim();
                alumno.contacto_emergencia = e.NewValues["contacto_emergencia"]?.ToString().Trim();
                alumno.escuela_id = (Guid)e.NewValues["escuela_id"];

                alumno.activo = true;

                db.SaveChanges();
            }

            gvAlumnos.CancelEdit();
            e.Cancel = true;
            gvAlumnos.DataBind();
        }
        protected void gvAlumnos_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            Guid alumnoId = (Guid)e.Keys["alumno_id"];

            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var alumno = db.Alumnos.Find(alumnoId);

                // Eliminación lógica
                alumno.activo = false;
                db.SaveChanges();

                gvAlumnos.CancelEdit();
                e.Cancel = true;

            }
        }
        protected void gvTutores_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            // Validar email único si está presente
            string email = e.NewValues["email"] as string;

            var IdTutor = !e.IsNewRow ? (Guid)e.Keys["tutor_id"] : Guid.Empty;
            if (!string.IsNullOrEmpty(email))
            {
                using (var db = new EscuelasSandersonSatoriEntities())
                {
                    if (db.Tutores.Any(t => t.email == email && t.tutor_id != IdTutor))
                    {
                        //e.Errors.Add("email", "Este email ya está registrado para otro tutor");
                        ///    e.Errors.Add()
                    }
                }
            }
        }
        protected void gvTutores_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            var gvTutores = (sender as ASPxGridView);
            using (var context = new EscuelasSandersonSatoriEntities())
            {

                var alumnoId = (Guid)gvTutores.GetMasterRowKeyValue();
                var tutor = new Tutores
                {
                    tutor_id = Guid.NewGuid(),
                    alumno_id = alumnoId, // Método personalizado o valor en sesión
                    nombre = e.NewValues["nombre"]?.ToString(),
                    apellido_paterno = e.NewValues["apellido_paterno"]?.ToString(),
                    apellido_materno = e.NewValues["apellido_materno"]?.ToString(),
                    parentesco = e.NewValues["parentesco"]?.ToString(),
                    telefono = e.NewValues["telefono"]?.ToString(),
                    email = e.NewValues["email"]?.ToString(),
                    direccion = e.NewValues["direccion"]?.ToString(),
                    es_principal = e.NewValues["es_principal"] != null ? (bool?)e.NewValues["es_principal"] : null
                };

                context.Tutores.Add(tutor);
                context.SaveChanges();
            }

            e.Cancel = true;
            gvTutores.CancelEdit();
            gvTutores.DataBind();
        }
        protected void gvTutores_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var gvTutores = (sender as ASPxGridView);

            var tutorId = e.Keys["tutor_id"];
            using (var context = new EscuelasSandersonSatoriEntities())
            {
                var tutor = context.Tutores.Find(tutorId);
                if (tutor != null)
                {
                    tutor.nombre = e.NewValues["nombre"]?.ToString();
                    tutor.apellido_paterno = e.NewValues["apellido_paterno"]?.ToString();
                    tutor.apellido_materno = e.NewValues["apellido_materno"]?.ToString();
                    tutor.parentesco = e.NewValues["parentesco"]?.ToString();
                    tutor.telefono = e.NewValues["telefono"]?.ToString();
                    tutor.email = e.NewValues["email"]?.ToString();
                    tutor.direccion = e.NewValues["direccion"]?.ToString();
                    tutor.es_principal = e.NewValues["es_principal"] != null ? (bool?)e.NewValues["es_principal"] : null;
                    context.SaveChanges();
                }
            }
            e.Cancel = true;
            gvTutores.CancelEdit();
            gvTutores.DataBind();
        }
        protected void gvTutores_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            // Verificar si es el último tutor
            using (var db = new EscuelasSandersonSatoriEntities())
            {


                var gvtutores = (sender as ASPxGridView);

                var alumnoid = (Guid)gvtutores.GetMasterRowKeyValue();


                int totalTutores = db.Tutores.Count(t => t.alumno_id == alumnoid);

                if (totalTutores <= 1)
                {
                    throw new Exception("No se puede eliminar el único tutor del alumno");
                }


                var tutorId = (Guid)e.Keys["tutor_id"];
                // Verificar si es el tutor principal
                var tutor = db.Tutores.Find(tutorId);
                if (tutor.es_principal ?? false)
                {
                    throw new Exception("No se puede eliminar el tutor principal. Designe otro tutor como principal primero.");
                }

                else
                {
                    db.Tutores.Remove(tutor);
                    db.SaveChanges();
                }

                e.Cancel = true;
                gvtutores.CancelEdit();

            }
        }
        protected void gvPersonasAutorizadas_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            // Validaciones adicionales si son necesarias
        }
        protected void gvPersonasAutorizadas_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {

            var gvPersonasAutorizadas = (sender as ASPxGridView);
            Guid alumno_id = (Guid)gvPersonasAutorizadas.GetMasterRowKeyValue();
            using (var context = new EscuelasSandersonSatoriEntities())
            {
                var persona = new PersonasAutorizadas
                {
                    persona_id = Guid.NewGuid(),
                    alumno_id = alumno_id,
                    nombre = e.NewValues["nombre"]?.ToString(),
                    apellido_paterno = e.NewValues["apellido_paterno"]?.ToString(),
                    apellido_materno = e.NewValues["apellido_materno"]?.ToString(),
                    parentesco = e.NewValues["parentesco"]?.ToString(),
                    telefono = e.NewValues["telefono"]?.ToString(),
                    fecha_registro = DateTime.Today
                };

                context.PersonasAutorizadas.Add(persona);
                context.SaveChanges();
            }

            e.Cancel = true;
            gvPersonasAutorizadas.CancelEdit();
            gvPersonasAutorizadas.DataBind();
        }
        protected void gvPersonasAutorizadas_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var gvPersonasAutorizadas = (sender as ASPxGridView);

            Guid personaId = (Guid)e.Keys["persona_id"];

            using (var context = new EscuelasSandersonSatoriEntities())
            {
                var persona = context.PersonasAutorizadas.Find(personaId);
                if (persona != null)
                {
                    persona.nombre = e.NewValues["nombre"]?.ToString();
                    persona.apellido_paterno = e.NewValues["apellido_paterno"]?.ToString();
                    persona.apellido_materno = e.NewValues["apellido_materno"]?.ToString();
                    persona.parentesco = e.NewValues["parentesco"]?.ToString();
                    persona.telefono = e.NewValues["telefono"]?.ToString();
                    // fecha_registro generalmente no se actualiza, omitir si es necesario
                    context.SaveChanges();
                }
            }

            e.Cancel = true;
            gvPersonasAutorizadas.CancelEdit();
            gvPersonasAutorizadas.DataBind();
        }
        protected void gvPersonasAutorizadas_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            // Verificar si es la última persona autorizada
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var gvpersonas = (sender as ASPxGridView);
                var idPersona = (Guid)e.Keys["persona_id"];
                var alumnoid = (Guid)gvpersonas.GetMasterRowKeyValue();
                int totalPersonas = db.PersonasAutorizadas.Count(p => p.alumno_id == alumnoid);

                if (totalPersonas <= 1)
                {
                    throw new Exception("Debe haber al menos una persona autorizada para el alumno");
                }
                else
                {
                    var opersona = db.PersonasAutorizadas.Find(idPersona);
                    db.PersonasAutorizadas.Remove(opersona);
                    db.SaveChanges();
                }

                e.Cancel = true;
                gvpersonas.CancelEdit();
            }
        }
        protected void cbGrado_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {

            var cbNivel = gvAlumnos.FindEditFormTemplateControl("cbNivel") as DevExpress.Web.ASPxComboBox;
            if (cbNivel != null)
            {
                int nivelId = Convert.ToInt32(cbNivel.Value);
                // Aquí deberías cargar los grados basados en el nivelId
                // Por ejemplo:
                //dsGrados.WhereParameters["nivel_id"].DefaultValue = nivelId.ToString();
                //dsGrados.DataBind();
            }
        }
        protected void cbGrado_DataBinding(object sender, EventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            (sender as ASPxComboBox).DataSource = db.Grados.ToList();
        }
        protected void cbNivel_DataBinding(object sender, EventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            (sender as ASPxComboBox).DataSource = db.NivelesEducativos.ToList();
        }
        protected void gvPersonasAutorizadas_DataBinding(object sender, EventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            object alumnoId = grid.GetMasterRowKeyValue();
            var db = new EscuelasSandersonSatoriEntities();

            // Carga las personas autorizadas del alumno
            grid.DataSource = db.PersonasAutorizadas.Where(p => p.alumno_id == (Guid)alumnoId).ToList();

        }
        protected void gvTutores_DataBinding(object sender, EventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            object alumnoId = grid.GetMasterRowKeyValue();
            var db = new EscuelasSandersonSatoriEntities();
            // Carga los tutores del alumno
            grid.DataSource = db.Tutores.Where(t => t.alumno_id == (Guid)alumnoId).ToList();

        }
        protected void cbNivel_Init(object sender, EventArgs e)
        {
            var combo = sender as ASPxComboBox;
            if (combo == null) return;

            // Obtener el valor actual si estamos en modo edición
            var alumno_Id = gvAlumnos.IsEditing ? DataBinder.Eval(gvAlumnos.GetRow(gvAlumnos.EditingRowVisibleIndex), "alumno_id") as Guid? : null;


            using (var db = new EscuelasSandersonSatoriEntities())
            {
                combo.DataSource = db.VNivelGrado.ToList();

                combo.DataBind();

                if (alumno_Id.HasValue)
                {

                    var oalumno = db.VAlumnos.Where(x => x.alumno_id == alumno_Id).FirstOrDefault();

                    combo.Value = $"{oalumno.nivel_id}{oalumno.grado_id}";
                }
            }
        }
        protected void gvAlumnos_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string curp = e.NewValues["curp"] as string;
            Guid alumnoid = Guid.Empty;
            if (!e.IsNewRow)
            {
                alumnoid = (Guid)e.Keys["alumno_id"];

            }

            if (!string.IsNullOrEmpty(curp))
            {
                using (var db = new EscuelasSandersonSatoriEntities())
                {
                    if (db.Alumnos.Any(t => t.curp == curp && t.alumno_id != alumnoid && t.activo == true))
                    {
                        e.Errors.Add((sender as ASPxGridView).Columns["curp"], "Este Curp ya está registrado para otro alumno");
                        ///    e.Errors.Add()
                    }
                }
            }
        }
        protected void EntityServerModeDataSource1_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            e.QueryableSource = db.VNivelGrado.Select(x => x).OrderBy(c => c.nivel_id).ThenBy(x => x.grado_id);
            e.KeyExpression = "GradoNivel";
        }
        protected void dsEscuelas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            var db = new EscuelasSandersonSatoriEntities();
            e.KeyExpression = "escuela_id";

            e.QueryableSource = db.Escuelas.Where(x=>x.activo==true).Select(x => x).OrderBy(c => c.nombre).Where(x => UserInfo.EscuelasByUsuario.Contains(x.escuela_id));

        }



        }
    }



