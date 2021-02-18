using ALM.Empresa.Entidades;
using ALM.Empresa.Negocio;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Collections.Generic;
using System.Security.Principal;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class InicioController : Controller
    {
        // GET: Inicio
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Menu");
            }
            return View();
        }
        
        [HttpPost]
        [AllowAnonymous]
        public ActionResult ValidarUsuario(EUsuario model, string returnUrl) {
            Respuesta dataRespuesta = new Respuesta();
            EUsuario usuario = null;
            try {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                var result = string.Empty;
                if (model.Login != null && model.Contrasenia != null) {
                    dataRespuesta.MensajeUsuario = "Usuario Encontrado/Logueado Correctamente";
                    dataRespuesta.Codigo = "OK";

                    usuario = new NUsuario().ValidarUsuario(model);
                    if (usuario != null)
                    {
                        if (usuario.EsSuperAdministrador)
                        {
                            dataRespuesta.Codigo = "OKAdm";
                        }
                        InformacionUsuarioLogueado.EstablecerInformacionUsuario(usuario, EClaseEstatica.RutaPublicado);
                        FormsAuthentication.SetAuthCookie(model.Login, false);
                        //ONC
                        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        //ONC
                        dataRespuesta.MensajeUsuario = "Credenciales inválidas";
                        dataRespuesta.Codigo = "ERROR";
                        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    dataRespuesta.Codigo = "ERROR";
                    dataRespuesta.MensajeUsuario = "Usuario y/o Contraseña vacío.";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("Controlado:"))
                {
                    dataRespuesta.MensajeUsuario = ex.Message;
                    dataRespuesta.Codigo = "ERROR";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Error de conexión con la base de datos, intente nuevamente.";
                    dataRespuesta.Codigo = "ERRORBD";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
        }

        [AllowAnonymous]
        public ActionResult AccesoUsuario()
        {
            if (User.Identity.IsAuthenticated)
            {
                HttpContext.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);
            }
            Session.Clear();
            Response.Cookies.Clear();
            FormsAuthentication.SignOut();
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return View("Index");
        }

        [AllowAnonymous]
        public ActionResult CerrarSesion()
        {
            Session.Clear();
            Response.Cookies.Clear();
            FormsAuthentication.SignOut();
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Inicio");
        }

        //[AllowAnonymous]
        //public ActionResult OlvideContrasenia()
        //{
        //    return View("OlvideContrasenia");
        //}

        //[HttpPost]
        //[AllowAnonymous]
        //[ValidateAntiForgeryToken]
        //public ActionResult EnviarCorreoContraseniaUsuario(EUsuario model, string returnUrl)
        //{
        //    model.CodigoRecuperaContrasenia = GenerarCodigo();
        //    try
        //    {
        //        Respuesta dataRespuesta = new Respuesta();
        //        dataRespuesta = new Respuesta();
        //        dataRespuesta.Codigo = "";
        //        EUsuario result = new NUsuario().RecuperarContraseniaUsuario(model, InformacionUsuarioLogueado.OrigenOperacion);

        //        NEnviarCorreo envioCorreo = new NEnviarCorreo();

        //        string idUserHexString = result.IdUsuario.ToString("X");

        //        List<string> segments = new List<string>();
        //        string[] segmentsArray = HttpContext.Request.UrlReferrer.OriginalString.Split('/');
        //        for (int i = 0; i < segmentsArray.Length; i++)
        //            segments.Add(segmentsArray[i]);

        //        segments.RemoveAt(segments.Count - 1);

        //        String baseUrl = "";


        //        segments.ForEach(delegate(string item)
        //        {
        //            baseUrl += item + "/";
        //        });

        //        envioCorreo.EnviarCorreo(model.CorreoElectronico, "", TipoCorreo.ReinicioContrasenia, "", model.IdEmpresa, datosComplementarios: baseUrl + "ReiniciarContrasenia/" + "|parametros=" + idUserHexString + "-" + result.CodigoRecuperaContrasenia);

        //        if (result != null)
        //        {
        //            dataRespuesta.MensajeUsuario = "Correcto";
        //            dataRespuesta.Codigo = "OK";
        //            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        //        }
        //        else
        //        {
        //            dataRespuesta.MensajeUsuario = "Formato incorrecto";
        //            dataRespuesta.Codigo = "ERROR";
        //            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Respuesta dataRespuesta = new Respuesta();
        //        dataRespuesta = new Respuesta();
        //        dataRespuesta.MensajeUsuario = "Error al realizar la operación";
        //        dataRespuesta.Codigo = "UNREGISTRED";
        //        EErrorDetalle errorObj = new EErrorDetalle();

        //        errorObj.Mensaje = ex.Message;
        //        errorObj.Traza = ex.StackTrace;

        //        dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

        //        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        //    }
        //}

        ///// <summary>
        ///// Se Llama cuando se da guardar al dar nueva contraseña sin estar logueado
        ///// </summary>
        ///// <param name="parametros"> cadena con idUsuario y Codigo de Recuperación</param>
        ///// <returns></returns>
        //[AllowAnonymous]
        //public ActionResult ReiniciarContrasenia(string parametros)
        //{
        //    string idUserString = parametros.Split('-')[0];
        //    string codigoReinicio = parametros.Split('-')[1];
        //    int idUser = int.Parse(idUserString, System.Globalization.NumberStyles.HexNumber);

        //    if (!string.IsNullOrEmpty(idUserString))
        //    {
        //        EUsuario usuarioReiniciar = new NUsuario().ConsultarUsuarioPorId(idUser, InformacionUsuarioLogueado.IdEmpresa);
        //        ViewData["DisableControles"] = "false";
        //        ViewData["btnActivo"] = "btnEnviarCorreo";


        //        if (usuarioReiniciar.CodigoRecuperaContrasenia != codigoReinicio)
        //        {
        //            ModelState.AddModelError("CustomError", "Ocurrio un error al restablecer la contraseña, o el usuario ya reestablecio su contraseña");
        //            ViewData["DisableControles"] = "true";
        //            ViewData["btnActivo"] = "btnEnviandoCorreo";
        //        }
        //        return View("ReestablecerContrasenia", new EUsuario() { IdUsuario = idUser, CodigoRecuperaContrasenia = codigoReinicio });
        //    }
        //    else
        //    {
        //        return AccesoUsuario();
        //    }
        //}

        /////<summary>
        /////Esta acción se llama cuando el usuario guarda su nueva contraseña, esto es cuando no esta firmado en el sistema
        /////</summary>        
        //[HttpPost]
        //[AllowAnonymous]
        //[ValidateAntiForgeryToken]
        //public ActionResult ReestablecerContraseniaUsuario(EUsuario model)
        //{
        //    NUsuario usuarioItem = new NUsuario();
        //    try
        //    {
        //        usuarioItem.ActualizarContraseniaUsuario(model, model.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

        //        return RedirectToAction("Index", "Inicio");
        //    }
        //    catch (Exception ex)
        //    {
        //        ModelState.AddModelError("CustomError", ex.Message);
        //        return View("ReestablecerContrasenia", model);
        //    }
        //}

        [AllowAnonymous]
        public ActionResult AccesoDenegado()
        {
            if (User!=null && User.Identity.IsAuthenticated)
            {
                HttpContext.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);

            }
            Session.Clear();
            Response.Cookies.Clear();
            FormsAuthentication.SignOut();
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return View("AccesoDenegado");
        }

        [AllowAnonymous]
        public ActionResult SesionFinalizada()
        {
            if (User.Identity.IsAuthenticated)
            {
                HttpContext.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);
            }
            Session.Clear();
            Response.Cookies.Clear();
            FormsAuthentication.SignOut();
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return View("SesionFinalizada");
        }

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private string GenerarCodigo()
        {
            int lenght = 8;
            string arreglo = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < lenght--)
            {
                res.Append(arreglo[rnd.Next(arreglo.Length)]);
            }
            return res.ToString();
        }

        private string GetBaseURL()
        {
            var ruta = System.Configuration.ConfigurationManager.AppSettings["RutaAppPublicada"];

            string strPathAndQuery = HttpContext.Request.Url.PathAndQuery;

            if (ruta != string.Empty)
            {
                return HttpContext.Request.Url.AbsoluteUri.Replace(strPathAndQuery, Constante.diag) + ruta + Constante.diag.ToString();
            }
            else
            {
                return HttpContext.Request.Url.AbsoluteUri.Replace(strPathAndQuery, Constante.diag);
            }
        }
    }
}