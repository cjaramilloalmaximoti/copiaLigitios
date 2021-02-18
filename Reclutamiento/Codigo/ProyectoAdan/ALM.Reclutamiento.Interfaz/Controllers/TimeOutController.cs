using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;

namespace ALM.Empresa.Interfaz.Controllers
{
    [SessionState(SessionStateBehavior.ReadOnly)]
    public class TimeOutController : Controller
    {
        [HttpPost]
        public ActionResult VerificarTimeOut(int timeOut)
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
    }
}