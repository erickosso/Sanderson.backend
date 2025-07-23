<%@ WebHandler Language="C#" Class="ComprobanteHandler" %>

using System;
using System.Web;
using sanderson.backend.DAL;
using sanderson.backend.Services;

public class ComprobanteHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        Guid pagoId = Guid.Parse(context.Request.QueryString["id"]);

        using (var db = new EscuelasSandersonSatoriEntities())
        {
            var pago = db.Pagos.Find(pagoId);
            var servicio = new PagoService();
            byte[] pdfBytes = servicio.GenerarComprobantePDF(pago);

            context.Response.ContentType = "application/pdf";
            context.Response.AddHeader("Content-Disposition", $"attachment; filename=Comprobante_{pagoId}.pdf");
            context.Response.BinaryWrite(pdfBytes);
        }
    }

    public bool IsReusable => false;
}