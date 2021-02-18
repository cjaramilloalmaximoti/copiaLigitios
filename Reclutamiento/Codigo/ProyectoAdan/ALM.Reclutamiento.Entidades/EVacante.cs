using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades {

    [Serializable]
    class EVacante {

        public int IdVacante { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Título")]
        public string Titulo { get; set; }

        [Required]
        [StringLength(1024)]
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }

        [Required]
        [DisplayName("Fecha de Contratación")]
        public DateTime FechaContratacion { get; set; }

        [Required]
        [DisplayName("Número de Vacantes")]
        public int NumeroVacantes { get; set; }

        [Required]
        [DisplayName("Salario")]
        public double Salario { get; set; }

        [Required]
        [DisplayName("Tipo de Contrato")]
        public int IdTipoContrato { get; set; }

        [Required]
        [DisplayName("Tipo de Jornada")]
        public int IdTipoJornada { get; set; }

        [Required]
        [DisplayName("Lugar de Trabajo")]
        public int IdCiudad { get; set; }

        public int Estatus { get; set; }
    }
}
