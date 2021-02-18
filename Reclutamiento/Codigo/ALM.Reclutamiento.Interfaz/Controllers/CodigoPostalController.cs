using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web;
using ALM.Reclutamiento.Utilerias;
using System.IO;
using System.Xml;
using System.Threading.Tasks;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class CodigoPostalController : Controller
    {
        #region CodigoPostal

        public ActionResult CodigoPostal_Index()
        {
            return View();
        }
        
        [HttpPost]
        public ActionResult CargaCodigoPostal(CargaArchivo carga)
        {

            Respuesta dataRespuesta = new Respuesta();
            try
            {
                if (carga.file.ContentLength > 0)
                {
                    int idUser = InformacionUsuarioLogueado.IdUsuario;

                    Stream file = carga.file.InputStream;
                    XmlDocument xmlCol = new XmlDocument();
                    xmlCol.Load(file); // suppose that myXmlString contains "<Names>...</Names>"


                    string pais = carga.Id;




                    new NCodigoPostal().CargarCodigosPostales(xmlCol, carga.Id, InformacionUsuarioLogueado.IdUsuario);
                    new Task(() => { new NCodigoPostal().CargarCodigosPostalesColonias(xmlCol, pais, idUser); }).Start();
                    //new NCodigoPostal().CargarCodigosPostalesColonias(carga.file.InputStream, carga.Id, InformacionUsuarioLogueado.IdUsuario);


                }

                dataRespuesta.MensajeUsuario = "Carga codigos postales satisfactoria.";
                dataRespuesta.Codigo = "OK";
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al  cargar codigos postales.";
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
        public ActionResult ObtenerFecha(string pais)
        {

            Respuesta dataRespuesta = new Respuesta();
            try
            {

                int idUser = InformacionUsuarioLogueado.IdUsuario;


                string respuesta = new NCodigoPostal().ObtenerFechaUltimaCarga(pais, InformacionUsuarioLogueado.IdUsuario);



                dataRespuesta.MensajeUsuario = respuesta;
                dataRespuesta.Codigo = "OK";
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al obtener fecha de ultima carga.";
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

        public ActionResult ObtenerPaises()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().ObtenerPaises("", 1);
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

        public ActionResult ObtenerEstados(string clavePais)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().Obtenerestados(clavePais, 1);
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

        public ActionResult ObtenerCiudades(string claveEstado, string nombre)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().ObtenerCiudades(claveEstado, nombre, 1);
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
        public ActionResult ObtenerCiudadTexto(string claveEstado,string claveCiudad)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().ObtenerCiudadTexto(claveEstado,claveCiudad);
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
        
        public ActionResult ObtenerColonias(string claveCiudad, string nombre, string claveEstado)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().ObtenerColonias(claveCiudad, claveEstado, nombre, 1);
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

        public ActionResult buscarCP(string CP)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCodigoPostal().buscarCP(CP);
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