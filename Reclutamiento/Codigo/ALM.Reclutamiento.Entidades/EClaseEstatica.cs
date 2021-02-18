using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    public static class EClaseEstatica
    {
        public static List<EReemplazarMVC> LstReemplazarMVC { get; set; }

        public static List<EParametro> LstParametro { get; set; }

        public static List<EEmpresa> LstEmpresa { get; set; }

        public static string RutaPublicado { get; set; }
    }
}
