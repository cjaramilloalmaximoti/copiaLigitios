using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Negocio
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

        public static void EstablecerLstEmpresa()
        {
            EClaseEstatica.LstEmpresa = new NEmpresa().ObtenerEmpresas();
        }

        public static void EstablecerRutaPublicado(string ruta)
        {
            EClaseEstatica.RutaPublicado = ruta.EndsWith(@"\") ? ruta : ruta + @"\";

        }
    }
}
