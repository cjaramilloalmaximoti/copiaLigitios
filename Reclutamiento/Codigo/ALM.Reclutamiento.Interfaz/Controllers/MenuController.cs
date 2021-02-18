using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class MenuController : Controller
    {
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Index")]
        public ActionResult Index()
        {
            if (InformacionUsuarioLogueado.EsSuperAdministrador && string.IsNullOrEmpty(InformacionUsuarioLogueado.CodigoSuperAdministrador))
            {
                return View("AccesoDenegado");
            }
            else
            {
                return View();
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Index")]
        public ActionResult ObtenerListadoMenu()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                dataRespuesta.RespuestaInformacion = Json(new { Info = InformacionUsuarioLogueado.LstFormasMenu }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al consultar la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        public ActionResult PermisoInsuficiente()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                dataRespuesta.RespuestaInformacion = Json(new { Info = InformacionUsuarioLogueado.LstFormasMenu }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Permisos insuficientes para realizar la acción.";

                dataRespuesta.Codigo = "ERR";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al consultar la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Index")]
        public ActionResult Body_Click(int timeOut)
        {
            Respuesta dataRespuesta = new Respuesta();
            double milisegundos = 0;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                try
                {
                    DateTime fechaInicial = InformacionUsuarioLogueado.FechaActualizacionTimeOut;
                    TimeSpan fechaFinal = fechaInicial.AddMilliseconds(timeOut) - DateTime.Now;
                    milisegundos = fechaFinal.TotalMilliseconds - InformacionUsuarioLogueado.SegundosAntesFinalizarTimeOut;
                }
                catch { }

                milisegundos = milisegundos <= 0 ? 0 : milisegundos;

                dataRespuesta.RespuestaInformacion = Json(new { Info = int.Parse(milisegundos.ToString().Split('.')[0].Split(',')[0]) }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al consultar la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        public ActionResult EstablecerCodigo(string codigo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {
                    if (new NUsuario().LimpiarEmpresa(codigo, InformacionUsuarioLogueado.IdEmpresa))
                    {
                        
                        InformacionUsuarioLogueado.CodigoSuperAdministrador = codigo;
                        dataRespuesta.RespuestaInformacion = Json(new { Info = string.Empty }, JsonRequestBehavior.AllowGet);
                        dataRespuesta.MensajeUsuario = string.Empty;
                        dataRespuesta.Codigo = "OK";
                    }
                    else
                    {
                        dataRespuesta.MensajeUsuario = "Código invalido";
                        dataRespuesta.Codigo = "ERROR";
                    }
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "No tienes permiso para establecer el valor";
                    dataRespuesta.Codigo = "ERROR";
                }
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al establecer la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }
    }
}