using ALM.ServicioAdminEmpresas.Datos;
using ALM.ServicioAdminEmpresas.Entidades;
using System.Collections.Generic;

namespace ALM.ServicioAdminEmpresas.Negocio
{
    public class NParametro
    {
        public List<EParametro> ObtenerParametros()
        {
            return new DParametro().ObtenerParametros();
        }
    }
}
