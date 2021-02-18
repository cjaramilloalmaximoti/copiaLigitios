using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ECatalogosSubCatalogo
    {
        public int IdCatalogo { get; set; }
        public string NombreLabel { get; set; }
        public string NombreControl { get; set; }
        public string NombreControlPadre { get; set; }
        public int IdSeleccion { get; set; }
        public int IdTipoCatalogo { get; set; }
    }
}
