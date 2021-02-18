using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web;
using ALM.Reclutamiento.Utilerias;
using System.IO;
using System.Text;
using System.Linq;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class CaracteristicasController : Controller
    {
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Caracteristicas_Index")]
        public ActionResult Caracteristicas_Index()
        {
            return View();
        }


        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Caracteristicas_Index")]
        public ActionResult ObtenerCaracteristicas(ECaracteristicas caracteristica, string masFiltros)
        {
            Respuesta dataRespuesta = new Respuesta();

            caracteristica.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
            caracteristica.IdUsuarioCreacion = InformacionUsuarioLogueado.IdUsuario;

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCaracteristicas().ObtenerCaracteristicas(caracteristica, masFiltros);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Caracteristicas_Index")]
        public ActionResult InsertarCaracteristica(ECaracteristicas carac, string detalles)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            string servidor = "";

            try
            {
                carac.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                carac.IdUsuarioCreacion = InformacionUsuarioLogueado.IdUsuario;
                carac.Usuario = InformacionUsuarioLogueado.NombreUsuario;
                carac.Empresa = InformacionUsuarioLogueado.Dominio;
                carac.codigoGenerado = GenerarCodigo();
                carac.Email = InformacionUsuarioLogueado.CorreoElectronico;
                servidor = EClaseEstatica.LstParametro.Find(x => x.Nombre == "ServidorDominio").Valor;

                int idInsertado = new NCaracteristicas().InsertarCaracteristica(carac, detalles, servidor, EClaseEstatica.LstParametro.Find(x => x.Nombre == "EmailSuperAdmin").Valor);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Caracteristicas_Index")]
        public ActionResult ActualizarCaracteristica(ECaracteristicas carac, string detalles)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            string servidor = "";

            try
            {
                carac.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                carac.IdUsuarioModificacion = InformacionUsuarioLogueado.IdUsuario;
                servidor = EClaseEstatica.LstParametro.Find(x => x.Nombre == "ServidorDominio").Valor;

                new NCaracteristicas().ActualizarCaracteristica(carac, detalles, servidor);

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

        public ActionResult linkAccion()
        {
            return View();
        }

        public ActionResult descifrarLink(string strLink)
        {
            Utilerias utilerias = new Utilerias();
            Respuesta dataRespuesta = new Respuesta();

            dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            utilerias.Clave = "";
            utilerias.Clave = utilerias.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);

            foreach (EReemplazarMVC reemplazar in EClaseEstatica.LstReemplazarMVC)
                strLink = strLink.Replace(reemplazar.Reemplazar, reemplazar.RealMVC);

            var linkDescifrado = utilerias.Descifrar(strLink);

            dataRespuesta.RespuestaInformacion = Json(new { Info = linkDescifrado }, JsonRequestBehavior.AllowGet);
            dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

            dataRespuesta.Codigo = "OK";

            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult validarCodigo(string codigo, int id)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";
                dataRespuesta.Codigo = "OK";

                var lista = new NCaracteristicas().ValidarCodigo(codigo, id);

                if (lista.Count == 0 || lista == null)
                {
                    dataRespuesta.MensajeUsuario = "El enlace NO es válido.";
                    dataRespuesta.Codigo = "";
                }

                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                
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
        public ActionResult aprobarRechazar(ECaracteristicas carac)
        {
            Respuesta dataRespuesta = new Respuesta();

            dataRespuesta.Codigo = "";

            try
            {
                new NCaracteristicas().aprobarRechazar(carac);

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


        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Caracteristicas_Index")]
        public ActionResult ObtenerTiposControl()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCaracteristicas().ObtenerTiposControl();
                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdTipoControl.ToString(),
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
    }
}