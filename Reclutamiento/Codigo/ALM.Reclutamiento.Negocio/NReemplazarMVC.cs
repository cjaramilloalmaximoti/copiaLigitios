using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NReemplazarMVC
    {
        public List<EReemplazarMVC> ObtenerReemplazarMVC()
        {
            return new DReemplazarMVC().ObtenerReemplazarMVC();
        }
    }
}
