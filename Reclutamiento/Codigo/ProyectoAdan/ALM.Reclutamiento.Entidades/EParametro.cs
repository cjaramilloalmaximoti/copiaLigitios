using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades
{
    public class EParametro
    {
        public Int16 IdParametro { get; set; }

        public int IdEmpresa{ get; set; }

        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        public string Valor { get; set; }
        
        public bool EsActivo { get; set; }

        public bool EsSensitivo { get; set; }
    }
}
