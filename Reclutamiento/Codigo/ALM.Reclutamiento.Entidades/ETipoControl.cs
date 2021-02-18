using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ETipoControl
    {
        public int IdTipoControl { get; set; }
        public string Nombre { get; set; }
        public short Orden { get; set; }
        public string FormatoControl { get; set; }
        public int? NumeroDecimales { get; set; }
    }
}
