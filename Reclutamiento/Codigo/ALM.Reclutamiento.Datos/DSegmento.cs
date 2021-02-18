using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DSegmento : Conexion
    {
        public void InsertarColumnasSegmento(List<EColumnaSegmento> lst)
        {
            try
            {
                if (lst != null && lst.Count > 0)
                {
                    AbrirConexion();

                    accesoDatos.LimpiarParametros();
                    accesoDatos.TipoComando = CommandType.StoredProcedure;
                    accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActColumnaSegmento");

                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", lst[0].IdSegmento));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", lst[0].IdEmpresa));

                    accesoDatos.Ejecutar();


                    accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsColumnaSegmento");

                    foreach (EColumnaSegmento columna in lst)
                    {
                        accesoDatos.LimpiarParametros();

                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", columna.IdSegmento));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", columna.IdEmpresa));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pEncabezado", columna.Encabezado));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pColumna", columna.Columna));

                        accesoDatos.Ejecutar();
                    }

                    accesoDatos.LimpiarParametros();
                    accesoDatos.TipoComando = CommandType.StoredProcedure;
                    accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliColumnaSegmento");

                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", lst[0].IdSegmento));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", lst[0].IdEmpresa));

                    accesoDatos.Ejecutar();
                }
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EColumnaSegmento> ObtenerColumnasSegmento(int pIdSegmento, int pIdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtColumnasSegmento");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", pIdSegmento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pIdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EColumnaSegmento>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EMapeoColumna> ObtenerMapeoSegmento(int pIdSegmento, int pIdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtMapeoSegmento");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", pIdSegmento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pIdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EMapeoColumna>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsertarMapeoSegmento(List<EMapeoColumna> lst)
        {
            try
            {
                if (lst != null && lst.Count > 0)
                {
                    AbrirConexion();

                    accesoDatos.LimpiarParametros();
                    accesoDatos.TipoComando = CommandType.StoredProcedure;
                    accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsMapeoSegmento");


                    foreach (EMapeoColumna columna in lst)
                    {
                        accesoDatos.LimpiarParametros();

                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", columna.IdSegmento));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", columna.IdEmpresa));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdColumnaDefaultSegmento", columna.IdColumnaDefaultSegmento));
                        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdColumnaSegmento", columna.IdColumnaSegmento));

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

        public List<EMapeoColumnasSegmento> ObteneMapeoColumnasSegmento(int pIdSegmento, int pIdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtMapeoColumnasSegmento");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", pIdSegmento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pIdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EMapeoColumnasSegmento>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ESelect2Json> ObtenerSegmentosBuscar(string pNombreCompleto, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtSegmentosBuscar");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", pNombreCompleto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ESelect2Json>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int ObtenerSegmentoCarga(int pIdEmpresa, int pIdSegmento)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtSegmentoCarga");


                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSegmento", pIdSegmento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pIdEmpresa));

                return int.Parse(accesoDatos.ObtenerEscalar().ToString());
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}