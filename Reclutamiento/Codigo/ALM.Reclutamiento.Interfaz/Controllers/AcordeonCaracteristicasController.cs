using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class AcordeonCaracteristicasController : Controller
    {
        [HttpPost]
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult ObtenerCategorias()
        {
            Respuesta dataRespuesta = new Respuesta();
            ECategoria param = null;
            List<ESelect2Json> data = null;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                param = new ECategoria();
                param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                param.Nombre = null;
                param.Estatus = 1;

                var lista = new NCategoria().ObtenerCategorias(param);
                data = (from cartera in lista.OrderBy(x=> x.Nombre).ToList()
                        select new ESelect2Json()
                        {
                            id = cartera.IdCategoria.ToString(),
                            text = cartera.Nombre
                        }).ToList<ESelect2Json>();
                data.Add(new ESelect2Json() { id = "0", text = "Todas" });

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
                param = null;
            }
        }

        [HttpPost]
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult ObtenerListadoControlesDinamicos(string idsCategoria, int idOrigen, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            EProspectoCaracteristica param = null;
            List<EProspectoCaracteristica> lstListado = null;
            try
            {

                if (("," + idsCategoria + ",").Contains(",0,"))
                {
                    idsCategoria = null;
                }

                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (origen == "Prospecto")
                {
                    param = new EProspectoCaracteristica();
                    param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                    param.IdProspecto = idOrigen;
                    param.IdsCategorias = idsCategoria;

                    lstListado = new NProspectoCaracteristica().ObtenerListadoControlesDinamicos(param);
                }
                else
                    if (origen == "Vacante")
                    {
                        param = new EProspectoCaracteristica();
                        param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                        param.IdProspecto = idOrigen;
                        param.IdsCategorias = idsCategoria;

                        lstListado = new NProspectoCaracteristica().ObtenerListadoControlesDinamicosVacantes(param);
                    }
                dataRespuesta.RespuestaInformacion = Json(new { Info = lstListado }, JsonRequestBehavior.AllowGet);
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
                param = null;
            }
        }

        [HttpPost]
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult ObtenerCatalogoCombo(int idCaracteristicaParticular)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();


                List<ESelect2Json> data = (from catalogo in new NCatalogo().ObtCatalogoCtrlCaracteristica(idCaracteristicaParticular, InformacionUsuarioLogueado.IdEmpresa)
                                           select new ESelect2Json()
                                           {
                                               id = catalogo.IdReferencia,
                                               text = catalogo.Nombre
                                           }).ToList<ESelect2Json>();
                dataRespuesta.RespuestaInformacion = Json(new { Info = data }, JsonRequestBehavior.AllowGet);

                dataRespuesta.IdCaracteristicaParticular = idCaracteristicaParticular;
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
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult InsProspectoCaracteristica(List<EProspectoCaracteristica> listaControles, int idOrigen, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                if (origen == "Prospecto")
                {
                    foreach (EProspectoCaracteristica caracteristica in listaControles)
                    {
                        caracteristica.IdProspecto = idOrigen;
                    }
                    new NProspectoCaracteristica().InsProspectoCaracteristica(listaControles);
                }
                else
                    if (origen == "Vacante")
                    {
                        foreach (EProspectoCaracteristica caracteristica in listaControles)
                        {
                            caracteristica.IdProspecto = idOrigen;
                        }
                        new NProspectoCaracteristica().InsVacanteCaracteristica(listaControles);
                    }
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = "", msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult ObtCaracteristicasPorProspecto(int idOrigen, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            EProspectoCaracteristica param = null;
            List<EProspectoCaracteristica> lstListado = null;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (origen == "Prospecto")
                {
                    param = new EProspectoCaracteristica();
                    param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                    param.IdProspecto = idOrigen;

                    lstListado = new NProspectoCaracteristica().ObtCaracteristicasPorProspecto(param);
                }
                else
                    if (origen == "Vacante")
                    {
                        param = new EProspectoCaracteristica();
                        param.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                        param.IdProspecto = idOrigen;

                        lstListado = new NProspectoCaracteristica().ObtCaracteristicasPorVacante(param);
                    }
                dataRespuesta.RespuestaInformacion = Json(new { Info = lstListado }, JsonRequestBehavior.AllowGet);
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
                param = null;
            }
        }

        [HttpPost]
        [CustomAuthorizeSpecial(ControllerNameCustom = "Prospectos,Vacante", AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "Prospecto_Index,Vacante_Index")]
        public ActionResult EliProspectoCaracteristica(int IdProspectoCaracteristica, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (origen == "Prospecto")
                {
                    new NProspectoCaracteristica().EliProspectoCaracteristica(IdProspectoCaracteristica);
                }
                else
                    if (origen == "Vacante")
                    {
                        new NProspectoCaracteristica().EliVacanteCaracteristica(IdProspectoCaracteristica);
                    }
                dataRespuesta.RespuestaInformacion = Json(new { Info = "0" }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Registro eliminado exitosamente";

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