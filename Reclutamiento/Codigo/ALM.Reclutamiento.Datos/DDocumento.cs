using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DDocumento : Conexion
    {
        /// <summary>
        /// Obtener los documentos por Cliente
        /// </summary>
        /// <param name="IdCliente">Id del Cliente a Buscar</param>
        /// <param name="IdEmpresa">Id de la Empresa a Buscar</param>
        /// <returns>Lista de Documentos del CLietne</returns>
        public List<EDocumentos> buscarDocumentosCliente(int IdCliente, int IdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtDocsCliente");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", IdCliente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EDocumentos>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agregar un Documento al Cliente
        /// </summary>
        /// <param name="docs">Datos del Documento a Agregar</param>
        /// <returns>Valor del Último registro Agregado</returns>
        public int insertarDocumentoCliente(EDocumentos docs)
        {
            int idCliente = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsDocsCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", docs.IdCliente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdDocumento", docs.IdDocumento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", docs.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pUrl", docs.Url));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", docs.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", docs.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreOriginal", docs.NombreOriginal));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", docs.IdUsuarioCreacion));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idCliente = int.Parse(dt.Rows[0]["Id"].ToString());
                }

                return idCliente;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Eliminar Documento del Cliente
        /// </summary>
        /// <param name="id">Id del Documento a Eliminar</param>
        /// <returns>Valor del Ultimo Registro Eliminado</returns>
        public int elimianrDocumentoCliente(int id)
        {
            int idCliente = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliDocsCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pId", id));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    //idCliente = int.Parse(dt.Rows[0]["IdCliente"].ToString());
                    idCliente = 1;
                }

                return idCliente;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Obtener documetnos por Prospecto
        /// </summary>
        /// <param name="IdProspecto">Id Prospecto</param>
        /// <param name="IdEmpresa">Id Empresa</param>
        /// <returns>Lista de Documentos del Prospecto</returns>
        public List<EDocumentos> buscarDocumentosProspecto(int IdProspecto, int IdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtDocsProspecto");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EDocumentos>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agregar Documetnos al Prospecto
        /// </summary>
        /// <param name="docs">Datos del Documento a Agregar</param>
        /// <returns>Valor del Ultimo registro Agregado</returns>
        public int insertarDocumentoProspecto(EDocumentos docs)
        {
            int idProspecto = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsDocsProspecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", docs.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdDocumento", docs.IdDocumento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", docs.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pUrl", docs.Url));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", docs.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", docs.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreOriginal", docs.NombreOriginal));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", docs.IdUsuarioCreacion));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idProspecto = int.Parse(dt.Rows[0]["Id"].ToString());
                }

                return idProspecto;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Eliminar Documento del Prospecto
        /// </summary>
        /// <param name="id">Id del Documento a Eliminar</param>
        /// <returns>Valor del Ultimo Documento Eliminado</returns>
        public int elimianrDocumentoProspecto(int id)
        {
            int idCliente = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliDocsProspecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pId", id));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    //idCliente = int.Parse(dt.Rows[0]["IdCliente"].ToString());
                    idCliente = 1;
                }

                return idCliente;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}
