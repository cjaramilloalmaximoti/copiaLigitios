using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades
{
    public class EClaseApoyoValidacion
    {
        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        public string Texto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        public int IdRequerido { get; set; }
    }
}
