using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.ServicioAdminEmpresas.Entidades
{
    public class EParametro
    {
        public Int16 IdParametro { get; set; }

        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        public string Valor { get; set; }
        
        public UInt32 EsActivo { get; set; }

        public UInt32 EsSensitivo { get; set; }
    }
}
