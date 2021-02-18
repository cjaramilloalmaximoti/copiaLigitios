using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Empresa.AccesoDatos;

namespace ALM.Empresa.Datos
{
    public class DForma : Conexion
    {
        public List<EFormas> ObtenerListaFormasPorUsuario(int idUsuario, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtFormasRolesPrivilegiosPorUsuario");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EFormas>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EFormas> ObtenerListaFormasAdministrador(int idEmpresa, bool esSuperAdministrador)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtFormasRolesPrivilegiosPorAdministrador");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsSuperAdministrador", esSuperAdministrador));

                return accesoDatos.CargarTabla().DataTableMapToList<EFormas>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EFormas> ObtenerListaFormasPorRol(int idRol, string nombreForma, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtFormasRolesPrivilegiosPorRol");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", idRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreForma", nombreForma));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EFormas>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EFormas> ObtenerListaFormas(int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtFormas");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EFormas>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}