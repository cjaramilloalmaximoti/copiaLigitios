using ALM.ServicioAdminEmpresas.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.ServicioAdminEmpresas.Negocio
{
    public static class NClaseEstatica
    {
        public static void EstablecerLstReemplazarMVC()
        {
            EClaseEstatica.LstReemplazarMVC = new NReemplazarMVC().ObtenerReemplazarMVC();
        }

        public static void EstablecerLstParametros()
        {
            EClaseEstatica.LstParametro = new NParametro().ObtenerParametros();
        }
    }
}
