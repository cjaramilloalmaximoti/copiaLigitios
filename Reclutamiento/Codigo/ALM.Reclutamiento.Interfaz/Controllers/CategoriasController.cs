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
    public class CategoriasController : Controller
    {
        // GET: Categorias
        public ActionResult Categoria_Index()
        {
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Categoria_Index")]
        public ActionResult InsertarCategoria(ECategoria categoria)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                categoria.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                categoria.IdUsuarioUltimoModifico = InformacionUsuarioLogueado.IdUsuario;

                int idInsertado = new NCategoria().InsertarCategoria(categoria);


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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Categoria_Index")]
        public ActionResult obtenerCategorias(ECategoria param)
        {
            param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            var lista = new NCategoria().ObtenerCategorias(param);

            dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
            dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";
            dataRespuesta.Codigo = "OK";
            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Categoria_Index")]
        public ActionResult ActualizarCategoria(ECategoria categoria)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                categoria.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                categoria.IdUsuarioUltimoModifico = InformacionUsuarioLogueado.IdUsuario;

                new NCategoria().ActualizarCategoria(categoria);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Categoria_Index")]
        public ActionResult obtenerCategoriasTipo()
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            int empresaid = InformacionUsuarioLogueado.IdEmpresa;

            var lista = new NCategoria().obtenerCategoriasTipo(empresaid);

            dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
            dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";
            dataRespuesta.Codigo = "OK";
            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        }
    }
}