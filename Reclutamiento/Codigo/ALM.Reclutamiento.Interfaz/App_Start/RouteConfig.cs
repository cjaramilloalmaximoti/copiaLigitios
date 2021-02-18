using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace ALM.Empresa.Interfaz
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}/{id2}",
                defaults: new { controller = "Inicio", action = "Index", id = UrlParameter.Optional, id2 = UrlParameter.Optional }
            );
        }
    }
}
