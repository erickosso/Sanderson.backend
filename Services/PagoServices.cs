using sanderson.backend.DAL;
using sanderson.backend.Reports;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;


namespace sanderson.backend.Services
{


    public class PagoService
    {
        private readonly EscuelasSandersonSatoriEntities _db;

        public PagoService()
        {
            _db = new EscuelasSandersonSatoriEntities();
        }



        public void GenerarPagosAutomaticos(DateTime fechaGeneracion, List<Guid> Escuelas )
        {
            // Obtener el ciclo escolar activo
            var cicloActivo = _db.CiclosEscolares.FirstOrDefault(c => c.activo==true);
            if (cicloActivo == null) throw new InvalidOperationException("No hay ciclo escolar activo");

            // Solo conceptos periódicos (colegiaturas/talleres)
            var conceptosPeriodicos = _db.ConceptosPago
                .Where(c => (c.tipo == "Colegiatura" || c.tipo == "Taller") &&
                           (c.escuela_id == null || Escuelas.Contains(c.escuela_id??Guid.Empty )))
                .ToList();

            var alumnosActivos = _db.Alumnos
                .Where(a => a.activo==true && Escuelas.Contains(a.escuela_id))
                .ToList();

            foreach (var alumno in alumnosActivos)
            {
                // Saltar mes sin pago para planes de 11 meses
                if (alumno.plan_pagos == "11_MESES" && fechaGeneracion.Month == alumno.mes_sin_pago)
                    continue;

                foreach (var concepto in conceptosPeriodicos)
                {
                    // Verificar que el concepto aplique para la escuela del alumno
                    if (concepto.escuela_id != null && concepto.escuela_id != alumno.escuela_id)
                        continue;

                    if (!ConceptoAplicaParaAlumno(concepto, alumno))
                        continue;

                    string periodoActual = fechaGeneracion.ToString("yyyy-MM");

                    bool pagoExistente = _db.Pagos.Any(p =>
                        p.alumno_id == alumno.alumno_id &&
                        p.concepto_id == concepto.concepto_id &&
                        p.periodo == periodoActual &&
                        p.ciclo_escolar == cicloActivo.nombre);

                    if (!pagoExistente)
                    {
                        var nuevoPago = new Pagos
                        {
                            pago_id = Guid.NewGuid(),
                            alumno_id = alumno.alumno_id,
                            concepto_id = concepto.concepto_id,
                            monto = alumno.plan_pagos == "11_MESES" && concepto.monto_11_meses.HasValue
                                ? concepto.monto_11_meses.Value
                                : concepto.monto_base,
                            fecha_aplicacion = fechaGeneracion,
                            fecha_vencimiento = new DateTime(
                                fechaGeneracion.Year,
                                fechaGeneracion.Month,
                                int.Parse(_db.ParametrosSistema.FirstOrDefault(p => p.clave == "DIA_VENCIMIENTO_PAGOS")?.valor ?? "10")),
                            periodo = periodoActual,
                            estado = "Pendiente",
                            escuela_id = alumno.escuela_id, // Asignar la escuela del alumno
                            ciclo_escolar = cicloActivo.nombre
                        };

                        if (concepto.aplica_beca == true)
                        {
                            nuevoPago = AplicarDescuentosBeca(nuevoPago, alumno);
                        }

                        _db.Pagos.Add(nuevoPago);
                    }
                }
            }
            _db.SaveChanges();
        }
        private bool ConceptoAplicaParaAlumno(ConceptosPago concepto, Alumnos alumno)
        {
            // Lógica para determinar si el concepto aplica para el nivel del alumno
            // Ejemplo: colegiaturas de primaria solo para alumnos de primaria
            if (concepto.tipo == "Colegiatura")
            {
                if (concepto.nombre.Contains("Preescolar") && alumno.nivel_id != 1)
                    return false;
                if (concepto.nombre.Contains("Primaria") && alumno.nivel_id != 2)
                    return false;
                if (concepto.nombre.Contains("Secundaria") && alumno.nivel_id != 3)
                    return false;
            }
            return true;
        }

