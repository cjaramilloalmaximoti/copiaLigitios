using ALM.Empresa.Entidades;
using ALM.Empresa.Negocio;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class SegmentoController : Controller
    {
        /*
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        // GET: Segmento
        public ActionResult Segmento_Index()
        {
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerSegmentos(int? pIdCartera, int? pIdCliente)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                var lista = new NSegmento().ObtenerSegmentos(pIdCartera, pIdCliente, InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Segmento_Index")]
        public ActionResult InsertarSegmento(int pIdCartera, string pSegmento, string pFecha,  string pArchivo, bool pEsActivo, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            ESegmento segmento = null;
            BinaryReader b = null;
            try
            {
                segmento = new ESegmento();
                segmento.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                segmento.IdCartera = pIdCartera;
                segmento.Segmento = pSegmento;
                segmento.Fecha = DateTime.Parse(pFecha);
                segmento.Archivo = pArchivo;
                segmento.EsActivo = pEsActivo;

                if (file != null)
                {
                    segmento.Archivo = Path.GetFileName(file.FileName);
                    b = new BinaryReader(file.InputStream);
                    segmento.IdSegmento= new NSegmento().InsertarSegmento(segmento, InformacionUsuarioLogueado.IdUsuario, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Archivos\");
                }
                else
                {
                    throw new Exception("No se selecciono un archivo para el segmento");
                }
                
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = segmento.IdSegmento, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
                segmento = null;
                b = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Segmento_Index")]
        public ActionResult ActualizarSegmento(int pIdSegmento, int pIdCartera, string pSegmento, string pFecha, string pArchivo, bool pEsActivo, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            ESegmento segmento = null;
            BinaryReader b = null;
            try
            {
                segmento = new ESegmento();
                segmento.IdSegmento = pIdSegmento;
                segmento.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                segmento.IdCartera = pIdCartera;
                segmento.Segmento = pSegmento;
                segmento.Fecha = DateTime.Parse(pFecha);
                segmento.Archivo = pArchivo;
                segmento.EsActivo = pEsActivo;

                if (file != null)
                {
                    segmento.Archivo = Path.GetFileName(file.FileName);
                    b = new BinaryReader(file.InputStream);
                    new NSegmento().ActualizarSegmento(segmento, InformacionUsuarioLogueado.IdUsuario, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Archivos\");
                }
                else
                {
                    new NSegmento().ActualizarSegmento(segmento, InformacionUsuarioLogueado.IdUsuario, null, null);
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
                segmento = null;
                b = null;
            }
        }
        
        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerCarterasXNombre(string cadenaBuscar)
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerClientes(string cadenaBuscar)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCliente().ObtenerClientesCarteraTodos(cadenaBuscar, InformacionUsuarioLogueado.IdEmpresa);

                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdCliente.ToString(),
                                               text = cartera.NombreComercial
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerCarteras(string cadenaBuscar)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCartera().ObtenerCarteras(cadenaBuscar, -1, InformacionUsuarioLogueado.IdEmpresa);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerColumnasSegmento(int idSegmento)
        {
            Respuesta dataRespuesta = new Respuesta();
            List<object> lstObject = null;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                lstObject = new List<object>();

                var lista = new NSegmento().ObtenerColumnasSegmento(idSegmento, InformacionUsuarioLogueado.IdEmpresa);
                var lista2 = new NSegmento().ObtenerMapeoSegmento(idSegmento, InformacionUsuarioLogueado.IdEmpresa);
                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdColumnaSegmento.ToString(),
                                               text = cartera.Encabezado
                                           }).ToList<ESelect2Json>();

                lstObject.Add(data);
                lstObject.Add(lista2);

                dataRespuesta.RespuestaInformacion = Json(new { Info = lstObject }, JsonRequestBehavior.AllowGet);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult ObtenerMapeoSegmento(int idSegmento)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NSegmento().ObtenerMapeoSegmento(idSegmento, InformacionUsuarioLogueado.IdEmpresa);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Segmento_Index")]
        public ActionResult InsertarMapeoSegmento(List<EMapeoColumna> lst)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";            
            try
            {
                foreach (EMapeoColumna mapeo in lst)
                {
                    mapeo.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                }

                new NSegmento().InsertarMapeoSegmento(lst);                 

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Segmento_Index")]
        public ActionResult CargarDeudores(int idSegmento, string segmento, string archivo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var detalle = new NSegmento().GuardarInformacionDeudores(idSegmento, segmento, InformacionUsuarioLogueado.IdEmpresa, archivo, EClaseEstatica.RutaPublicado + @"Archivos\", InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.CorreoElectronico);

                dataRespuesta.RespuestaInformacion = Json(new { Info = detalle }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Se guardo correctamente la información de deudores";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al cargar la información de deudores";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Segmento_Index")]
        public ActionResult EliminarInformacionDeudores(int pIdSegmento, bool pEliminar, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            BinaryReader b = null;
            try
            {
                b = new BinaryReader(file.InputStream);
                var cuantosDeudores = new NSegmento().EliminarInformacionDeudores(pIdSegmento, InformacionUsuarioLogueado.IdEmpresa, b.ReadBytes((int)file.ContentLength), InformacionUsuarioLogueado.IdUsuario, pEliminar);

                dataRespuesta.MensajeUsuario = "Registros eliminados exitosamente";
                dataRespuesta.Codigo = "OK";
                dataRespuesta.RespuestaInformacion = Json(new { Info = cuantosDeudores, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
                b = null;
            }
        }
        */
    }
}