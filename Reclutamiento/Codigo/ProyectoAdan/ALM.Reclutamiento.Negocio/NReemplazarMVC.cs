using ALM.Empresa.Datos;
using ALM.Empresa.Entidades;
using System.Collections.Generic;

namespace ALM.Empresa.Negocio
{
    public class NReemplazarMVC
    {
        public List<EReemplazarMVC> ObtenerReemplazarMVC()
        {
            return new DReemplazarMVC().ObtenerReemplazarMVC();
        }
    }
}
