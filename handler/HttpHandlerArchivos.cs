using sanderson.backend.DAL;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;


public class DownloadEvidenciaHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string idEvidenciaStr = context.Request.RequestContext.RouteData.Values["idEvidencia"] as string;

            if (!string.IsNullOrEmpty(idEvidenciaStr) && Guid.TryParse(idEvidenciaStr, out Guid idEvidencia))
            {
                using (var db = new EscuelasSandersonSatoriEntities())
                {
                    var evidencia = db.EvidenciaGasto.Find(idEvidencia);
                if (evidencia != null)
                {
                    string archivoFisico = Path.Combine(evidencia.RutaArchivo, $"{evidencia.IdEvidencia.ToString()}{evidencia.TipoArchivo}");

                        if (File.Exists(archivoFisico))
                        {
                            context.Response.Clear();
                            context.Response.ContentType = MimeMapping.GetMimeMapping(archivoFisico);
                            context.Response.AddHeader("Content-Disposition", $"attachment; filename=\"{evidencia.NombreArchivo}\"");
                            context.Response.TransmitFile(archivoFisico);
                            context.Response.End();
                            return;
                        }
                        else
                        {
                            context.Response.StatusCode = 404;
                            context.Response.Write("Archivo no encontrado.");
                            return;
                        }
                    }
                }

                context.Response.StatusCode = 404;
                context.Response.Write("Evidencia no encontrada.");
            }
            else
            {
                context.Response.StatusCode = 400;
                context.Response.Write("ID de evidencia inválido.");
            }
        }

        public bool IsReusable => false;
    }

