using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class VacantesController : Controller
    {
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Vacante_Index")]
        public ActionResult Vacante_Index()
        {
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Vacante_Index")]
        public ActionResult obtenerVacantes(EVacante param)
        {
            param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            var lista = new NVacante().ObtenerVacantes(param);
            dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
            dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";
            dataRespuesta.Codigo = "OK";
            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Vacante_Index")]
        public ActionResult ActualizarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {
            vacante.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
            vacante.IdUsuarioUltimoModifico = InformacionUsuarioLogueado.IdUsuario;

            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NVacante().ActualizarVacante(vacante, detalles); // CAT Para Agregar las Fuentes Seccionadas
                var pDetalles2 = detalles.Split('/')[1];
                var auxiliar = 0;
                if (pDetalles2 != "")
                {
                    new NVacante().InsertarVacante_Fuente(auxiliar, pDetalles2);
                }
                dataRespuesta.MensajeUsuario = "Registro actualizado exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
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
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = ex.Message;
                    errorObj.Traza = ex.StackTrace;
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                    dataRespuesta.Codigo = "ERR";

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            finally
            {
                dataRespuesta = null;
            }

        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Vacante_Index")]
        public ActionResult InsertarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                vacante.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                vacante.IdUsuarioCreacion = InformacionUsuarioLogueado.IdUsuario;
                int idInsertado = new NVacante().InsertarVacante(vacante, detalles); // CAT Para Agregar las Fuentes Seccionadas
                if (detalles != "") // No insertar
                {
                    new NVacante().InsertarVacante_Fuente(idInsertado, detalles);
                }
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { Info = idInsertado, msgResultado = "" }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
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
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = ex.Message;
                    errorObj.Traza = ex.StackTrace;
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                    dataRespuesta.Codigo = "ERR";

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Vacante_Index")]
        public ActionResult InsertarVacante_prospecto(int IdVacante, string detalles) 
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NVacante().InsertarVacante_prospecto(IdVacante, detalles); 
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { msgResultado = "" }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
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
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = ex.Message;
                    errorObj.Traza = ex.StackTrace;
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                    dataRespuesta.Codigo = "ERR";

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Vacante_Index")]
        public ActionResult InsertarVacante_prospectoInvitado(EVacante vacante, EProspecto[] prospectos, string detalles)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                vacante.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                vacante.IdUsuarioUltimoModifico = InformacionUsuarioLogueado.IdUsuario;
                new NVacante().InsertarVacante_prospectoInvitado(vacante ,prospectos, detalles);
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { msgResultado = "" }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
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
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = ex.Message;
                    errorObj.Traza = ex.StackTrace;
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                    dataRespuesta.Codigo = "ERR";

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Vacante_Index")]
        public ActionResult DesvincularVacanteProspecto(int IdVacante, int IdProspecto)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NVacante().EliminarVacante_prospecto(IdVacante, IdProspecto);
                dataRespuesta.MensajeUsuario = "Prospecto desvinculado exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { msgResultado = "" }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
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
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar desvincular el registro";

                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = ex.Message;
                    errorObj.Traza = ex.StackTrace;
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                    dataRespuesta.Codigo = "ERR";

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
            }
            finally
            {
                dataRespuesta = null;
            }
        }
    }
}