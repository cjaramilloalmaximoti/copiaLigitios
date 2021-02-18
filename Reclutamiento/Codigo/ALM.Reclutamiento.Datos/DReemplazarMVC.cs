using ALM.Reclutamiento.AccesoDatos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;
using System.Data;

namespace ALM.Reclutamiento.Datos
{
    public class DReemplazarMVC : Conexion
    {
        public List<EReemplazarMVC> ObtenerReemplazarMVC()
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPReemplazarMVC");

                return accesoDatos.CargarTabla().DataTableMapToList<EReemplazarMVC>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}