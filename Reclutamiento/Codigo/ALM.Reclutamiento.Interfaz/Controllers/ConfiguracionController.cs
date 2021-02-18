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
    public class ConfiguracionController : Controller
    {
        #region Parámetros (métodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Parametro_Index")]
        public ActionResult Parametro_Index()
        {
            return View("Parametro_Index");
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Parametro_Index")]
        public ActionResult Buscar(EParametro parametro)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                var lista = new NParametro().Listar(parametro);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";


                //return Json(new { Lista = lista }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                //return View("GridExpedientesPartial", lstresult);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Parametro_Index")]
        public ActionResult ActualizarParametro(EParametro parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                new NParametro().Actualizar(parametro, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

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

        #endregion

        #region Parámetros Empresa (métodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Parametro_S_Index")]
        public ActionResult Parametro_S_Index()
        {
            if (InformacionUsuarioLogueado.EsSuperAdministrador)
            {
                return View("Parametro_S_Index");
            }
            else
            {
                return RedirectToAction("AccesoDenegado", "Inicio");
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Parametro_S_Index")]
        public ActionResult ListarParametroEmpresa(EParametro parametro)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {

                    parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                    var lista = new NParametro().ListarParametroEmpresa(parametro);
                    dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                    dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                    dataRespuesta.Codigo = "OK";
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Sin autorización para ejecutar esta acción";
                    dataRespuesta.Codigo = "ERROR";
                }

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Parametro_S_Index")]
        public ActionResult ActualizarParametroEmpresa(EParametro parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {
                    parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                    new NParametro().ActualizarParametroEmpresa(parametro, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

                    dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                    dataRespuesta.Codigo = "OK";

                    dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Sin autorización para ejecutar esta acción";
                    dataRespuesta.Codigo = "ERROR";
                }
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

        #endregion

        #region Roles (métodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Rol_Index")]
        public ActionResult Rol_Index()
        {
            return View("Rol_Index");
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Rol_Index")]
        public ActionResult BuscarRol(ERol rol)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                rol.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                var lista = new NRol().Listar(rol);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Rol_Index")]
        public ActionResult InsertarRol(string nombreRol)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                int idInsertado = new NRol().Insertar(nombreRol, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion, InformacionUsuarioLogueado.IdEmpresa);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Rol_Index")]
        public ActionResult ActualizarRol(ERol rol)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                rol.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                new NRol().Actualizar(rol, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Rol_Index")]
        public ActionResult EliminarRol(ERol rol)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                rol.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                if (new NRol().Eliminar(rol, InformacionUsuarioLogueado.IdEmpresa) == 0)
                {
                    dataRespuesta.MensajeUsuario = "Registro eliminado exitosamente";
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Se deshabilito el rol exitosamente";
                }
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Rol_Index")]
        public ActionResult ConsultarPrivRol(string idRol, string nombreForma)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NForma().ObtenerListaFormasPorRol(int.Parse(idRol), nombreForma, InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Rol_Index")]
        public ActionResult ConsultarFormaPermiso(string idForma)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NFormaPermiso().Obtener(int.Parse(idForma), InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Rol_Index")]
        public ActionResult InsertarFormaRol(EFormaRol parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                int idInsertado = new NFormaRol().Insertar(parametro);

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
        #endregion

        #region Usuario (métodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Usuario_Index")]
        public ActionResult Usuario_Index()
        {
            return View("Usuario_Index");
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Usuario_Index")]
        public ActionResult ObtenerUsuarios(string nombreCompleto, int activo)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NUsuario().ObtenerUsuarios(nombreCompleto, activo, InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Usuario_Index")]
        public ActionResult InsertarUsuario(EUsuario usuario, List<ERol> lstRoles)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                usuario.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                if (string.IsNullOrEmpty(usuario.Login) && string.IsNullOrEmpty(usuario.Contrasenia))
                {
                    dataRespuesta.MensajeUsuario = "Los Campos de Usuario y Contraseña son Obligatorios";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

                }
                if (usuario.Contrasenia.Length <= Constante.TamanioMinContrasenia && usuario.Contrasenia.Length >= Constante.TamanioMaxContrasenia)
                {

                    dataRespuesta.MensajeUsuario = "La contraseña debe tener mínimo 8 Caracteres";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    Regex regx = new Regex(Constante.RegularExpretionPassword);
                    if (!regx.IsMatch(usuario.Contrasenia))
                    {
                        dataRespuesta.MensajeUsuario = "La contraseña debe tener como minimo, una mayuscula, una minuscula un caracter y un número";
                        dataRespuesta.Codigo = "VAL";
                        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                    }
                }

                int idInsertado = new NUsuario().InsertarUsuario(usuario, lstRoles, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Usuario_Index")]
        public ActionResult ActualizarUsuario(EUsuario usuario, List<ERol> lstRoles)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                usuario.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                if (string.IsNullOrEmpty(usuario.Login) && string.IsNullOrEmpty(usuario.Contrasenia))
                {
                    dataRespuesta.MensajeUsuario = "Los Campos de Usuario y Contraseña son Obligatorios";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

                }
                if (usuario.Contrasenia.Length <= Constante.TamanioMinContrasenia && usuario.Contrasenia.Length >= Constante.TamanioMaxContrasenia)
                {

                    dataRespuesta.MensajeUsuario = "La contraseña debe tener mínimo 8 Caracteres";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    Regex regx = new Regex(Constante.RegularExpretionPassword);
                    if (!regx.IsMatch(usuario.Contrasenia))
                    {
                        dataRespuesta.MensajeUsuario = "La contraseña debe tener como minimo, una mayuscula, una minuscula un caracter y un número";
                        dataRespuesta.Codigo = "VAL";
                        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                    }
                }

                new NUsuario().ActualizarUsuario(usuario, lstRoles, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "Usuario_Index")]
        public ActionResult EliminarUsuario(int idUsuario)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NUsuario().EliminarUsuario(idUsuario, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.MensajeUsuario = "Registro eliminado exitosamente";
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Usuario_Index")]
        public ActionResult ObtenerRolUsuario(string idUsuario)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NRolUsuario().ObtenerRolUsuario(int.Parse(idUsuario), InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Usuario_Index")]
        public ActionResult InsertarRolUsuario(int idUsuario, int idRol)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                new NRolUsuario().InsertarRolUsuario(idUsuario, idRol, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion, InformacionUsuarioLogueado.IdEmpresa);
                dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = 0, msgResultado = "" }, JsonRequestBehavior.AllowGet);

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "Usuario_Index")]
        public ActionResult EliminarRolUsuario(int idUsuario, int idRol)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NRolUsuario().EliminarRolUsuario(idUsuario, idRol, InformacionUsuarioLogueado.IdEmpresa);

                dataRespuesta.MensajeUsuario = "Registro eliminado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { Info = 0, msgResultado = "" }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar eliminar el registro";

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

        #endregion

        #region Forma Permiso

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "FormaPermiso_Index")]
        public ActionResult FormaPermiso_Index()
        {
            return View("FormaPermiso_Index", new EFormaPermiso());
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "FormaPermiso_Index")]
        public ActionResult ObtenerFormas()
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NForma().ObtenerListaFormas(InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "FormaPermiso_Index")]
        public ActionResult ObtenerFormaPermisos(int idForma)
        {
            Respuesta dataRespuesta = new Respuesta();

            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NFormaPermiso().Obtener(idForma, InformacionUsuarioLogueado.IdEmpresa);
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "FormaPermiso_Index")]
        public ActionResult ActualizarFormaPermisos(List<EFormaPermiso> listformaPermiso)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";

            try
            {
                new NFormaPermiso().Actualizar(listformaPermiso, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.IdEmpresa);

                dataRespuesta.MensajeUsuario = "Registro actualizado exitosamente";

                dataRespuesta.Codigo = "OK";

                dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar actualizar el registro";

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

        #endregion

        #region Empresa

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "FormaPermiso_Index")]
        public ActionResult Empresa_Index()
        {
            if (InformacionUsuarioLogueado.EsSuperAdministrador)
            {
                return View("Empresa_Index", null);
            }
            else
            {
                return RedirectToAction("AccesoDenegado", "Inicio");
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "FormaPermiso_Index")]
        public ActionResult ObtenerEmpresa()
        {
            Respuesta dataRespuesta = new Respuesta();
            EEmpresa empresa = null;
            Utilerias utileria = null;
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {
                    empresa = (EEmpresa)EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(InformacionUsuarioLogueado.IdEmpresa)).Clone();

                    utileria = new Utilerias();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                    empresa.Contrasenia = utileria.Descifrar(empresa.Contrasenia);

                    dataRespuesta.RespuestaInformacion = Json(new { Info = empresa }, JsonRequestBehavior.AllowGet);
                    dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                    dataRespuesta.Codigo = "OK";

                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Sin autorización para ejecutar esta acción";
                    dataRespuesta.Codigo = "ERROR";
                }

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
                utileria = null;
                empresa = null;
                dataRespuesta = null;
            }
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "FormaPermiso_Index")]
        public ActionResult RegistrarEmpresa(string pDominio, string pRFC, string pAdministrador, string pContrasenia, string pNombreComercial, string pEmail,
                string pNombreRepresentante, string pEmailRepresentante, string pTelefonoRepresentante, string pObservaciones, string pNombreOtroContacto,
                string pEmailOtroContacto, string pTelefonoOtroContacto, int pEsActivo, int pEsVigente, int pNumeroUsuarios, 
                int pNumeroClientes, int pNumeroRegistros, HttpPostedFileBase file)
        {
                       
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            BinaryReader b = null;
            EEmpresa pEmpresa = null;
            Utilerias utileria = null;

            try
            {
                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {
                    utileria = new Utilerias();
                    pEmpresa = new EEmpresa();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);
                    pEmpresa.IdEmpresa = 0; // (new NEmpresa().ObtenerIdEmpresaSiguiente()[0].IdEmpresa) + 1;
                    pEmpresa.Dominio =  pDominio ; //pEmpresa.Dominio = "@" + pDominio + ".com";
                    pEmpresa.RFC = pRFC;
                    pEmpresa.ProductKey = utileria.Cifrar(pEmpresa.Dominio + "|" + pRFC);
                    pEmpresa.Administrador = pAdministrador;
                    pEmpresa.Contrasenia = utileria.Cifrar(pContrasenia);
                    pEmpresa.NombreComercial = pNombreComercial;
                    pEmpresa.Email = pEmail;
                    pEmpresa.Estatus = -1;
                    pEmpresa.NombreRepresentante = pNombreRepresentante;
                    pEmpresa.EmailRepresentante = pEmailRepresentante;
                    pEmpresa.TelefonoRepresentante = pTelefonoRepresentante;
                    pEmpresa.Observaciones = pObservaciones;
                    pEmpresa.NombreOtroContacto = pNombreOtroContacto;
                    pEmpresa.EmailOtroContacto = pEmailOtroContacto;
                    pEmpresa.TelefonoOtroContacto = pTelefonoOtroContacto;
                    pEmpresa.EsActivo = pEsActivo;
                    pEmpresa.EsVigente = pEsVigente;
                    pEmpresa.NumeroUsuarios = pNumeroUsuarios;
                    pEmpresa.NumeroClientes = pNumeroClientes;
                    pEmpresa.NumeroRegistros = pNumeroRegistros;
                    
                    List<EEmpresa> ListaEmpresas = new NEmpresa().ObtenerEmpresasID(pEmpresa);

                    if(ListaEmpresas != null && ListaEmpresas.Count > 0)
                    {
                        dataRespuesta.MensajeUsuario = "Error al guardar";
                        EErrorDetalle errorObj = new EErrorDetalle();
                        errorObj.Mensaje = "La empresa que desea registrar ya existe";
                        errorObj.Traza = "No se puede volver a registrar una empresa existente";
                        dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);
                        dataRespuesta.Codigo = "ERR";
                    }
                    else
                    {
                        if (file != null)
                        {
                            pEmpresa.Logo = Path.GetFileName(file.FileName);
                            b = new BinaryReader(file.InputStream);
                            new NEmpresa().RegistrarEmpresa(pEmpresa, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Imagenes\");
                        }
                        else
                        {
                            new NEmpresa().RegistrarEmpresa(pEmpresa, null, null);
                        }


                        dataRespuesta.MensajeUsuario = "Empresa registrada exitosamente.";

                        dataRespuesta.Codigo = "OK";

                        dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);
                    }

                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Sin autorización para ejecutar esta acción";
                    dataRespuesta.Codigo = "ERROR";
                }

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar actualizar el registro";

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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "FormaPermiso_Index")]

        public ActionResult ConsultarEmpresas(string pNombreEmpresa, int pEstatus )
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            EEmpresa pEmpresa = new EEmpresa();
            pEmpresa.NombreComercial = pNombreEmpresa;
            pEmpresa.Estatus = pEstatus;
            List<EEmpresa> ListaEmpresas = new NEmpresa().ObtenerEmpresas(pEmpresa);
            dataRespuesta.RespuestaInformacion = Json(new { Info = ListaEmpresas }, JsonRequestBehavior.AllowGet);
            dataRespuesta.Codigo = "OK";
            return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "FormaPermiso_Index")]
        public ActionResult ActualizarEmpresa(string pDominio, string pProductKey, string pAdministrador, string pContrasenia, string pNombreComercial, string pRFC,string pNombreAnteriorEmpresa, string pLogo, string pEmail, int pEstatus,
                                        string pNombreRepresentante, string pEmailRepresentante, string pTelefonoRepresentante, string pObservaciones, string pNombreOtroContacto,
                                        string pEmailOtroContacto, string pTelefonoOtroContacto, int pEsActivo, int pEsVigente, int pNumeroUsuarios,
                                        int pNumeroClientes, int pNumeroRegistros, HttpPostedFileBase file)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            BinaryReader b = null;
            EEmpresa pEmpresa = null;
            try
            {
                if (InformacionUsuarioLogueado.EsSuperAdministrador)
                {
                    Utilerias utileria = new Utilerias();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);
                    pEmpresa = new EEmpresa();
                    pEmpresa.Dominio = pDominio;
                    pEmpresa.ProductKey = utileria.Cifrar(pDominio + "|" + pRFC);
                    pEmpresa.Administrador = pAdministrador;
                    pEmpresa.Contrasenia = utileria.Cifrar(pContrasenia); ;
                    pEmpresa.NombreComercial = pNombreAnteriorEmpresa;

                    if (pLogo==null)
                        pEmpresa.Logo = "";
                    else
                        pEmpresa.Logo = pLogo;
                    pEmpresa.Estatus = pEstatus;
                    pEmpresa.RFC = pRFC;
                    pEmpresa.Email = pEmail;
                    pEmpresa.NombreRepresentante = pNombreRepresentante;
                    pEmpresa.EmailRepresentante = pEmailRepresentante;
                    pEmpresa.TelefonoRepresentante = pTelefonoRepresentante;
                    pEmpresa.Observaciones = pObservaciones;
                    pEmpresa.NombreOtroContacto = pNombreOtroContacto;
                    pEmpresa.EmailOtroContacto = pEmailOtroContacto;
                    pEmpresa.TelefonoOtroContacto = pTelefonoOtroContacto;
                    pEmpresa.EsActivo = pEsActivo;
                    pEmpresa.EsVigente = pEsVigente;
                    pEmpresa.NumeroUsuarios = pNumeroUsuarios;
                    pEmpresa.NumeroClientes = pNumeroClientes;
                    pEmpresa.NumeroRegistros = pNumeroRegistros;

                    List<EEmpresa> ListaEmpresas = new NEmpresa().ObtenerEmpresasID(pEmpresa);

                    if(ListaEmpresas != null && ListaEmpresas.Count > 0)
                    {   
                        pEmpresa.NombreComercial = pNombreComercial;
                        pEmpresa.IdEmpresa = ListaEmpresas[0].IdEmpresa;
                        if (file != null)
                        {
                           
                            pEmpresa.Logo = Path.GetFileName(file.FileName);
                            b = new BinaryReader(file.InputStream);
                            new NEmpresa().ActualizarEmpresa(pEmpresa, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Imagenes\");
                        }
                        else
                        {
                            new NEmpresa().ActualizarEmpresa(pEmpresa, null, null);
                        }

                        dataRespuesta.MensajeUsuario = "Empresa actualizada correctamente";
                        dataRespuesta.Codigo = "OK";
                        dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        dataRespuesta.MensajeUsuario = "Error al buscar";
                        EErrorDetalle errorObj = new EErrorDetalle();
                        errorObj.Mensaje = "La empresa que desea buscar no pudo ser encontrada";
                        errorObj.Traza = "Empresa no encontrada";
                        dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);
                        dataRespuesta.Codigo = "ERR";
                    }

                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Sin autorización para ejecutar esta acción";
                    dataRespuesta.Codigo = "ERROR";
                }

                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar actualizar el registro";

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

        #endregion

        #region Catalogo (métodos, funciones, eventos)

        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Catalogo_Index")]
        public ActionResult Catalogo_Index(int id)
        {
            ViewData["TituloCatalogo"] = InformacionUsuarioLogueado.ObtenerNombreCatalogo(id);
            TempData["idTipoCatalogo"] = id;
            TempData.Keep("idTipoCatalogo");
            return View("Catalogo_Index");
        }

        [HttpPost]
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Catalogo_Index")]
        public ActionResult InsertarCatalogo(ECatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                int idInsertado = new NCatalogo().InsertarCatalogo(parametro, InformacionUsuarioLogueado.IdUsuario);

                if(idInsertado == -1)
                {
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    dataRespuesta.Codigo = "ERR";
                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = "La clave que se acaba de ingresar ya existe en los registros";
                    errorObj.Traza = "ERR";
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                    dataRespuesta.Codigo = "OK"; 
                    
                    dataRespuesta.RespuestaInformacion = Json(new { Info = idInsertado, msgResultado = "" }, JsonRequestBehavior.AllowGet);

                }


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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Catalogo_Index")]
        public ActionResult ActualizarCatalogo(ECatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            dataRespuesta.Codigo = "";
            try
            {
                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                int respuesta = new NCatalogo().Actualizar(parametro, InformacionUsuarioLogueado.IdUsuario);

                if(respuesta == -1)
                {
                    dataRespuesta.MensajeUsuario = "Ocurrio un error al intentar guardar el registro";

                    dataRespuesta.Codigo = "ERR";
                    EErrorDetalle errorObj = new EErrorDetalle();
                    errorObj.Mensaje = "La clave que se acaba de ingresar ya existe en los registros";
                    errorObj.Traza = "ERR";
                    dataRespuesta.RespuestaInformacion = Json(new { Info = errorObj }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    dataRespuesta.MensajeUsuario = "Registro guardado exitosamente";

                    dataRespuesta.Codigo = "OK";

                    dataRespuesta.RespuestaInformacion = Json(new { statusResultado = "OK", msgResultado = "" }, JsonRequestBehavior.AllowGet);


                }
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
        [CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Catalogo_Index")]
        public ActionResult BuscarCatalogo(ECatalogo parametro)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                parametro.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;

                var lista = new NCatalogo().Listar(parametro);
                dataRespuesta.RespuestaInformacion = Json(new { Info = lista }, JsonRequestBehavior.AllowGet);
                dataRespuesta.MensajeUsuario = "Busqueda satisfactoria";

                dataRespuesta.Codigo = "OK";

                //return Json(new { Lista = lista }, JsonRequestBehavior.AllowGet);
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                //return View("GridExpedientesPartial", lstresult);
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