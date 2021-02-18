using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DReferenciaLaboral : Conexion
    {
        /// <summary>
        /// Obtener referencia laboral por Prospecto
        /// </summary>
        /// <param name="referencia">Datos de la Referencia a BUscar</param>
        /// <returns>Lista de las Referencias Laborales encontradas en BD</returns>
        public List<EReferenciaLaboral> ObtenerReferenciaLaboralIdProspecto(EReferenciaLaboral referencia)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtReferenciaLaboralIdProspecto");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", referencia.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", referencia.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", referencia.IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EReferenciaLaboral>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agregar una Nueva Referencia Laboral
        /// </summary>
        /// <param name="referencia">Datos de la Nueva Referencia Laboral</param>
        /// <param name="IdUsuarioLog">Id Usuario Logueado</param>
        /// <returns>Valor entero del Ultimo Registro Agregado</returns>
        public int InsertarReferenciaLaboral(EReferenciaLaboral referencia, int IdUsuarioLog)
        {
            int idReferencia = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsReferenciaLaboral");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto",referencia.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresa", referencia.Empresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDomicilio", referencia.Domicilio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto", referencia.Contacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", referencia.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", referencia.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pMotivoSeparacion", referencia.MotivoSeparacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPuesto", referencia.Puesto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTiempoLaborado", referencia.TiempoLaborado));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", referencia.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", referencia.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", IdUsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", referencia.IdEmpresa));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idReferencia = int.Parse(dt.Rows[0]["IdReferencia"].ToString());
                }

                return idReferencia;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Actualizar datos de la Referencia Laboral
        /// </summary>
        /// <param name="referencia">Datos nuevos de la Referencia</param>
        /// <param name="idUsuarioLog">Id Usuario Logueado</param>
        /// <param name="Eliminar">Opcion Eliminar</param>
        public void ActualizarReferenciaLaboral(EReferenciaLaboral referencia, int idUsuarioLog)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;

                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActReferenciaLaboral");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdReferencia", referencia.IdReferencia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", referencia.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmpresa", referencia.Empresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDomicilio", referencia.Domicilio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto", referencia.Contacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Email", referencia.Contacto_Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContacto_Telefono", referencia.Contacto_Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pMotivoSeparacion", referencia.MotivoSeparacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPuesto", referencia.Puesto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTiempoLaborado", referencia.TiempoLaborado));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", referencia.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", referencia.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idUsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", referencia.IdEmpresa));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
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
