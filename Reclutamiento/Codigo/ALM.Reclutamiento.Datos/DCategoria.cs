using ALM.Reclutamiento.Entidades;
using System.Data;
using System;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using ALM.Reclutamiento.AccesoDatos;


namespace ALM.Reclutamiento.Datos
{
    public class DCategoria:Conexion
    {
        /// <summary>
        /// Insertar una categoria
        /// </summary>
        /// <param name="categoria">Datos de la categoria</param>
        /// <returns>El Id del registro agregado</returns>
        public int InsertarCategoria(ECategoria categoria)
        {
            int idCategoria = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCategoria");


                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", categoria.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioCreacion", categoria.IdUsuarioCreacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", categoria.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", categoria.IdEmpresa));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idCategoria = int.Parse(dt.Rows[0]["IdCategoria"].ToString());
                }
                return idCategoria;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Obtener las categorias
        /// </summary>
        /// <param name="categoria">Nombre de la categoria</param>
        /// <returns>Lista de las categorias encontradas en BD</returns>
        public List<ECategoria> obtenerCategorias(ECategoria categoria)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCategorias");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", categoria.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", categoria.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", categoria.Nombre));

                return accesoDatos.CargarTabla().DataTableMapToList<ECategoria>();
            }
            catch (Exception ex)
            {

                throw ex;
            }

            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Actualizar una Categoria
        /// </summary>
        /// <param name="categoria">Datos de la categoria</param>
        public void ActualizarCategoria(ECategoria categoria)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActCategoria");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCategoria",  categoria.IdCategoria));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", categoria.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", categoria.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioUltimoModifico", categoria.IdUsuarioUltimoModifico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", categoria.IdEmpresa));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }

        /// <summary>
        /// Obtener el TIop de Categorias
        /// </summary>
        /// <param name="empresaid">Id Empresa</param>
        /// <returns></returns>
        public List<ECategoria> obtenerCategoriasTipo(int empresaid)
        {
           
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCategoriasTipo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", empresaid));

                return accesoDatos.CargarTabla().DataTableMapToList<ECategoria>();
            }
            catch (Exception ex)
            {

                throw ex;
            }

            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }
    }
}
