using System;
using ALM.Reclutamiento.AccesoDatos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;

namespace ALM.Reclutamiento.Datos
{
    public class DParametro : Conexion
    {
        public List<EParametro> ObtenerParametros()
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtenerParametros");

                return accesoDatos.CargarTabla().DataTableMapToList<EParametro>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void Actualizar(EParametro parametro, int idIsuarioLog, short origenOperacion)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                AbrirConexion();

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);

                if (parametro.EsSensitivo)
                {
                    parametro.Valor = utileria.Cifrar(parametro.Valor);

                }
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActParametro");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdParametro", parametro.IdParametro));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pValor", parametro.Valor));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsSensitivo", parametro.EsSensitivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EParametro> Listar(EParametro parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtParametros");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre == null ? Constante.SinRegistro : parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion == null ? Constante.SinRegistro : parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EParametro>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ActualizarParametroEmpresa(EParametro parametro, int idIsuarioLog, short origenOperacion)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                AbrirConexion();

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);

                if (parametro.EsSensitivo)
                {
                    parametro.Valor = utileria.Cifrar(parametro.Valor);

                }
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActParametroEmpresa");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdParametro", parametro.IdParametro));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pValor", parametro.Valor));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsSensitivo", parametro.EsSensitivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EParametro> ListarParametroEmpresa(EParametro parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtParametrosEmpresa");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre == null ? Constante.SinRegistro : parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion == null ? Constante.SinRegistro : parametro.Descripcion));

                return accesoDatos.CargarTabla().DataTableMapToList<EParametro>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}