using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Text.RegularExpressions;
using System.Web.Mvc;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class UsuarioController : Controller
    {
        public ActionResult CambiarContrasenia()
        {
            try
            {
                return View("CambiarContrasenia", new EUsuario());
            }
            catch (Exception ex)
            {
                var x = "algo fallo" + ex.Message;
                return View("CambiarContrasenia");
            }
        }

        [HttpPost]
        public ActionResult ActualizarContraseniaUserLog(string contrasenia)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";
                var result = string.Empty;
                if (string.IsNullOrEmpty(contrasenia))
                {
                    dataRespuesta.MensajeUsuario = "El Campo Contraseña es Obligatorio";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);

                }
                if (contrasenia.Length <= Constante.TamanioMinContrasenia && contrasenia.Length >= Constante.TamanioMaxContrasenia)
                {

                    dataRespuesta.MensajeUsuario = "La contraseña debe tener mínimo 8 Caracteres";
                    dataRespuesta.Codigo = "VAL";
                    return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    Regex regx = new Regex(Constante.RegularExpretionPassword);
                    if (!regx.IsMatch(contrasenia))
                    {
                        dataRespuesta.MensajeUsuario = "La contraseña debe tener como minimo, una mayuscula, una minuscula un caracter y un número";
                        dataRespuesta.Codigo = "VAL";
                        return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
                    }
                }


                new NUsuario().ActualizarContraseniaUsuario(new EUsuario() { Contrasenia = contrasenia, IdUsuario = InformacionUsuarioLogueado.IdUsuario, IdEmpresa = InformacionUsuarioLogueado.IdEmpresa }, InformacionUsuarioLogueado.IdUsuario, InformacionUsuarioLogueado.OrigenOperacion);
                dataRespuesta.MensajeUsuario = "Contraseña del Usuario se actualizo con Exito";
                dataRespuesta.Codigo = "OK";
                return Json(new { Respuesta = dataRespuesta }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                dataRespuesta.Codigo = "ERR";
                dataRespuesta.MensajeUsuario = "Error al actualizar contraseña del usuario";
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