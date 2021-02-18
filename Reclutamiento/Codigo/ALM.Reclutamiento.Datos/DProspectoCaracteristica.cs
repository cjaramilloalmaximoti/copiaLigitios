using ALM.Reclutamiento.AccesoDatos;
using ALM.Reclutamiento.Entidades;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;

namespace ALM.Reclutamiento.Datos
{
    public class DProspectoCaracteristica : Conexion
    {
        public List<EProspectoCaracteristica> ObtenerListadoControlesDinamicos(EProspectoCaracteristica parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasPorCategoria");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdsCategorias", parametro.IdsCategorias));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", parametro.IdProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspectoCaracteristica>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
        public List<EProspectoCaracteristica> ObtenerListadoControlesDinamicosVacantes(EProspectoCaracteristica parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasVacantePorCategoria");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdsCategorias", parametro.IdsCategorias));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", parametro.IdProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspectoCaracteristica>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsProspectoCaracteristica(List<EProspectoCaracteristica> lstParametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsProspectoCaracteristica");

                if (lstParametro != null && lstParametro.Count > 0)
                {
                    foreach (EProspectoCaracteristica caracteristica in lstParametro)
                    {
                        accesoDatos.LimpiarParametros();
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", caracteristica.IdProspecto));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristicaParticular", caracteristica.IdCaracteristicaParticular));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pValor", caracteristica.Valor));
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

        public void InsVacanteCaracteristica(List<EProspectoCaracteristica> lstParametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsVacanteCaracteristica");

                if (lstParametro != null && lstParametro.Count > 0)
                {
                    foreach (EProspectoCaracteristica caracteristica in lstParametro)
                    {
                        accesoDatos.LimpiarParametros();
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", caracteristica.IdProspecto));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristicaParticular", caracteristica.IdCaracteristicaParticular));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pValor", caracteristica.Valor));
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

        public List<EProspectoCaracteristica> ObtCaracteristicasPorProspecto(EProspectoCaracteristica parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasPorProspecto");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", parametro.IdProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspectoCaracteristica>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EProspectoCaracteristica> ObtCaracteristicasPorVacante(EProspectoCaracteristica parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasPorVacante");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", parametro.IdProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspectoCaracteristica>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void EliProspectoCaracteristica(int IdProspectoCaracteristica)
        {
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliProspectoCaracteristica");

                accesoDatos.LimpiarParametros();
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspectoCaracteristica", IdProspectoCaracteristica));
                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void EliVacanteCaracteristica(int IdVacanteCaracteristica)
        {
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliVacanteCaracteristica");

                accesoDatos.LimpiarParametros();
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacanteCaracteristica", IdVacanteCaracteristica));
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
