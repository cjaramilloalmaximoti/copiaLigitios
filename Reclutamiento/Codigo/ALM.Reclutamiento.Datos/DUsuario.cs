using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DUsuario : Conexion
    {
        Utilerias.Utilerias utileria = null;

        /// <summary>
        /// Valida logueo usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a validar</param> 
        public EUsuario ValidarUsuario(EUsuario pUsuario)
        {
            List<EUsuario> lstUsuarios = null;
            try
            {
                AbrirConexion();
                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                pUsuario.Contrasenia = utileria.Cifrar(pUsuario.Contrasenia);

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml("../Persistencia/Consultas.config", "SPObtUsuarioValidar");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pUsuario.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pLogin", pUsuario.Login == null ? "" : pUsuario.Login));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", pUsuario.Contrasenia == null ? "" : pUsuario.Contrasenia));

                lstUsuarios = accesoDatos.CargarTabla().DataTableMapToList<EUsuario>();

                return lstUsuarios != null && lstUsuarios.Count > 0 ? lstUsuarios[0] : null;
            }
            finally
            {
                lstUsuarios = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Marca como en recuperacion de contraseña al usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a actualizar</param>
        public EUsuario RecuperarContraseniaUsuario(EUsuario pUsuario, short origenOperacion)
        {
            List<EUsuario> listausuarios;
            try
            {
                AbrirConexion();


                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml("../Persistencia/Consultas.config", "SPActUsuarioRecuperarContrasenia");
                accesoDatos.ListaParametros.Add(new MySqlParameter("peMail", pUsuario.CorreoElectronico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCodigoRecuperacion", pUsuario.CodigoRecuperaContrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pUsuario.IdEmpresa));

                listausuarios = accesoDatos.CargarTabla().DataTableMapToList<EUsuario>();

                if (listausuarios.Count == 1)
                    return listausuarios[0];
                else
                    throw new Exception("Número inconveniente de ocurrencias de la cuenta de correo electrónico");
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

        public EUsuario ConsultarUsuarioPorId(int idUsuario, int idEmpresa)
        {
            List<EUsuario> lstUsuarios = null;
            try
            {
                AbrirConexion();


                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml("../Persistencia/Consultas.config", "SPObtUsuarioPorId");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario ", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                lstUsuarios = accesoDatos.CargarTabla().DataTableMapToList<EUsuario>();

                if (lstUsuarios.Count != 1)
                {
                    throw new Exception("Número inconveniente de ocurrencias de la cuenta de correo electrónico");
                }

                return lstUsuarios[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                lstUsuarios = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }

        /// <summary>
        /// Actualiza registro usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a actualizar</param>
        public void ActualizarContraseniaUsuario(EUsuario pUsuario, int idIsuarioLog, short origenOperacion)
        {
            utileria = new Utilerias.Utilerias();

            try
            {

                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);

                pUsuario.Contrasenia = utileria.Cifrar(pUsuario.Contrasenia);

                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml("../Persistencia/Consultas.config", "SPActUsuarioConstrasenia");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", pUsuario.IdUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", pUsuario.Contrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", pUsuario.IdEmpresa));

                int objReturn = accesoDatos.Ejecutar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                utileria = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }

        public List<EUsuario> ObtenerUsuarios(string nombreCompleto, int activo, int idEmpresa)
        {
            List<EUsuario> lstTemp = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtUsuarios");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", nombreCompleto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                lstTemp = accesoDatos.CargarTabla().DataTableMapToList<EUsuario>();

                if (lstTemp != null && lstTemp.Count > 0)
                {
                    utileria = new Utilerias.Utilerias();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);

                    foreach (EUsuario usuario in lstTemp)
                    {
                        usuario.Contrasenia = utileria.Descifrar(usuario.Contrasenia);
                    }
                }

                return lstTemp;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int InsertarUsuario(EUsuario usuario, List<ERol> lstRoles, int idUsuarioModifica, int idIsuarioLog, short origenOperacion)
        {
            int idUsuario = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsUsuario");

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                usuario.Contrasenia = utileria.Cifrar(usuario.Contrasenia);

                accesoDatos.ListaParametros.Add(new MySqlParameter("pLogin", usuario.Login));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", usuario.NombreCompleto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCorreoElectronico", usuario.CorreoElectronico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", usuario.Contrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", usuario.Activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pUltimoModifico", idUsuarioModifica));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", usuario.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdInstitucion", usuario.IdInstitucion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", usuario.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDomicilio", usuario.Domicilio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefono", usuario.Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pReferencia", usuario.Referencia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pReferenciaTelefono", usuario.Referencia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaNacimiento", usuario.FechaNacimiento));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idUsuario = int.Parse(dt.Rows[0]["IdUsuario"].ToString());
                    new DRolUsuario().InsEliRolUsuario(idUsuario, usuario.IdEmpresa, lstRoles, idUsuarioModifica, idIsuarioLog, origenOperacion);
                }

                return idUsuario;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ActualizarUsuario(EUsuario usuario, List<ERol> lstRoles, int idUsuarioModifica, int idIsuarioLog, short origenOperacion)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActUsuario");

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                usuario.Contrasenia = utileria.Cifrar(usuario.Contrasenia);

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", usuario.IdUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pLogin", usuario.Login));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", usuario.NombreCompleto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCorreoElectronico", usuario.CorreoElectronico));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", usuario.Contrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", usuario.Activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pUltimoModifico", idUsuarioModifica));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentarios", usuario.Comentarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdInstitucion", usuario.IdInstitucion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigenOperacion", origenOperacion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", usuario.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDomicilio", usuario.Domicilio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefono", usuario.Telefono));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pReferencia", usuario.Referencia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pReferenciaTelefono", usuario.Referencia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaNacimiento", usuario.FechaNacimiento));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    new DRolUsuario().InsEliRolUsuario(usuario.IdUsuario, usuario.IdEmpresa, lstRoles, idUsuarioModifica, idIsuarioLog, origenOperacion);
                }
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void EliminarUsuario(int idUsuario, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPEliUsuario");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public bool ValidarLoginUnico(string login, int idUsuario, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtUsuarioValidacionLogin");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pLogin", login));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return bool.Parse(accesoDatos.ObtenerEscalar().ToString());

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public bool ValidarCorreoUnico(string correo, int idUsuario, int idEmpresa)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtUsuarioValidacionCorreo");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pCorreoElectronico", correo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idUsuario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return bool.Parse(accesoDatos.ObtenerEscalar().ToString());

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public int CuantosUsuariosActivos(int idEmpresa, int idUsuario)
        {
            List<EUsuario> lstTemp = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtUsuarios");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", null));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", true));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                lstTemp = accesoDatos.CargarTabla().DataTableMapToList<EUsuario>();

                if (lstTemp != null && lstTemp.Count > 0)
                {
                    return lstTemp.FindAll(x => !x.IdUsuario.Equals(idUsuario)).Count;
                }
                return 0;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ESelect2Json> ObtenerUsuariosAnalista(string nombreCompleto, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtUsuariosAnalistas");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCompleto", nombreCompleto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ESelect2Json>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}