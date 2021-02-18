using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EColumnaSegmento
    {
        public int IdColumnaSegmento { get; set; }
        public int IdSegmento { get; set; }
        public int IdEmpresa { get; set; }
        public string Encabezado { get; set; }
        public string Columna { get; set; }
    }
}
