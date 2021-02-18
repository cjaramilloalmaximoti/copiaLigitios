using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.ServicioAdminEmpresas.Entidades
{
    public class ESuperAdministrador
    {
        public int IdAdministrador { get; set; }
        public string Dominio { get; set; }
        public string Login { get; set; }
        public string Contraseña { get; set; }
        public string Email { get; set; }
    }
}
