using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Negocio
{
    public class NDocumentos
    {

        #region Cliente
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idCliente"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public List<EDocumentos> ObtenerDocumentosCliente(int idCliente, int idEmpresa)
        {
            return new DDocumento().buscarDocumentosCliente(idCliente, idEmpresa);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="docs"></param>
        /// <param name="archivo"></param>
        /// <param name="ruta"></param>
        /// <returns></returns>
        public int InsertarDocumentoCliente(EDocumentos docs, byte[] archivo, string ruta)
        {
            try
            {
                if (archivo != null)
                {
                    if (!Directory.Exists(ruta))
                        System.IO.Directory.CreateDirectory(ruta);

                    EliminarArchivoAnterior(ruta, docs.Url);

                    File.WriteAllBytes(ruta + docs.Url, archivo);
                }

                return new DDocumento().insertarDocumentoCliente(docs);
            }
            finally { }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public int EliminarDocumentoCliente(int id, int idEmpresa)
        {
            try
            {
                return new DDocumento().elimianrDocumentoCliente(id);
            }
            finally { }
        }
        #endregion

        #region Prospecto
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idProspecto"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public List<EDocumentos> ObtenerDocumentosProspecto(int idProspecto, int idEmpresa)
        {
            return new DDocumento().buscarDocumentosProspecto(idProspecto, idEmpresa);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="docs"></param>
        /// <param name="archivo"></param>
        /// <param name="ruta"></param>
        /// <returns></returns>
        public int InsertarDocumentoProspecto(EDocumentos docs, byte[] archivo, string ruta)
        {
            try
            {
                if (archivo != null)
                {
                    if (!Directory.Exists(ruta))
                        System.IO.Directory.CreateDirectory(ruta);

                    EliminarArchivoAnterior(ruta, docs.Url);

                    File.WriteAllBytes(ruta + docs.Url, archivo);
                }

                return new DDocumento().insertarDocumentoProspecto(docs);
            }
            finally
            {
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public int EliminarDocumentoProspecto(int id, int idEmpresa)
        {
            try
            {
                return new DDocumento().elimianrDocumentoProspecto(id);
            }
            finally { }
        }

        private void EliminarArchivoAnterior(string ruta, string nombreArchivo)
        {
            DirectoryInfo directoryInfo = null;
            FileInfo[] archivos = null;
            try
            {
                directoryInfo = new DirectoryInfo(ruta);
                archivos = directoryInfo.GetFiles("*.*", SearchOption.AllDirectories);
                if (archivos != null && archivos.Length > 0)
                {
                    foreach (FileInfo file in archivos)
                    {
                        if (file.Name.ToUpper().Split('.')[0].Equals(nombreArchivo.ToUpper().Split('.')[0]))
                        {
                            File.Delete(ruta + file.Name);
                        }
                    }
                }
            }
            finally
            {
                directoryInfo = null;
                archivos = null;
            }
        }
        #endregion
    }
}
