using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EPais
    {
        public string Clave_Pais { get; set; }
        public string Nombre { get; set; }
        public int Estatus { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }
    }
}
