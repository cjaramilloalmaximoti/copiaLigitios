using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.ServicioAdminEmpresas.Entidades
{
    public class EValidarEmpresa
    {
        public string Dominio { get; set; }

        public string ProductKey_Dominio { get; set; }

        public string ProductKey_RFC { get; set; }

        public Constante.Origen Origen { get; set; }

        public short Usuarios { get; set; }

        public short Clientes { get; set; }

        public Int64 Registros { get; set; }

        public string ProductKey { get; set; }

        public int FechaLlamada { get; set; }

        public string Mensaje { get; set; }

        public string CodIncidencia { get; set; }

        public string CodigoSuperAdministrador { get; set; }
    }
}
