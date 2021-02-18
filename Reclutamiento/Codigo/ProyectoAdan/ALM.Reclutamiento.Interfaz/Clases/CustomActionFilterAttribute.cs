using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Clases
{
    [AttributeUsage(AttributeTargets.All)]
    public sealed class CustomActionFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpSessionStateBase objHttpSessionStateBase = null;
            try
            {
                if (filterContext != null)
                {
                    // Check if this action has NotAuthorizeAttribute
                    object[] attributes = filterContext.ActionDescriptor.GetCustomAttributes(true);
                    if (attributes == null || attributes.Length == 0 || !attributes.Any(a => a is AllowAnonymousAttribute))
                    {
                        objHttpSessionStateBase = filterContext.HttpContext.Session;
                        if (!System.Web.HttpContext.Current.User.Identity.IsAuthenticated && !objHttpSessionStateBase.IsNewSession)
                        {
                            if (filterContext.HttpContext.Request.IsAjaxRequest())
                            {
                                filterContext.HttpContext.Response.StatusCode = 200;
                            }
                            else
                            {
                                filterContext.Result = new RedirectResult("~/Inicio/SesionFinalizada");
                            }
                            return;
                        }
                    }
                    base.OnActionExecuting(filterContext);
                }
            }
            finally
            {
                objHttpSessionStateBase = null;
            }
        }
    }
}