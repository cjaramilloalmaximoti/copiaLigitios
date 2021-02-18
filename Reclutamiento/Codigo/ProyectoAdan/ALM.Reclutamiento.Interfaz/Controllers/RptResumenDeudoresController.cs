using ALM.Empresa.Entidades;
using ALM.Empresa.Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    
    public class RptResumenDeudoresController : Controller
    {
        /*
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult RptResumenDeudores_Index()
        {
            return View();
        }


        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult RptResumenDeudores_Exportar(string nombreArchivo)
        {
            byte[] bytesLeidos = null;
            string rutaCompleta = null;
            try
            {
                rutaCompleta = EClaseEstatica.RutaPublicado + @"Archivos\" + InformacionUsuarioLogueado.IdEmpresa.ToString() + @"\Reportes\" + nombreArchivo;

                if (System.IO.File.Exists(rutaCompleta))
                {
                    bytesLeidos = System.IO.File.ReadAllBytes(rutaCompleta);
                    System.IO.File.Delete(rutaCompleta);
                    return File(bytesLeidos, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", nombreArchivo);
                }
                else
                {
                    return null;
                }
            }
            finally
            {
                bytesLeidos = null;
                rutaCompleta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult ObtenerCarteras(string cadenaBuscar)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCartera().ObtenerClientesCarteras(cadenaBuscar, InformacionUsuarioLogueado.IdEmpresa);

                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdCartera.ToString(),
                                               text = cartera.Nombre
                                           }).ToList<ESelect2Json>();

                dataRespuesta.RespuestaInformacion = Json(new { Info = data }, JsonRequestBehavior.AllowGet);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult ObtenerUsuariosAnalista(string cadenaBuscar, bool filtro)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NUsuario().ObtenerUsuariosAnalista(cadenaBuscar, InformacionUsuarioLogueado.IdEmpresa);
                if (filtro && !string.IsNullOrEmpty(cadenaBuscar) && "NO ASIGNADOS".ToUpper().Contains(cadenaBuscar.ToUpper()))
                {
                    lista.Add(new ESelect2Json() { id = "0", text = "NO ASIGNADOS" });
                }

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult ObtenerSegmentos(string cadenaBuscar)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NSegmento().ObtenerSegmentosBuscar(cadenaBuscar, InformacionUsuarioLogueado.IdEmpresa);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "RptResumenDeudores_Index")]
        public ActionResult ObtenerReporteResumen(int? pIdCartera, int? pIdUsuario, int? pIdSegmento, int pIdTipoEstatus, int pActivo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var archivo = new NReportes().ObtenerReporteResumen(pIdCartera, pIdUsuario, pIdSegmento, InformacionUsuarioLogueado.IdEmpresa, pIdTipoEstatus, pActivo, EClaseEstatica.RutaPublicado + @"Archivos\");

                dataRespuesta.RespuestaInformacion = Json(new { Info = archivo }, JsonRequestBehavior.AllowGet);
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
        */
    }
}