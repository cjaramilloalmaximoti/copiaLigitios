using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DCliente : Conexion
    {
        /// <summary>
        /// Obtener una lista de Clientes
        /// </summary>
        /// <param name="razonSocial">Razon Social</param>
        /// <param name="activo">Estatus Activo</param>
        /// <param name="idEmpresa">Id de la Empresa</param>
        /// <returns>Una lista de los LCientes encontrados</returns>
        public List<ECliente> ObtenerClientes(string razonSocial, int activo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClientes");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", razonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECliente>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Obtener Clientes por su Id
        /// </summary>
        /// <param name="IdCliente">Id del Cliente a buscar</param>
        /// <returns>Una lista de los datos del CLiente encontrado</returns>
        public List<ECliente> ObtenerClienteId(int IdCliente)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClienteId");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", IdCliente));

                return accesoDatos.CargarTabla().DataTableMapToList<ECliente>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Obtener los documentos del la Empresa
        /// </summary>
        /// <param name="activo">Estatus como Activo</param>
        /// <param name="idEmpresa">Id de la Empresa</param>
        /// <returns>Una lista de Documentos</returns>
        public List<EDocumentos> ObtenerDocumentos(int activo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClientesDocumentos");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EDocumentos>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Insertar Cliente
        /// </summary>
        /// <param name="cliente">Datos del CLiente</param>
        /// <param name="idIsuarioLog">Usuario Logueado</param>
        /// <returns>Retorna el Id del ultimo LCiente insertado</returns>
        public int InsertarCliente(ECliente cliente, int idIsuarioLog)
        {
            int idCliente = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", cliente.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", cliente.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", cliente.RazonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", cliente.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveColonia", cliente.Clave_Colonia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCP", cliente.CP));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", cliente.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Nombre", cliente.Contacto_Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresaCorreo", cliente.EmpresaCorreo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresaTelefono", cliente.EmpresaTelefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", cliente.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", cliente.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", cliente.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", cliente.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCalle", cliente.Calle));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idCliente = int.Parse(dt.Rows[0]["IdCliente"].ToString());
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
        /// Actualizar datos del Cliente
        /// </summary>
        /// <param name="cliente">Datos del Cliente</param>
        /// <param name="idIsuarioLog">Usuario Logueado</param>
        public void ActualizarCliente(ECliente cliente, int idIsuarioLog)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", cliente.IdCliente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", cliente.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", cliente.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", cliente.RazonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", cliente.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveColonia", cliente.Clave_Colonia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCP", cliente.CP));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", cliente.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Nombre", cliente.Contacto_Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresaCorreo", cliente.EmpresaCorreo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresaTelefono", cliente.EmpresaTelefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", cliente.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", cliente.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", cliente.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", cliente.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCalle", cliente.Calle));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Buscar el total de Clientes activos
        /// </summary>
        /// <param name="idEmpresa">id de la empresa</param>
        /// <param name="idCliente">Id del LCiente</param>
        /// <returns>uN entrero con el total de los CLientes Activos encontrados</returns>
        public int CuantosClientesActivos(int idEmpresa, int idCliente)
        {
            List<ECliente> lstTemp = null;
            try
            {
                lstTemp = ObtenerClientes(string.Empty, 1, idEmpresa);

                if (lstTemp != null && lstTemp.Count > 0)
                {
                    return lstTemp.FindAll(x => !x.IdCliente.Equals(idCliente)).Count;
                }
                return 0;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}