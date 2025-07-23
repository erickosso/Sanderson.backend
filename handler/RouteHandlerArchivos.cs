using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Web.Routing;

public class DownloadEvidenciaRouteHandler : IRouteHandler
{
    public IHttpHandler GetHttpHandler(RequestContext requestContext)
    {
        return new DownloadEvidenciaHandler();
    }
}

