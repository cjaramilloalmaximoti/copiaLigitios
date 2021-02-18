using ALM.Empresa.Entidades;
using ALM.Empresa.Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class SeguimientoDeudorController : Controller
    {
        #region Selección

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult SeguimientoDeudor_Index(string recargar)
        {
            if (!string.IsNullOrEmpty(recargar))
            {
                TempData["Recargar"] = "true";
                TempData["NombreDeudor"] = InformacionUsuarioLogueado.NombreDeudor == null ? "null" : InformacionUsuarioLogueado.NombreDeudor;
                TempData["Global"] = InformacionUsuarioLogueado.Global == null ? "null" : InformacionUsuarioLogueado.Global;
            }
            else
            {
                TempData["Recargar"] = "false";
                TempData["NombreDeudor"] = "null";
                InformacionUsuarioLogueado.IdDeudor = null;
                InformacionUsuarioLogueado.NombreDeudor = null;
                InformacionUsuarioLogueado.IdSegmento = null;
                InformacionUsuarioLogueado.Global = null;
            }
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerSegmentosPorAnalista()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                var lista = new NSegmento().ObtenerSegmentosPorAnalista(InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerDeudoresPorAnalista(string nombre, bool global)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                var lista = new NDeudor().ObtenerDeudoresAnalista(InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdEmpresa, nombre, global);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerDeudoresPorAnalistaTelefono(string telefono, bool global) {
            Respuesta dataRespuesta = new Respuesta();
            try {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                var lista = new NDeudor().ObtenerDeudoresAnalistaTelefono(InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdEmpresa, telefono, global);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
            } catch (Exception ex) {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al consultar la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

            } finally {
                dataRespuesta = null;
            }
        }

        /**
         * Actualización: 
         * */
        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerDeudoresAcuerdoPago() {
            Respuesta dataRespuesta = new Respuesta();
            try {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                var lista = new NDeudor().ObtenerDeudoresAcuerdoPago(InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
            } catch (Exception ex) {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al consultar la información";

                EErrorDetalle errorObj = new EErrorDetalle();

                errorObj.Mensaje = ex.Message;
                errorObj.Traza = ex.StackTrace;

                dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

            } finally {
                dataRespuesta = null;
            }
        }
        //----- Actualización -------------- 


        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult EstablecerNavegacionDeudor(int idSegmento, int? idDeudor, string nombre, string global)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";


                InformacionUsuarioLogueado.IdDeudor = idDeudor;
                InformacionUsuarioLogueado.NombreDeudor = nombre != "nulo" ? nombre : null;
                InformacionUsuarioLogueado.IdSegmento = idSegmento;
                InformacionUsuarioLogueado.Global = global != "nulo" ? global : null;

                dataRespuesta.RespuestaInformacion = Json(new { Info = string.Empty }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult SeguimientoDeudor_Deudor()
        {
            if (InformacionUsuarioLogueado.IdSegmento == null)
            {
                return View("SeguimientoDeudor_Index");
            }
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerDeudoresAnalistaSeguimiento(bool siguiente)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var deudor = new NDeudor().ObtenerDeudoresAnalistaSeguimiento(
                    InformacionUsuarioLogueado.IdUsuario
                    , InformacionUsuarioLogueado.IdEmpresa
                    , InformacionUsuarioLogueado.IdSegmento.Value
                    , siguiente ? null : InformacionUsuarioLogueado.IdDeudor
                    , InformacionUsuarioLogueado.IdDeudor.HasValue ? InformacionUsuarioLogueado.IdDeudor.Value : 0
                    );

                if (deudor != null)
                {
                    InformacionUsuarioLogueado.IdDeudor = deudor.IdDeudor;
                }

                dataRespuesta.RespuestaInformacion = Json(new { Info = deudor }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtCatalogoTipoGestion()
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCatalogo().ObtCatalogoPorNombre(Constante.Catalogo.Tipo_Gestión.ToString(), InformacionUsuarioLogueado.IdEmpresa);

                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdCatalogo.ToString(),
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtCatalogoEstatusPorTipoGestion(int idTipoGestion)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NCatalogo().ObtInfoSubCatalogoPorNombrePadre(idTipoGestion, Constante.Subcatalogo.Estatus_Tipo_Gestion.ToString(), InformacionUsuarioLogueado.IdEmpresa);

                List<ESelect2Json> data = (from cartera in lista
                                           select new ESelect2Json()
                                           {
                                               id = cartera.IdCatalogo.ToString(),
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SeguimientoDeudor_Index")]
        public ActionResult InsertarAcuerdoPago(EAcuerdoPago acuerdo)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                acuerdo.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                acuerdo.IdDeudor = InformacionUsuarioLogueado.IdDeudor.Value;
                acuerdo.IdAnalista = InformacionUsuarioLogueado.IdUsuario;

                List<object> data = new NDeudor().InsertarAcuerdoPago(acuerdo, InformacionUsuarioLogueado.IdUsuario);
                data.Add(InformacionUsuarioLogueado.NombreUsuario);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = data, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SeguimientoDeudor_Index")]
        public ActionResult InsertarAgendarLlamadaDeudor(EAgendarLlamadaDeudor agendar)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            TimeSpan ts;
            try
            {
                ts = agendar.FechaAgenda - DateTime.Now;
                if (ts.TotalMinutes >= int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre.ToUpper().Equals("MinCallBack".ToUpper()) && x.IdEmpresa.Equals(InformacionUsuarioLogueado.IdEmpresa)).Valor) &&
                    ts.TotalMinutes <= int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre.ToUpper().Equals("MaxCallBack".ToUpper()) && x.IdEmpresa.Equals(InformacionUsuarioLogueado.IdEmpresa)).Valor)
                )
                {
                    agendar.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                    agendar.IdDeudor = InformacionUsuarioLogueado.IdDeudor.Value;
                    agendar.IdAnalista = InformacionUsuarioLogueado.IdUsuario;

                    List<object> data = new List<object>();
                    data.Add(new NDeudor().InsertarAgendarLlamadaDeudor(agendar, InformacionUsuarioLogueado.IdUsuario));
                    data.Add(InformacionUsuarioLogueado.NombreUsuario);

                    dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                    dataRespuesta.Codigo = "OK";

                    dataRespuesta.RespuestaInformacion = Json(new { Info = data, msgResultado = "" }, JsonRequestBehavior.AllowGet);

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "La fecha agendada no esta dentro del rango establecido";

                    dataRespuesta.Codigo = "ERR";

                    dataRespuesta.RespuestaInformacion = Json(new { Info = string.Empty, msgResultado = "" }, JsonRequestBehavior.AllowGet);

                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SeguimientoDeudor_Index")]
        public ActionResult InsertarSeguimientoDeudor(ESeguimientoDeudor segmento)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                segmento.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                segmento.IdDeudor = InformacionUsuarioLogueado.IdDeudor.Value;
                segmento.IdAnalista = InformacionUsuarioLogueado.IdUsuario;

                List<object> data = new List<object>();
                data.Add(new NDeudor().InsertarSeguimientoDeudor(segmento, InformacionUsuarioLogueado.IdUsuario));
                data.Add(InformacionUsuarioLogueado.NombreUsuario);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = data, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerSeguimientoDeudorDetalle()
        {
            Respuesta dataRespuesta = new Respuesta();
            List<ESeguimientoDeudorDetalle> data = null;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (InformacionUsuarioLogueado.IdDeudor.HasValue)
                {
                    data = new NDeudor().ObtenerSeguimientoDeudorDetalle(
                        InformacionUsuarioLogueado.IdDeudor.Value,
                        InformacionUsuarioLogueado.IdEmpresa
                        );
                }
                else
                {
                    data = new List<ESeguimientoDeudorDetalle>();
                }

                dataRespuesta.RespuestaInformacion = Json(new { Info = data }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SeguimientoDeudor_Index")]
        public ActionResult InsertarDatosContactoDeudor(EDatosContactoDeudor datos)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                datos.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                datos.IdDeudor = InformacionUsuarioLogueado.IdDeudor.Value;

                new NDeudor().InsertarDatosContactoDeudor(datos, InformacionUsuarioLogueado.IdUsuario);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = string.Empty, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerContactoDeudor(int pConsecutivo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var data = new NDeudor().ObtenerContactoDeudor(
                    InformacionUsuarioLogueado.IdDeudor.Value,
                    InformacionUsuarioLogueado.IdEmpresa,
                    pConsecutivo
                    );

                dataRespuesta.RespuestaInformacion = Json(new { Info = data }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "SeguimientoDeudor_Index")]
        public ActionResult InsertarPagoComprobado(EAcuerdoPago acuerdo)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                acuerdo.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                acuerdo.IdDeudor = InformacionUsuarioLogueado.IdDeudor.Value;
                acuerdo.IdAnalista = InformacionUsuarioLogueado.IdUsuario;

                List<object> data = new NDeudor().InsertarPagoComprobado(acuerdo, InformacionUsuarioLogueado.IdUsuario);
                data.Add(InformacionUsuarioLogueado.NombreUsuario);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = data, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "SeguimientoDeudor_Index")]
        public ActionResult ObtenerEstatusNoSeguimiento()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var data = new NDeudor().ObtenerEstatusNoSeguimiento(
                InformacionUsuarioLogueado.IdEmpresa
                );

                dataRespuesta.RespuestaInformacion = Json(new { Info = data }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                JsonResult json = Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                json.MaxJsonLength = Int32.MaxValue;

                return json;
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