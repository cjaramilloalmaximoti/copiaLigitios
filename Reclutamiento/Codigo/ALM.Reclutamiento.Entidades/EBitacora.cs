using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    public class EBitacora
    {
        [DisplayName("Id Bitacora")]
        public int IdBitacora { get; set; }

        [DisplayName("Id Prospecto")]
        public int IdProspecto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(255)]
        [DisplayName("Comentario")]
        public string Comentario { get; set; }

        [DisplayName("Quien Agrego")]
        public string Quienagrego { get; set; }

        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
    }
}
