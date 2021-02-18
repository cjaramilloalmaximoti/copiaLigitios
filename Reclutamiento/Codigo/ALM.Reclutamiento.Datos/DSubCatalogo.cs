using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DSubCatalogo : Conexion
    {
        public int InsertarSubCatalogo(ESubCatalogo parametro, int idIsuarioLog, short origenOperacion)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsSubCatalogo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pClave", parametro.Clave ?? string.Empty));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", parametro.IdCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                int id = int.Parse(accesoDatos.ObtenerEscalar().ToString());
                if (id == 0)
                {
                    throw new Exception("Error al insertar: La clave que intenta guardar ya esta siendo utilizada.");
                }
                return id;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ActualizarSubCatalogo(ESubCatalogo parametro, int idIsuarioLog, short origenOperacion)
        {

            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActSubCatalogo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pClave", parametro.Clave ?? string.Empty));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSubCatalogo", parametro.IdSubCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", parametro.IdCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", parametro.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                int id = int.Parse(accesoDatos.ObtenerEscalar().ToString());

                if (id == 0)
                {
                    throw new Exception("Error al actualizar: La clave que intenta guardar ya esta siendo utilizada.");
                }

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ESubCatalogo> ObtenerSubCatalogoDeCatalogoPadre(ESubCatalogo parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtSubCatalogos");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pidTipoCatalogo", parametro.IdTipoCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCatalogo", parametro.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivoFiltro));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ESubCatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ESubCatalogo> ObtenerSubCatalogoPorIdCatalogo(int idCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtSubCatalogoPorIdCatalogo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", idCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));


                return accesoDatos.CargarTabla().DataTableMapToList<ESubCatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogosSubCatalogo> ObtenerCatalogosDelSubCatalogo(int idCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCatalogosDelSubCatalogo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCatalogo", idCatalogo));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogosSubCatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECatalogosSubCatalogo> ObtIdsCatalogosDelSubCatalogo(int idSubCatalogo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtIdsCatalogosDelSubCatalogo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSubCatalogo", idSubCatalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogosSubCatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}