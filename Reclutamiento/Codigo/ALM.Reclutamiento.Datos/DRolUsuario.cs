using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DRolUsuario : Conexion
    {
        public List<ERolUsuario> ObtenerRolUsuario(int idUsuario, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtRolUsuario");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pidUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ERolUsuario>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsertarRolUsuario(int idUsuario, int idRol, int idIsuarioLog, short origenOperacion, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsRolUsuario");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", idRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void EliminarRolUsuario(int idUsuario, int idRol, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliRolUsuario");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", idRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsEliRolUsuario(int idUsuario, int idEmpresa, List<ERol> lstRoles, int idUsuarioModifica, int idIsuarioLog, short origenOperacion)
        {
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsEliRolUsuario");

                if (lstRoles != null && lstRoles.Count > 0)
                {
                    foreach (ERol rol in lstRoles)
                    {
                        accesoDatos.LimpiarParametros();
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", rol.IdRol));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", rol.Estatus));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));
                        accesoDatos.Ejecutar();
                    }
                }
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}