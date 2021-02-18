using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DBitacora : Conexion
    {
        /// <summary>
        /// Obtener los registros de la Bitacora por ID
        /// </summary>
        /// <param name="idProspecto">Id del Prospecto a Buscar</param>
        /// <returns>Lista de los registros en Bitacora del registro</returns>
        public List<EBitacora> ObtenerBitacoraIdProspecto(int idProspecto)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtBitacora");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", idProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EBitacora>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agrega un registro a Bitácora
        /// </summary>
        /// <param name="bitacora">Datos de la Bitácora a Agregar</param>
        /// <returns>Valor del Último registro Agregado</returns>
        public int InsertarBitacora(EBitacora bitacora)
        {
            int idBitacora = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsBitacora");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", bitacora.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", bitacora.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", bitacora.IdUsuarioCreacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaCreacion", bitacora.FechaCreacion));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idBitacora = int.Parse(dt.Rows[0]["IdBitacora"].ToString());
                }

                return idBitacora;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}
