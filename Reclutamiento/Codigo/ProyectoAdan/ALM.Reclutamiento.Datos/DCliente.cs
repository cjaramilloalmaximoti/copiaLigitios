using System;
using System.Collections.Generic;
using ALM.Empresa.Entidades;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Empresa.AccesoDatos;

namespace ALM.Empresa.Datos {
    public class DCliente : Conexion {
        public List<ECliente> ObtenerClientes(string razonSocial, int activo, int idEmpresa) {
            try {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClientes");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", razonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECliente>();
            } finally {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECliente> ObtenerClientesCartera(string nombreComercial, int idEmpresa) {
            try {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClientesCartera");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", nombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECliente>();
            } finally {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECliente> ObtenerClientesCarteraTodos(string nombreComercial, int idEmpresa) {
            try {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtClientesCarteraTodos");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", nombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECliente>();
            } finally {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int InsertarCliente(ECliente usuario, int idIsuarioLog) {
            int idCliente = 0;
            DataTable dt = null;
            try {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", usuario.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", usuario.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", usuario.RazonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", usuario.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", usuario.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Nombre", usuario.Contacto_Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", usuario.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", usuario.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", usuario.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", usuario.Activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value) {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                } else {
                    idCliente = int.Parse(dt.Rows[0]["IdCliente"].ToString());
                }

                return idCliente;
            } finally {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ActualizarCliente(ECliente usuario, int idIsuarioLog) {
            DataTable dt = null;
            try {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActCliente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", usuario.IdCliente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", usuario.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", usuario.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRazonSocial", usuario.RazonSocial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", usuario.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", usuario.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Nombre", usuario.Contacto_Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", usuario.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", usuario.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", usuario.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", usuario.Activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value) {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
            } finally {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int CuantosClientesActivos(int idEmpresa, int idCliente) {
            List<ECliente> lstTemp = null;
            try {
                lstTemp = ObtenerClientes(string.Empty, 1, idEmpresa);

                if (lstTemp != null && lstTemp.Count > 0) {
                    return lstTemp.FindAll(x => !x.IdCliente.Equals(idCliente)).Count;
                }
                return 0;
            } finally {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}