        private Pagos AplicarDescuentosBeca(Pagos pago, Alumnos alumno)
        {
            // Obtener becas activas del alumno para la fecha del pago
            var becasActivas = alumno.AlumnosBecas
                .Where(b => b.activo == true &&
                       b.fecha_asignacion <= pago.fecha_aplicacion &&
                       (b.fecha_vencimiento == null || b.fecha_vencimiento >= pago.fecha_aplicacion))
                .ToList();

            if (becasActivas.Any())
            {
                // Aplicar el mayor descuento (en caso de múltiples becas)
                decimal porcentajeDescuento = becasActivas.Max(b => b.porcentaje_aplicado);
                pago.descuento = pago.monto * (porcentajeDescuento / 100);
                pago.beca_id = becasActivas.First(b => b.porcentaje_aplicado == porcentajeDescuento).beca_id;
            }

            return pago;
        }


        // Calcula recargos por mora
        public void AplicarRecargosAutomaticos(List<Guid> Escuelas )
        {
            // Obtener pagos vencidos y pendientes
            var query = _db.Pagos
                .Where(p => p.fecha_vencimiento < DateTime.Today && p.estado == "Pendiente");

            if (Escuelas.Count()!=0)
            {
                query = query.Where(p =>Escuelas.Contains( p.escuela_id??Guid.Empty) );
            }

            var pagosVencidos = query.ToList();
            var configRecargos = _db.RecargosConfig
                .OrderBy(r => r.dias_desde)
                .ToList(); // Ejemplo: [{dias_desde:1, porcentaje:10}, {dias_desde:30, porcentaje:20}]

            foreach (var pago in pagosVencidos)
            {
                var diasAtraso = DateTime.Today.Subtract(pago.fecha_vencimiento??DateTime.Today).Days;
                decimal porcentajeRecargo = 0;

                // Determinar el porcentaje de recargo basado en los días de atraso
                foreach (var config in configRecargos)
                {
                    if (diasAtraso >= config.dias_desde)
                    {
                        porcentajeRecargo = config.porcentaje;
                    }
                    else
                    {
                        break; // Las configs están ordenadas por dias_desde ascendente
                    }
                }

                if (porcentajeRecargo > 0)
                {
                    // Calcular monto del recargo
                    decimal montoRecargo = (pago.monto * porcentajeRecargo) / 100;

                    // Crear registro de recargo (asumo que tienes una entidad Recargo)
                    pago.recargo = montoRecargo;
                    // Opcional: Actualizar el monto total del pago (depende de tu lógica de negocio)
                    pago.estado = "Pendiente"; // O algún otro estado que uses
                }
            }

            _db.SaveChanges();
        }

        // Obtiene pagos pendientes con opción de filtro
        public List<PagoViewModel> GetPagosPendientes(Guid? IdAlumno = null, Guid? escuelaId = null)
        {
            var query = _db.Pagos
                .Include(p => p.Alumnos)
                .Include(p => p.ConceptosPago)
                .Where(p => p.estado == "Pendiente");

            if (IdAlumno!=null)
            {
                query = query.Where(p =>p.alumno_id==IdAlumno);
            }

            if (escuelaId.HasValue)
            {
                query = query.Where(p => p.escuela_id == escuelaId.Value);
            }

            return query
                .OrderBy(p => p.fecha_vencimiento)
                .ToList()
                .Select(p => new PagoViewModel
                {
                    PagoId = p.pago_id,
                    Alumno = p.Alumnos.nombre + " " + p.Alumnos.apellido_paterno,
                    Concepto = p.ConceptosPago.nombre,
                    Monto = p.monto,
                    Descuento = p.descuento ?? 0,
                    Recargo = p.recargo ?? 0,
                    Total = p.monto + (p.recargo ?? 0),
                    FechaVencimiento = p.fecha_vencimiento,
                    DiasVencidos = Math.Max(0, (DateTime.Today - (p.fecha_vencimiento ?? DateTime.Today)).Days),
                     escuela_id = p.escuela_id // Añadir esta propiedad al ViewModel
        }).ToList();
        }
        public void RegistrarPago(Guid pagoId, string metodoPago, string referencia ,decimal Montopagado)
        {
            using (var db = new EscuelasSandersonSatoriEntities())
            {
                var pago = db.Pagos.Find(pagoId);

                pago.estado = "Pagado";
                pago.metodo_pago = metodoPago;
                pago.fecha_pago = DateTime.Now;
                pago.referencia = referencia;
                pago.monto_pagado = Montopagado;
                db.SaveChanges();

                // Generar comprobante
                GenerarComprobantePDF(pago);
            }
        }

