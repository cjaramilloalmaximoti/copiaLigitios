using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Empresa.AccesoDatos;

namespace ALM.Empresa.Datos
{
    public class DRol : Conexion
    {
        public List<ERol> Listar(ERol rol)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtRoles");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRol", rol.NombreRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", rol.IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ERol>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int Insertar(string nombreRol, int idIsuarioLog, short origenOperacion, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsRol");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRol", nombreRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return int.Parse(accesoDatos.ObtenerEscalar().ToString());

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void Actualizar(ERol rol, int idIsuarioLog, short origenOperacion)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActRol");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", rol.IdRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRol", rol.NombreRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", rol.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", rol.IdEmpresa));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int Eliminar(ERol rol, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliRol");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", rol.IdRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRol", rol.NombreRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", rol.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", rol.IdEmpresa));

                return (int)accesoDatos.ObtenerEscalar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}