using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades
{
    [Serializable]
    public class ERol
    {
        public int IdRol { get; set; }

        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = Constante.CampoRequerido)]
        [StringLength(50, ErrorMessage = Constante.TamanioCampo)]
        public string NombreRol { get; set; }

        public bool Estatus { get; set; }
    }
}
