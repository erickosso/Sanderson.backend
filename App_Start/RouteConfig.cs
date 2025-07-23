using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace sanderson.backend
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);

            RegisterMainRoutes(routes);
        }

        public static void RegisterMainRoutes  (RouteCollection routes)
        {

            routes.MapPageRoute("", "", "~/Default.aspx");
            routes.MapPageRoute("_alumnos", "alumns/manage", "~/_alumnos.aspx");
            routes.MapPageRoute("_alumnos_becas", "alumns/manage/scholarships", "~/_becas_alumno.aspx");
            routes.MapPageRoute("_conceptos_pago", "cat/manage/payments", "~/_conceptos_pago.aspx");
            routes.MapPageRoute("_becas", "cat/manage/scholarships", "~/_becas.aspx");
            routes.MapPageRoute("_pagos_pendiente", "alumnos/payments/pending", "~/_pagos_pendientes.aspx");
            routes.MapPageRoute("_pagos_pendiente_alumno", "alumnos/payments/pending/{alumno_id}", "~/_pagos_pendientes_byalumno.aspx");
            routes.MapPageRoute("_pagos_pagar", "alumnos/payments/pay/{pago_id}/do", "~/_pago_registar.aspx");
            routes.MapPageRoute("_pagos_realizados", "alumnos/payments/view/complete", "~/_pagos_realizados.aspx");
            routes.MapPageRoute("_pagos_realizados_alumno", "alumnos/payments/view/complete/alumno/get/{alumno_id}", "~/_pagos_realizados_byalumno.aspx");
            routes.MapPageRoute("_gastos", "outs/view/all", "~/_gastos.aspx");


            routes.MapPageRoute("_cortes_caja", "financial/history/view/all/show", "~/Pages/Cortes/_cortes_caja.aspx");
            routes.MapPageRoute("_close_cortes_caja", "financial/close/{corte_id}/byid", "~/Pages/Cortes/_cerrar_corte.aspx");

            routes.Add("DescargarEvidenciaRoute", new Route("EvidenciaGastos/descargar/{idEvidencia}", new DownloadEvidenciaRouteHandler()));

        }
    }
}
