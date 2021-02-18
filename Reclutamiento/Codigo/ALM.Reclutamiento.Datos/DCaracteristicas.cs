using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Utilerias;
using System.Data;
using System;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using ALM.Reclutamiento.AccesoDatos;

using EnviarCorreo = ALM.Correo;

namespace ALM.Reclutamiento.Datos
{
   public class DCaracteristicas:Conexion
    {
        /// <summary>
        /// Insertar una nueva Caracteristica
        /// </summary>
        /// <param name="caracteristica">Datos de la Caracteristica</param>
        /// <param name="detalles">Detalles de la caracteristica, las categorias a las que pertenece</param>
        /// <param name="servidor">Servidor donde entrara el Correo</param>
        /// <param name="mailAdmin">Mail del Administrador</param>
        /// <returns></returns>
        public int InsertarCaracteristica(ECaracteristicas caracteristica, string detalles, string servidor, string mailAdmin)
        {
            int idCracteristica = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCaracteristicas");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", caracteristica.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", caracteristica.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoControl", caracteristica.IdTipoControl));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAprobada", caracteristica.Aprobada));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", caracteristica.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", caracteristica.IdUsuarioCreacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", caracteristica.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCodigoGenerado", caracteristica.codigoGenerado));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles));

                dt =accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idCracteristica = int.Parse(dt.Rows[0]["IdCaracteristica"].ToString());
                }

                caracteristica.IdCaracteristica = idCracteristica;
                EnviarCorreo(caracteristica, servidor, mailAdmin);

                return idCracteristica;
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
        /// Obtener una Lista de las Características en la BD
        /// </summary>
        /// <param name="caracteristica">Datos de la Caracteristicas, asi como los filtros en ella</param>
        /// <returns>Una lista (list) de lascaracterísticas obtenidas en la BD</list></returns>
        public List<ECaracteristicas> obtenerCaracteristicas(ECaracteristicas caracteristica, string masFiltros)
        {
            string strQuery = "";
            int pDesde, pHasta;

            if (caracteristica.Aprobada == -1)
            {
                pDesde = 0;
                pHasta = 2;
            }
            else
            {
                pDesde = caracteristica.Aprobada;
                pHasta = caracteristica.Aprobada;
            }

            strQuery += "" +
                "SELECT c.IdCaracteristica, c.Nombre, c.Descripcion, c.IdTipoControl, tc.Nombre as TipoControl, c.IdEmpresa, c.Comentario, c.Aprobada, c.EsActivo, c.IdUsuarioCreacion, c.FechaCreacion, (case when c.IdUsuarioCreacion = 0 then(select Email from empresa where idEmpresa = c.idEmpresa) else (select CorreoElectronico from usuario where IdUsuario = c.IdUsuarioCreacion) end) as Email, (case when c.IdUsuarioCreacion = 0 then ('Administrador') else (select NombreCompleto from usuario where IdUsuario = c.IdUsuarioCreacion) end) as Usuario, (select GROUP_CONCAT('-',idcategoria,'-') from caracteristica_categoria where idcaracteristica = c.IdCaracteristica) as Categorias " +
                ", tc.FormatoControl as Formato, tc.NumeroDecimales " +//SALAZAR 04/04/2019 REQ03042019: Se agrega el campo del formato y número decimales del tipo de control
                "FROM caracteristicas c inner join caracteristica_categoria cc on cc.idcaracteristica = c.IdCaracteristica inner join categoria cat on cat.IdCategoria = cc.idcategoria inner join tipocontrol tc on tc.IdTipoControl = c.IdTipoControl " +
                "WHERE (c.Aprobada between " + pDesde + " AND " + pHasta + ") ";

            if (caracteristica.Nombre != null)
            {
                strQuery += "AND (c.Nombre LIKE CONCAT('%','" + caracteristica.Nombre + "','%') OR c.Descripcion LIKE CONCAT('%','" + caracteristica.Nombre + "','%')) ";
            }

            if (caracteristica.intEsActivo == -1)
            {
                pDesde = 0;
                pHasta = 1;
            }
            else
            {
                pDesde = caracteristica.intEsActivo;
                pHasta = caracteristica.intEsActivo;    
            }

            strQuery += " AND (c.EsActivo between " + pDesde + " AND " + pHasta + ") " + masFiltros;

            strQuery += "group by c.idcaracteristica;";

            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicas");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pCaracteristica", strQuery));

                return accesoDatos.CargarTabla().DataTableMapToList<ECaracteristicas>();
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
        /// Actualizar el registro de la Característica
        /// </summary>
        /// <param name="caracteristica">Datos de la Caracteristica a Modificar con sus valores</param>
        public void ActualizarCaracteristica(ECaracteristicas caracteristica, string detalles, string servidor)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActCaracteristicas");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristica", caracteristica.IdCaracteristica));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", caracteristica.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDescripcion", caracteristica.Descripcion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdTipoControl", caracteristica.IdTipoControl));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAprobada", caracteristica.Aprobada));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", caracteristica.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", caracteristica.IdUsuarioModificacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", caracteristica.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", caracteristica.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDetalles", detalles));

                dt = accesoDatos.CargarTabla();

                if (caracteristica.Aprobada != 0)
                {
                    EnviarCorreo(caracteristica, servidor, "");
                }

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
        /// Aproar o Rechazar la Caracteristica
        /// </summary>
        /// <param name="carac">Datos de la Caacteristica</param>
        public void aprobarRechazar(ECaracteristicas carac)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPAprobarRechazarCaracteristica");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pId", carac.IdCaracteristica));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAprobada", carac.Aprobada));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", carac.Comentario));

                dt = accesoDatos.CargarTabla();

                EnviarCorreo(carac, "","");
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
        /// Validar Codigo del Enlace
        /// </summary>
        /// <param name="codigo">Codigo del Enlace</param>
        /// <param name="id">Id de la Caracteristica</param>
        /// <returns></returns>
        public List<ECaracteristicas> validarCodigo(string codigo, int id)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPValidarCodigo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCodigo", codigo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pId", id));

                return accesoDatos.CargarTabla().DataTableMapToList<ECaracteristicas>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Envio de Correo de Notificacion de la Caracteristica
        /// </summary>
        /// <param name="carac"></param>
        public void EnviarCorreo(ECaracteristicas carac, string servidor, string mailAdmin)
        {
            EnviarCorreo.Correo correo = null;

            try
            {
                var fechaNow = DateTime.Today;
                correo = new EnviarCorreo.Correo();

                correo.EsSSL = true;
                correo.NombreUsuarioCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.ContraseniaCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Contrasenia").Valor;
                correo.De = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.AliasDe = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.SMTP = EClaseEstatica.LstParametro.Find(x => x.Nombre == "SMTP").Valor;

                correo.EsHTMLBody = true;
                correo.Puerto = int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre == "Puerto").Valor.ToString());

                if (carac.Aprobada == 0) //Caracteristica Nueva
                {
                    correo.Body = EClaseEstatica.LstParametro.Find(x => x.Nombre == "CorreoCaracteristicaNueva").Valor.ToString();
                    carac.FechaCreacion = DateTime.Now;
                    correo.Titulo = "Característica Nueva Agregada";
                    correo.Body = correo.Body.Replace("%%accion%%", "Agregada");
                }
                else //Aprobar o Rechazar Caracteristica
                {
                    correo.Body = EClaseEstatica.LstParametro.Find(x => x.Nombre == "CorreoCaracteristicaAprobadaRechazada").Valor.ToString();
                    correo.Titulo = EClaseEstatica.LstParametro.Find(x => x.Nombre == "TituloNotificacion").Valor;
                    correo.Body = correo.Body.Replace("%%accion%%", (carac.Aprobada == 1 ? "Aprobada" : "Rechazada"));
                }

                correo.Body = correo.Body.Replace("%%fechaNow%%", fechaNow.ToShortDateString());
                correo.Body = correo.Body.Replace("%%caracteristica%%", carac.Nombre);
                correo.Body = correo.Body.Replace("%%usuario%%", carac.Usuario);
                correo.Body = correo.Body.Replace("%%fecha%%", carac.FechaCreacion.ToShortDateString());
                correo.Body = correo.Body.Replace("%%comentario%%", carac.Comentario);

                correo.Body = correo.Body.Replace("%%empresa%%", carac.Empresa);

                correo.Body = correo.Body.Replace("%%lnkAprobar%%", generarLink(1, carac, servidor));
                correo.Body = correo.Body.Replace("%%lnkRechazar%%", generarLink(2, carac, servidor));

                if (carac.Aprobada == 0)
                    correo.EnviarCorreo(mailAdmin, null);
                else
                    correo.EnviarCorreo(carac.Email, null);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        /// <summary>
        /// Generar Link de Aprobar/Rechazar
        /// </summary>
        /// <param name="accion">Accion, Nueva, Aprobar, Rechazar (0,1,2)</param>
        /// <param name="carac">Datos de la Caracteristica</param>
        /// <param name="servidor">Servidor de Conexion al dar click en el correo</param>
        /// <returns>Una cadena Cifrada con el link de aprobar o rechazar</returns>
        public string generarLink(int accion, ECaracteristicas carac, string servidor)
        {
            Utilerias.Utilerias utilerias = new Utilerias.Utilerias();
            string cadena = "";
            string cadenaRetorno = "";

            string strLink = accion + "|" + carac.IdCaracteristica + "|" + carac.Nombre + "|" + carac.Usuario + "|" + carac.FechaCreacion.ToShortDateString() + "|" + carac.Empresa + "|" + carac.codigoGenerado + "|" + carac.Email;

            utilerias.Clave = "";
            utilerias.Clave = utilerias.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);

            cadena = utilerias.Cifrar(strLink);
            foreach (EReemplazarMVC reemplazar in EClaseEstatica.LstReemplazarMVC)
                cadena = cadena.Replace(reemplazar.RealMVC, reemplazar.Reemplazar);

            cadenaRetorno = "<a href='" + servidor + "/Caracteristicas/linkAccion?link=" + cadena + "'><label style = 'color: " + (accion == 1 ? "green;" : "red;") + " cursor: hand;'>" + (accion == 1 ? "Aprobar" : "Rechazar") + "</label></a>";

            return cadenaRetorno;
        }

        /// <summary>
        /// Obtener una Lista de las Tipos de Controles en la BD
        /// </summary>
        /// <returns>Una lista (list) de tipos de controles obtenidas en la BD</list></returns>
        public List<ETipoControl> ObtenerTiposControl()
        {
            string strQuery = "";
            try
            {
                strQuery += "" +
                "SELECT IdTipoControl, Nombre, Orden,  FormatoControl,  NumeroDecimales FROM tipocontrol;";

                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicas");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pCaracteristica", strQuery));

                return accesoDatos.CargarTabla().DataTableMapToList<ETipoControl>();
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
