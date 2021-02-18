using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades {

    [Serializable]
    class ECaracteristicaParticular {

        public int IdCaracteristicaParticular { get; set; }

        [Required]
        [StringLength(10)]
        [DisplayName("Clave")]
        public string Clave { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Descripción")]
        public string Nombre { get; set; }

        [Required]
        [DisplayName("Tipo de Dato")]
        public int IdTipoCampo { get; set; }

        public int Estatus { get; set; }
    }
}
