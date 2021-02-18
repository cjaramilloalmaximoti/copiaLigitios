using ALM.Empresa.Entidades;
using ALM.Empresa.Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class SubCatalogoController : Controller
    {
        // GET: SubCatalogo
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult SubCatalogo_Index(int id, int id2)
        {
            TempData["IdTipoCatalogo"] = id;
            TempData["IdTipoCatalogo_SubCatalogo"] = id2;
            ViewData["TituloCatalogo"] = InformacionUsuarioLogueado.ObtenerNombreCatalogo(id);
            TempData["NombreCatalogo"] = InformacionUsuarioLogueado.ObtenerNombreSubCatalogo(id);
            TempData["NombreSubCatalogo"] = InformacionUsuarioLogueado.ObtenerNombreCatalogo(id);
            return View("SubCatalogo_Index");
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult ObtenerSubCatalogoDeCatalogoPadre(ESubCatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                var lista = new NSubCatalogo().ObtenerSubCatalogoDeCatalogoPadre(parametro);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al Privilegio1 la información";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult ObtCatalogoDelSubCatalogo(int idCatalogo)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCatalogo().ObtCatalogoDelSubCatalogo(idCatalogo, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al Privilegio1 la información";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult ObtInfoSubCatalogoPorIdPadre(int idCatalogo, int idTipoCatalogo)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCatalogo().ObtInfoSubCatalogoPorIdPadre(idCatalogo, idTipoCatalogo, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al Privilegio1 la información";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult ObtIdsCatalogosDelSubCatalogo(int idSubCatalogo)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NSubCatalogo().ObtIdsCatalogosDelSubCatalogo(idSubCatalogo, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al Privilegio1 la información";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SubCatalogo_Index")]
        public ActionResult InsertarSubCatalogo(ESubCatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                int idInsertado = new NSubCatalogo().InsertarSubCatalogo(parametro, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = idInsertado, msgResultado = "" }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                EErrorDetalle errorObj = new EErrorDetalle();
                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;
                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                dataRespuesta.Codigo = "ERR";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "SubCatalogo_Index")]
        public ActionResult ActualizarSubCatalogo(ESubCatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                new NSubCatalogo().ActualizarSubCatalogo(parametro, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

                dataRespuesta.MensajeUsuario = "Registro actualizado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                EErrorDetalle errorObj = new EErrorDetalle();
                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;
                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                dataRespuesta.Codigo = "ERR";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SubCatalogo_Index")]
        public ActionResult ObtenerCatalogosDelSubCatalogo(int idCatalogo)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NSubCatalogo().ObtenerCatalogosDelSubCatalogo(idCatalogo, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al Privilegio1 la información";

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