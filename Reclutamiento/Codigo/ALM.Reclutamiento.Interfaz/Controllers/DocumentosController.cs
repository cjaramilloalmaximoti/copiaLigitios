using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web;
using ALM.Reclutamiento.Utilerias;
using System.IO;
using DocumentFormat.OpenXml.InkML;

namespace ALM.Empresa.Interfaz.Controllers
{
    public class DocumentosController : Controller
    {

        #region Documentos

        [HttpPost]
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Cliente_Index")]
        public ActionResult insertarDocSCliente(EDocumentos d, HttpPostedFileBase file, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {

                BinaryReader b = null;

                dataRespuesta = new Respuesta();
                d.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                d.IdUsuarioCreacion = InformacionUsuarioLogueado.IdUsuario;
                d.Estatus = Convert.ToBoolean(1);
                d.NombreOriginal = Path.GetFileName(file.FileName);
           

                double unix = (double)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                if (file != null)
                    d.Url = d.IdCliente + "-" + d.IdDocumento + "-" + Math.Truncate(unix) + Path.GetExtension(file.FileName);
                else
                    d.Url = "";

                b = new BinaryReader(file.InputStream);

                var lista = new NDocumentos().InsertarDocumentoCliente(d, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Documentos\Empresa" + InformacionUsuarioLogueado.IdEmpresa + @"\" + origen + @"\");

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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio4, Accion = "Cliente_Index")]
        public ActionResult EliminarDocsCliente(string Id)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NDocumentos().EliminarDocumentoCliente(Convert.ToInt32(Id), InformacionUsuarioLogueado.IdEmpresa);
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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Cliente_Index")]
        public ActionResult obtenerDocsCliente(string IdCliente)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NDocumentos().ObtenerDocumentosCliente(Convert.ToInt32(IdCliente), InformacionUsuarioLogueado.IdEmpresa);
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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio2, Accion = "Cliente_Index")]
        public ActionResult insertarDocsProspecto(EDocumentos d, HttpPostedFileBase file, string origen)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                string ruta = "";
                BinaryReader b = null;

                dataRespuesta = new Respuesta();
                d.IdEmpresa = InformacionUsuarioLogueado.IdEmpresa;
                d.IdUsuarioCreacion = InformacionUsuarioLogueado.IdUsuario;
                d.Estatus = Convert.ToBoolean(1);
                d.NombreOriginal = Path.GetFileName(file.FileName);
                double unix = (double)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                if (file != null)
                    d.Url = d.IdProspecto + "-" + d.IdDocumento + "-" + Math.Truncate(unix) + Path.GetExtension(file.FileName); 
                else
                    d.Url = "";

                b = new BinaryReader(file.InputStream);

                var lista = new NDocumentos().InsertarDocumentoProspecto(d, b.ReadBytes((int)file.ContentLength), EClaseEstatica.RutaPublicado + @"Documentos\Empresa" + InformacionUsuarioLogueado.IdEmpresa + @"\" + origen + @"\");

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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio3, Accion = "Cliente_Index")]
        public ActionResult EliminarDocsProspecto(string Id)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NDocumentos().EliminarDocumentoProspecto(Convert.ToInt32(Id), InformacionUsuarioLogueado.IdEmpresa);
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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Cliente_Index")]
        public ActionResult obtenerDocsProspecto(string IdProspecto)
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();

                var lista = new NDocumentos().ObtenerDocumentosProspecto(Convert.ToInt32(IdProspecto), InformacionUsuarioLogueado.IdEmpresa);
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
        //[CustomAuthorize(AccessLevel = InformacionUsuarioLogueado.Privilegio.Privilegio1, Accion = "Cliente_Index")]
        public ActionResult ObtenerDocumentos()
        {
            Respuesta dataRespuesta = new Respuesta();
            try
            {
                dataRespuesta = new Respuesta();
                dataRespuesta.Codigo = "";

                var lista = new NProspecto().ObtenerDetallesCatalogo("Documentos", 1, InformacionUsuarioLogueado.IdEmpresa);
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

        public ActionResult Download(string filePath, string fileName)
        {
            string fullName = Path.Combine(EClaseEstatica.RutaPublicado, filePath, fileName);

            byte[] fileBytes = GetFile(fullName);
            return File(fileBytes, "application/pdf", fileName);
        }
    [HttpGet]
    public ActionResult DownloadFile(string origen, string fileName, string nombreOriginal)
        {
            string contentType = string.Empty;
            string filePath = "Documentos/Empresa" + InformacionUsuarioLogueado.IdEmpresa + @"/" + origen + "/";
            string fullName = Path.Combine(EClaseEstatica.RutaPublicado, filePath, fileName);

      var cd = new System.Net.Mime.ContentDisposition
      {
        // for example foo.bak
        FileName = fileName,

        // always prompt the user for downloading, set to true if you want 
        // the browser to try to show the file inline
        Inline = true,
      };

      //Response.AppendHeader("Content-Disposition", cd.ToString());
      //Response.Headers.Add("Content-Disposition", "attachment; filename=\"file.bin\"");

      if (System.IO.File.Exists(fullName))
            {
        byte[] data = GetFile(fullName);

        Constante._mappings.TryGetValue("." + fileName.Split('.')[1].ToLower().Trim(), out contentType);

        return File(data, contentType);

             /*   if ()
                {
                    return File(GetFile(fullName), contentType, !string.IsNullOrEmpty(nombreOriginal) ? nombreOriginal : fileName);
                }
                else
                {
                    return File(GetFile(fullName), "application/pdf", !string.IsNullOrEmpty(nombreOriginal) ? nombreOriginal : fileName);
                }*/
            }
            else
            {
                return null;
            }
        }

        byte[] GetFile(string s)
        {
            System.IO.FileStream fs = System.IO.File.OpenRead(s);
            byte[] data = new byte[fs.Length];
            int br = fs.Read(data, 0, data.Length);
            if (br != fs.Length)
                throw new System.IO.IOException(s);
            return data;
        }

        #endregion
    }
}