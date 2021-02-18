using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web;
using ALM.Reclutamiento.Utilerias;
using System.IO;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class ReferenciasLaboralesController : Controller
    {
        #region ReferenciaLaboral
        [HttpPost]
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Prospecto_Index")]
        public ActionResult insertarReferenciaLaboral(EReferenciaLaboral referencia)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                referencia.Estatus = Convert.ToBoolean(1);
                referencia.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                var lista = new NReferenciaLaboral().insertarReferenciaLaboral(referencia, InformacionUsuarioLogueado.IdUsuario);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
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

        [HttpPost]
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Prospecto_Index")]
        public ActionResult actualizarReferenciaLaboral(EReferenciaLaboral referencia)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                referencia.Estatus = Convert.ToBoolean(1);
                referencia.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                new NReferenciaLaboral().ActualizarReferenciaLaboral(referencia, InformacionUsuarioLogueado.IdUsuario);
                dataRespuesta.MensajeUsuario = "Registro actualizado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerReferenciaLaboral(int idProspecto)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                EReferenciaLaboral referencia = new EReferenciaLaboral();

                referencia.IdProspecto = idProspecto;
                referencia.Estatus = Convert.ToBoolean(1);
                referencia.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                var lista = new NReferenciaLaboral().ObtenerReferenciaLaboralIdProspecto(referencia);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
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
        #endregion
    }
}