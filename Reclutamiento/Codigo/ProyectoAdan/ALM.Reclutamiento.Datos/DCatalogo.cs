using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Empresa.AccesoDatos;


namespace ALM.Empresa.Datos
{
    public class DCatalogo : Conexion
    {
        public int InsertarCatalogo(ECatalogo parametro, int idIsuarioLog)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCatalogo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pClave", parametro.Clave ?? string.Empty));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                return int.Parse(accesoDatos.ObtenerEscalar().ToString());
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }

        public void Actualizar(ECatalogo parametro, int idIsuarioLog)
        {

            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActCatalogo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pClave", parametro.Clave ?? string.Empty));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", parametro.IdCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogo> Listar(ECatalogo parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCatalogo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pidTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCatalogo", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.Estaus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogo> ObtCatalogoPorNombre(string nombreCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCatalogoPorNombre");


                accesoDatos.ListaParametros.Add(new MySqlParameter("pCatalogo", nombreCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogo> ObtCatalogoDelSubCatalogo(int idCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCatalogoDelSubCatalogo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", idCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogo> ObtInfoSubCatalogoPorIdPadre(int idCatalogo, int idTipoCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtInfoSubCatalogoPorIdPadre");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", idCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoCatalogo", idTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }


        public List<ECatalogo> ObtInfoSubCatalogoPorNombrePadre(int idCatalogo, string nombreCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtInfoSubCatalogoPorNombrePadre");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", idCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCatalogo", nombreCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}