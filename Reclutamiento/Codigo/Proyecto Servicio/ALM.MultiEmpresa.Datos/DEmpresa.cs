using ALM.ServicioAdminEmpresas.Entidades;
using MySql.Data.MySqlClient;
using System.Data;

namespace ALM.ServicioAdminEmpresas.Datos
{
    public class DEmpresa : Conexion
    {
        public void ValidarEmpresa(ref EValidarEmpresa validar)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPValidarEmpresa");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", validar.ProductKey_Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", validar.ProductKey_RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pOrigen", (int)validar.Origen));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pUsuarios", validar.Usuarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClientes", validar.Clientes));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroRegistros", validar.Registros));

                dt = accesoDatos.CargarTabla();

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (int.Parse(dt.Rows[0]["Valido"].ToString()) == 1)
                    {
                        validar.Mensaje = dt.Rows[0]["Valor"].ToString() + validar.FechaLlamada.ToString();
                        validar.CodIncidencia = "0";
                    }
                    else
                    {
                        validar.CodIncidencia = dt.Rows[0]["Valor"].ToString();
                    }
                }
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ValidarEmpresaSuperUsuario(ref EValidarEmpresa validar)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPValidarEmpresaSuperUsuario");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", validar.ProductKey_Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", validar.ProductKey_RFC));

                dt = accesoDatos.CargarTabla();

                if (dt != null && dt.Rows.Count > 0)
                {
                    validar.Mensaje = dt.Rows[0]["Valor"].ToString() + validar.FechaLlamada.ToString();
                    validar.CodIncidencia = "0";
                }
                else
                {
                    validar.CodIncidencia = null;
                }
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void ActualizarCodigoSuperAdministrador(ref EValidarEmpresa validar)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActualizarCodigoSuperAdministrador");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", validar.ProductKey_Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", validar.ProductKey_RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCodigoSuperAdministrador", validar.CodigoSuperAdministrador));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public bool LimpiarCodigoSuperAdministrador(ref EValidarEmpresa validar)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPLimpiarCodigoSuperAdministrador");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", validar.ProductKey_Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", validar.ProductKey_RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCodigoSuperAdministrador", validar.CodigoSuperAdministrador));

                dt = accesoDatos.CargarTabla();

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (int.Parse(dt.Rows[0]["Resultado"].ToString()) == 1)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                return false;
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