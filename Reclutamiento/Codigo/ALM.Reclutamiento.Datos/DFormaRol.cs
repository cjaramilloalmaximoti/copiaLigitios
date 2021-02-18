using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Datos
{
    public class DFormaRol : Conexion
    {
        public int Insertar(EFormaRol parametro)
        {
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsFormaRol");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdForma", parametro.IdForma));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdRol", parametro.IdRol));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPrivilegio", parametro.Privilegio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));

                return accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}
