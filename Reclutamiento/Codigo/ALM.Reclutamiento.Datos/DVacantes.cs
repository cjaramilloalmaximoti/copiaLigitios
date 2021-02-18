using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
   public class DVacantes : Conexion
    {
        /// <summary>
        /// Agregar una Nueva Vacante
        /// </summary>
        /// <param name="vacante">Datos de la Vacante a Agregar</param>
        /// <returns>Valor Enteero del Ultimo Registro Agregado</returns>
        public int InsertarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {
          /*  vacante.Titulo = "'" + vacante.Titulo + "'";
            vacante.SubTitulo = "'" + vacante.SubTitulo + "'";
            vacante.Descripcion = "'" + vacante.Descripcion + "'";
            vacante.IdCiudad = "'" + vacante.IdCiudad + "'";
            vacante.Comentarios = "'" + vacante.Comentarios + "'"; */
            int IdVacante = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsVacante");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pTitulo", vacante.Titulo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSubTitulo", vacante.SubTitulo)); // CAT Para Agregar el campo Sub Titulo
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", vacante.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaContratacion", vacante.FechaContratacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroVacantes", vacante.NumeroVacantes));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalario", vacante.Salario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoContrato", vacante.IdTipoContrato));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", vacante.idCliente)); // CAT Para ligarlo al cliente
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoJornada", vacante.IdTipoJornada));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCiudad", vacante.IdCiudad));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioCreacion", vacante.IdUsuarioCreacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioUltimoModifico", vacante.IdUsuarioUltimoModifico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", vacante.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", vacante.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", vacante.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFase", vacante.Fase));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaEntrega", vacante.FechaEntrega));
                //accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles)); // CAT Para Agregar las Fuentes Seccionadas

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    IdVacante = int.Parse(dt.Rows[0]["IdVacante"].ToString());
                }
                return IdVacante;
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


        public void InsertarVacante_Fuente(string detalles) {
 
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsVacante_Fuente");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles));
                accesoDatos.Ejecutar();

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
               
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agregar una Nueva Vacante
        /// </summary>
        /// <param name="vacante">Datos de la Vacante a Agregar</param>
        /// <returns>Valor Enteero del Ultimo Registro Agregado</returns>
        public void InsertarVacante_prospecto(int IdVacante, string detalles) 
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsVacante_Prospecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", IdVacante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }

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
        /// Envio de Correo de Invitación al prospecto
        /// </summary>
        /// <param name="Prospecto">Prospecto al que se enviará el correo</param>
        public void EnviarCorreo(EVacante vacante, EProspecto prospecto)
        {
            Correo.Correo correo = null;

            try
            {
                var fechaNow = DateTime.Today;
                correo = new Correo.Correo();

                correo.EsSSL = true;
                correo.NombreUsuarioCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.ContraseniaCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Contrasenia").Valor;
                correo.De = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.AliasDe = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.SMTP = EClaseEstatica.LstParametro.Find(x => x.Nombre == "SMTP").Valor;

                correo.EsHTMLBody = true;
                correo.Puerto = int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre == "Puerto").Valor.ToString());

                correo.Body = EClaseEstatica.LstParametro.Find(x => x.Nombre == "CorreoInvitacionVacante").Valor.ToString();
                correo.Titulo = EClaseEstatica.LstParametro.Find(x => x.Nombre == "TituloNotificacionInvitacionVacante").Valor;
                
                correo.Body = correo.Body.Replace("%%NombreProspecto%%", prospecto.NombreCompleto);
                correo.Body = correo.Body.Replace("%%NombreVacante%%", vacante.Titulo);
                correo.Body = correo.Body.Replace("%%NombreEmpresa%%", EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa == vacante.IdEmpresa).NombreComercial);
                correo.Body = correo.Body.Replace("%%EmailEmpresa%%", EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa == vacante.IdEmpresa).Email);

                correo.EnviarCorreo(prospecto.Email, null);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        /// <summary>
        /// Eliminar un prospecto de una vacante
        /// </summary>
        /// <param name="IdVacante">Id de la vacante</param>
        /// <param name="IdProspecto">Id del prospecto</param>
        /// <returns>Valor Entero de los registros afectados</returns>
        public void EliminarVacante_prospecto(int IdVacante, int IdProspecto)
        {
            int res = 0;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliVacante_Prospecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", IdVacante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", IdProspecto));

                res = Convert.ToInt16(accesoDatos.ObtenerEscalar());

                if (res == 0)
                {
                    throw new Exception("Error interno, no se pudo eliminar el prospecto de la vacante.");
                }

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                res = 0;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Actualizar Vacante
        /// </summary>
        /// <param name="vacante">Datos Nuevos de la Vacante</param>
        public void ActualizarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {

            detalles = detalles.Split('/')[0];
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActVacante");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", vacante.IdVacante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTitulo", vacante.Titulo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSubTitulo", vacante.SubTitulo)); // CAT Para Agregar el campo Sub Titulo
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", vacante.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaContratacion", vacante.FechaContratacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroVacantes", vacante.NumeroVacantes));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalario", vacante.Salario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoContrato", vacante.IdTipoContrato));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCliente", vacante.idCliente)); // CAT Para ligarlo al cliente
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoJornada", vacante.IdTipoJornada));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCiudad", vacante.IdCiudad));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioUltimoModifico", vacante.IdUsuarioUltimoModifico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", vacante.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", vacante.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFase", vacante.Fase));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaEntrega", vacante.FechaEntrega));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles)); // CAT Para Agregar las Fuentes Seccionadas
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", vacante.IdEmpresa));
                

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
        /// Obtener las Vacantes
        /// </summary>
        /// <param name="vacante">Datos de las Vacantes a Obtener</param>
        /// <returns>Lsta de las Vacantes encontradas en la BD</returns>
        public List<EVacante> ObtenerVacantes(EVacante vacante)
        {
            
            string strQuery = "";
            int pDesde, pHasta;

            if (vacante.Estatus == -1)
            {
                pDesde = 0;
                pHasta = 1;
            }
            else
            {
                pDesde = vacante.Estatus;
                pHasta = vacante.Estatus;
            }

            strQuery += "" +
                "SELECT va.IdVacante, va.Titulo, va.SubTitulo, va.Descripcion, va.FechaContratacion, va.NumeroVacantes, va.Salario, va.IdTipoContrato, va.IdCliente, va.IdFuentePublicacion, va.IdTipoJornada,  va.idCiudad, va.Estatus, va.IdEmpresa, va.Comentarios, va.Fase, va.FechaEntrega, (SELECT GROUP_CONCAT( '-',IdFuente,'-')	FROM	vacante_fuente vf	WHERE	vf.IdVacante = va.IdVacante) AS Fuentes " +
                "FROM vacante va inner join cliente c on va.IdCliente=c.IdCliente " +
                "WHERE va.IdEmpresa = " + vacante.IdEmpresa + " AND (va.Estatus between " + pDesde + " AND " + pHasta + ") ";

            if (vacante.Titulo != null)
            {
                strQuery += "AND va.Titulo LIKE CONCAT('%','" + vacante.Titulo + "','%') ";
            }

            if (vacante.IdTipoContrato != -1)
            {
                strQuery += "AND va.IdTipoContrato = " + vacante.IdTipoContrato + " ";
            }

            if (vacante.Cliente != null)
            {
                strQuery += "AND c.NombreComercial LIKE CONCAT('%','" + vacante.Cliente + "','%') ";
            }
            /*
            if (vacante.IdTipoJornada != -1)
            {
                strQuery += "AND va.IdTipoJornada = " + vacante.IdTipoJornada + " ";
            }*/

            strQuery += ";";

            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtVacantes");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pVacantes", strQuery));


                return accesoDatos.CargarTabla().DataTableMapToList<EVacante>();
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
        /// Obtener cuantas Vacantes estan Activas
        /// </summary>
        /// <param name="idempresa">Id de la Empresa</param>
        /// <param name="estatus">Estatus, Activo o Inactivo</param>
        /// <returns>Valor entero del Total de Vacantes Activas</returns>
        public int CuantasVacantesActivas(int idempresa, int estatus)
        {
            List<EVacante> lstTemp = new List<EVacante>();
            EVacante lstTemp2 = new EVacante();

            lstTemp2.IdEmpresa = idempresa;
            var auxiliar = Convert.ToSByte(estatus);
            lstTemp2.Estatus = auxiliar;
            lstTemp2.IdTipoContrato = -1;
            lstTemp2.IdTipoJornada = -1;
            lstTemp = ObtenerVacantes(lstTemp2);

            try
            {
                if (lstTemp != null && lstTemp.Count > 0)
                {
                    return lstTemp.FindAll(x => !x.IdEmpresa.Equals(idempresa)).Count;
                }
                return 0;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }
    }
}
