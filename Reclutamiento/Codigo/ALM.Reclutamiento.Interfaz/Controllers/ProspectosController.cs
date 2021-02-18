using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Web.Mvc;
using System.Web;
using System.IO;
using System.Collections.Generic;//FSALAZAR 08/04/2019 REQ03042019: Se importa las colleciones para controlar listas
using System.Linq;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class ProspectosController : Controller
    {
        #region Prospecto(metodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult Prospecto_Index()
        {
            return View();
        }

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult Prospect_Detalle()
        {
            return View();
        }

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult Prospecto_Listado()
        {
            return View();
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerProspectos(string nombre, int activo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NProspecto().ObtenerProspectos(nombre, activo, InformacionUsuarioLogueado.IdEmpresa);
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

        //FSALAZAR 04/04/2019 REQ03042019 INI: Se pasan los dos nuevos valores junto con lo que ya exiten
        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerProspectosCaracteristicas(string nombre, int activo,  List<ECaracteristicas> ListaCaracteristicas, List<ECaracteristicasGenerales> ListaCaracteristicasGenerales)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                string arrayCaracteristicas="";
                string cadenaId = "";
                if(ListaCaracteristicas != null)
                {
                    foreach (ECaracteristicas caracteristica in ListaCaracteristicas)
                    {
                        arrayCaracteristicas +=  caracteristica.IdCaracteristica + "^" + caracteristica.ValorTipoControl + "^" + caracteristica.TipoControl +"|";
                        if(caracteristica != ListaCaracteristicas.First())
                        {
                            cadenaId += ",";
                        }
                        cadenaId += caracteristica.IdCaracteristica;
                    }
                }

                var lista = new NProspecto().ObtenerProspectosCaracteristicas(nombre, activo, arrayCaracteristicas, InformacionUsuarioLogueado.IdEmpresa, ListaCaracteristicasGenerales);
                var listaCarac = new List<ECaracteristicasProspectos>();
                var listaCaracNombre = new List<ECaracteristicas>();
                if (cadenaId != "")
                {
                    listaCarac = new NProspecto().ObtenerCaracteristicas(cadenaId);
                    listaCaracNombre = new NProspecto().ObtenerCaracteristicasIds(cadenaId);
                }
                
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista, Valores = listaCarac, Caracteriticas = listaCaracNombre }, JsonRequestBehavior.AllowGet);
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
        //FSALAZAR 04/04/2019 REQ03042019 FIN


        //DESDE AQUI JARAMILLO
        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerProspectosCaracteristicasSeleccionados(string []listaSeleccionados)
        {            
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                string arrayCaracteristicas = "";
  
                var lista = new NProspecto().ObtenerProspectosCaracteristicasSeleccionados(listaSeleccionados);

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
        //HASTA AQUI JARAMILLO



        // CAT
        [HttpPost]
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult obtenerProsVacante(string IdVacante)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NProspecto().ObtenerProspectosVacante(Convert.ToInt32(IdVacante), InformacionUsuarioLogueado.IdEmpresa);
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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult obtenerProspectosPorCaracteristicas(string ParametrosXML, int IdSexo, int IdEstadoCivil, int IdEscolaridad, int EdadMin, int EdadMax, int IdVacante)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                //string sParametrosXML = ParametrosXML.Replace("[", "<").Replace("]", ">");

                var lista = new NProspecto().ObtenerProspectosPorCaracteristicas(InformacionUsuarioLogueado.IdEmpresa, ParametrosXML, IdSexo, IdEstadoCivil, IdEscolaridad, EdadMin, EdadMax, IdVacante);
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

        // CAT
        [HttpPost]
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult obtenerProsCliente(int IdCliente)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NProspecto().ObtenerProspectosCliente(IdCliente);
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

        // CAT
        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerProspectoId(string id)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NProspecto().ObtenerProspectoId(Convert.ToInt32(id));
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Prospecto_Index")]
        public ActionResult InsertarProspecto(EProspecto prospecto, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            BinaryReader b = null;

            dataRespuesta.Codigo = "";
            int idInsertado = 0;

            try
            {
                prospecto.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                if (file != null)
                {
                    prospecto.Foto = "." + Path.GetFileName(file.FileName.Split('.')[1]);
                    //prospecto.Foto = file.ContentType;
                    b = new BinaryReader(file.InputStream);

                    idInsertado = new NProspecto().InsertarProspecto(prospecto, InformacionUsuarioLogueado.IdUsuario, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Documentos\Empresa" + InformacionUsuarioLogueado.IdEmpresa);
                }
                else
                {
                    idInsertado = new NProspecto().InsertarProspecto(prospecto, InformacionUsuarioLogueado.IdUsuario, null, null);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Prospecto_Index")]
        public ActionResult ActualizarProspecto(EProspecto prospecto, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            BinaryReader b = null;

            dataRespuesta.Codigo = "";

            try
            {

                int IdSexo = 1;
                int IdEstadoCivil = 1;
                int IdEscolaridad = 1;
                int EdadMin = 1;
                int EdadMax = 1;
                string ParametrosXML = "< Parametros >< Parametro >< IdCaracteristicaParticular > 31 </ IdCaracteristicaParticular >< Valor > Alto </ Valor ></ Parametro >< Parametro >< IdCaracteristicaParticular > 28 </ IdCaracteristicaParticular >< Valor > true </ Valor ></ Parametro ></ Parametros >";
                // string ParametrosXML = "[Parametros][Parametro][IdCaracteristicaParticular]33[/IdCaracteristicaParticular][Valor]6[/Valor][/Parametro][Parametro][IdCaracteristicaParticular]206[/IdCaracteristicaParticular][Valor]5[/Valor][/Parametro][Parametro][IdCaracteristicaParticular]49[/IdCaracteristicaParticular][Valor]true[/Valor][/Parametro][Parametro][IdCaracteristicaParticular]31[/IdCaracteristicaParticular][Valor]Regular[/Valor][/Parametro][/Parametros]";
                var a = obtenerProspectosPorCaracteristicas(ParametrosXML, IdSexo, IdEstadoCivil, IdEscolaridad, EdadMin, EdadMax, 0);


                prospecto.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                if (file != null)
                {
                    prospecto.Foto = prospecto.IdProspecto + "." + Path.GetFileName(file.FileName.Split('.')[1]);
                    b = new BinaryReader(file.InputStream);

                    new NProspecto().ActualizarProspecto(prospecto, InformacionUsuarioLogueado.IdUsuario, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Documentos\Empresa" + InformacionUsuarioLogueado.IdEmpresa);
                }
                else
                {
                    new NProspecto().ActualizarProspecto(prospecto, InformacionUsuarioLogueado.IdUsuario, null, null);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index")]
        public ActionResult ObtenerCatalogos(string catalogo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NProspecto().ObtenerDetallesCatalogo(catalogo, 1, InformacionUsuarioLogueado.IdEmpresa);
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
        public ActionResult FileUpload(HttpPostedFileBase file)
        {
            if (file != null)
            {
                string pic = System.IO.Path.GetFileName(file.FileName);
                string path = System.IO.Path.Combine(Server.MapPath("~/Images"), pic);

                file.SaveAs(path);

                using (MemoryStream ms = new MemoryStream())
                {
                    file.InputStream.CopyTo(ms);
                    byte[] array = ms.GetBuffer();
                }
            }

            return View();
        }
        #endregion
    }
}