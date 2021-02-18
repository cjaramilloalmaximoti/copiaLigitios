using System;
using ALM.Empresa.AccesoDatos;
using ALM.Empresa.Entidades;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;

namespace ALM.Empresa.Datos
{
    public class DEmpresa : Conexion
    {
        public List<EEmpresa> ObtenerEmpresas()
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtEmpresas");

                return accesoDatos.CargarTabla().DataTableMapToList<EEmpresa>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }


        public void ActualizarEmpresa(EEmpresa parametro)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                AbrirConexion();

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);


                parametro.Contraseña = utileria.Cifrar(parametro.Contraseña);

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActEmpresa");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", parametro.Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pProductKey", parametro.ProductKey));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAdministrador", parametro.Administrador));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContraseña", parametro.Contraseña));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", parametro.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRutaLogo", parametro.RutaLogo));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}