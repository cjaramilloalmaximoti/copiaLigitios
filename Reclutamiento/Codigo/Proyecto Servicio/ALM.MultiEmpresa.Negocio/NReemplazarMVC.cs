using ALM.ServicioAdminEmpresas.Datos;
using ALM.ServicioAdminEmpresas.Entidades;
using System.Collections.Generic;

namespace ALM.ServicioAdminEmpresas.Negocio
{
    public class NReemplazarMVC
    {
        public List<EReemplazarMVC> ObtenerReemplazarMVC()
        {
            return new DReemplazarMVC().ObtenerReemplazarMVC();
        }
    }
}
