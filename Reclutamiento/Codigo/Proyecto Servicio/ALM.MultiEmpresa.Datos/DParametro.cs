using System;
using ALM.ServicioAdminEmpresas.AccesoDatos;
using ALM.ServicioAdminEmpresas.Entidades;
using System.Collections.Generic;
using System.Data;

namespace ALM.ServicioAdminEmpresas.Datos
{
    public class DParametro : Conexion
    {
        public List<EParametro> ObtenerParametros()
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtenerParametros");

                return accesoDatos.CargarTabla().DataTableMapToList<EParametro>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}