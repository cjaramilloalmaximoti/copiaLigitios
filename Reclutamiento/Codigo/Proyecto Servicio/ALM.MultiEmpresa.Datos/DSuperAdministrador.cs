using ALM.ServicioAdminEmpresas.Entidades;
using MySql.Data.MySqlClient;
using System.Data;

namespace ALM.ServicioAdminEmpresas.Datos
{
    public class DSuperAdministrador : Conexion
    {
        public void ValidarSuperUsuario(ref ESuperAdministrador validar)
        {
            Utilerias.Utilerias utileria = null;
            DataTable dt = null;
            try
            {
                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);

                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPValidarSuperUsuario");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", validar.Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pLogin", validar.Login));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", utileria.Cifrar(validar.Contraseña)));

                dt = accesoDatos.CargarTabla();

                if (dt != null && dt.Rows.Count > 0)
                {
                    validar.Email = dt.Rows[0]["Valor"].ToString();
                }
                else
                {
                    validar.Email = null;
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