        public byte[] GenerarComprobantePDF(Pagos pago)
        {
            // Cargar diseño del reporte
            var report = new xrPago();

            report.pago_id.Value = pago.pago_id;

           
            // Generar PDF
            using (var ms = new MemoryStream())
            {
                report.ExportToPdf(ms);
                return ms.ToArray();
            }
        }


        public void CargarConceptosUnicosEnLote(Guid conceptoId, List<Guid> Escuelas ,int? gradoId = null, int?nivelid=null )
        {
            var concepto = _db.ConceptosPago.Find(conceptoId);
            if (concepto == null) throw new ArgumentException("Concepto no encontrado");

            var alumnos = _db.Alumnos
                .Where(a => a.activo==true &&
                           (Escuelas.Contains( a.escuela_id)) &&
                           (!gradoId.HasValue || a.grado_id == gradoId) &&
                           (!nivelid.HasValue || a.nivel_id == nivelid))
                .ToList();

            foreach (var alumno in alumnos)
            {
                CargarConceptosUnicosAlumno(alumno.alumno_id, alumno.escuela_id);
            }
        }


        public void CargarConceptosUnicosAlumno(Guid alumnoId, Guid? escuelaId = null)
        {
            var alumno = _db.Alumnos.Find(alumnoId);
            if (alumno == null) throw new ArgumentException("Alumno no encontrado");

            // Obtener conceptos únicos (inscripción, uniformes, etc.)
            var conceptosUnicos = _db.ConceptosPago
                .Where(c => (c.tipo == "Inscripcion" || c.tipo == "Uniforme" || c.tipo == "Material")  &&c.escuela_id==escuelaId)
                .ToList();

            foreach (var concepto in conceptosUnicos)
            {
                // Verificar si ya se cargó este concepto al alumno
                bool existePago = _db.Pagos.Any(p =>
                    p.alumno_id == alumnoId &&
                    p.concepto_id == concepto.concepto_id &&p.escuela_id==escuelaId &&
                    p.estado != "Cancelado");

                if (!existePago)
                {
                    var nuevoPago = new Pagos
                    {
                        pago_id = Guid.NewGuid(),
                        alumno_id = alumnoId,
                        concepto_id = concepto.concepto_id,
                        monto = concepto.monto_base,
                        fecha_aplicacion = DateTime.Now,
                        fecha_vencimiento = DateTime.Now.AddDays(15), // Plazo por defecto: 15 días
                        estado = "Pendiente",
                        escuela_id = escuelaId ?? alumno.escuela_id,
                        ciclo_escolar = _db.CiclosEscolares.First(c => c.activo==true).nombre
                    };

                    _db.Pagos.Add(nuevoPago);
                }
            }
            _db.SaveChanges();
        }
        public Pagos get_pago(Guid pago_id)
        {
            return _db.Pagos.Find(pago_id);
        }
    }

    // Clase auxiliar para mostrar pagos
    public class PagoViewModel
    {
        public Guid PagoId { get; set; }
        public string Alumno { get; set; }
        public string Concepto { get; set; }
        public decimal Monto { get; set; }
        public decimal Descuento { get; set; }
        public decimal Recargo { get; set; }
        public decimal Total { get; set; }
        public DateTime? FechaVencimiento { get; set; }
        public int DiasVencidos { get; set; }

        public Guid? escuela_id {set; get;}
    }
}