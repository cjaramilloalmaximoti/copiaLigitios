using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    public class EMapeoColumna
    {
        public int IdMapeoColumnaSegmento { get; set; }
        public int IdSegmento { get; set; }
        public int IdEmpresa { get; set; }
        public int IdColumnaDefaultSegmento { get; set; }
        public int? IdColumnaSegmento { get; set; }
    }
}
