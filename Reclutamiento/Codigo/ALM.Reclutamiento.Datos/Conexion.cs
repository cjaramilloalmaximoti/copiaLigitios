using ALM.Reclutamiento.AccesoDatos;
using System;

namespace ALM.Reclutamiento.Datos
{
    public class Conexion
    {
        /// <summary>
        /// instancia del acceso a datos
        /// </summary>
        public MySqlClient accesoDatos = new MySqlClient();

        #region Metodos genericos

        /// <summary>
        /// Abre la conexión hacia la base de datos 
        /// </summary>
        /// <param name="desdeSocket">true: el metodo fue llamado desde el socket, false: no fue llamado desde el socket, valor default: false</param>
        public void AbrirConexion()
        {
            try
            {
                accesoDatos = new MySqlClient();
                accesoDatos.CadenaConexion = this.ObtenerCadenaConexion();
                accesoDatos.AbrirConexion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Cierra la conexión a la base de datos
        /// </summary>
        public void CerrarConexion()
        {
            try
            {
                if (accesoDatos != null)
                {
                    accesoDatos.CerrarConexion();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Obtiene la cadena de conexion a la base de datos
        /// </summary>
        /// <returns>Cadena de cionexión a la base de tatos </returns>
        public string ObtenerCadenaConexion()
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                if (string.IsNullOrEmpty(CadenaConexion.cadenaConexion))
                {
                    utileria = new Utilerias.Utilerias();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                    CadenaConexion.cadenaConexion = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL02"]);
                }
                return CadenaConexion.cadenaConexion;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                utileria = null;
            }
        }

        #endregion
    }
}
