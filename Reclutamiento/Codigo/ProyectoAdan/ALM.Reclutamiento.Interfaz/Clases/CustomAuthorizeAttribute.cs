using ALM.Empresa.Interfaz.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace ALM.Empresa.Interfaz
{
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        public InformacionUsuarioLogueado.Privilegio AccessLevel { get; set; }
        public string Accion { get; set; }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {

            if (filterContext.HttpContext.User.Identity.IsAuthenticated)
            {
                if (InformacionUsuarioLogueado.EsSuperAdministrador && string.IsNullOrEmpty(InformacionUsuarioLogueado.CodigoSuperAdministrador))
                {
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Inicio", action = "AccesoDenegado" }));
                }
                else
                {
                    InformacionUsuarioLogueado.FechaActualizacionTimeOut = DateTime.Now;
                    if (!InformacionUsuarioLogueado.ValidarPermiso(filterContext.ActionDescriptor.ControllerDescriptor.ControllerType.Name, Accion, AccessLevel))
                    {
                        if (HttpContext.Current.Request.UrlReferrer != null)
                        {
                            string[] UrlFragment = HttpContext.Current.Request.UrlReferrer.LocalPath.Split('/');
                            var routeValues = new RouteValueDictionary();
                            if (UrlFragment.Length > 2 && !filterContext.HttpContext.Request.IsAjaxRequest())
                            {
                                routeValues["controller"] = UrlFragment[1];
                                string[] Action = UrlFragment[2].Split('?');
                                routeValues["action"] = Action[0];
                                if (Action.Length < 2)
                                {
                                    filterContext.Controller.TempData["SinAutorizacion"] = "No tienes los suficientes permisos para accesar. =(";
                                    filterContext.Result = new RedirectToRouteResult(routeValues);
                                }
                            }
                            else
                            {
                                filterContext.Result = new MenuController().PermisoInsuficiente();
                            }
                        }
                        else
                        {
                            var routeValues2 = new RouteValueDictionary();
                            routeValues2["controller"] = "Inicio";
                            routeValues2["action"] = "AccesoDenegado";
                            filterContext.Result = new RedirectToRouteResult(routeValues2);
                        }
                    }
                    else
                        base.OnAuthorization(filterContext);
                }

            }
            else
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Inicio", action = "AccesoDenegado" }));
        }
    }
}