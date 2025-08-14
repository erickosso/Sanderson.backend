<%@ WebHandler Language="C#" Class="ComprobanteGastoHandler" %>

using System;
using System.Web;
using sanderson.backend.DAL;
using sanderson.backend.Services;
using System.IO;
using sanderson.backend.Reports;

public class ComprobanteGastoHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        Guid pagoId = Guid.Parse(context.Request.QueryString["id"]);

        using (var db = new EscuelasSandersonSatoriEntities())
        {
    

            // Cargar diseño del reporte
            var report = new xrCorteCaja();

            report.IdCorte.Value = pagoId;


            // Generar PDF
            using (var ms = new MemoryStream())
            {
                report.ExportToPdf(ms);
                var pdfBytes = ms.ToArray();

                context.Response.ContentType = "application/pdf";
                context.Response.AddHeader("Content-Disposition", $"attachment; filename=Comprobante_{pagoId}.pdf");
                context.Response.BinaryWrite(pdfBytes);
            }




        }
    }

    public bool IsReusable => false;
}