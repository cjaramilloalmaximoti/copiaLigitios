using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EEstados
    {
        public int IdEstado { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Estado")]
        public string Nombre { get; set; }

        public string Clave_Estado { get; set; }
        public string Clave_Pais { get; set; }
        public int Estatus { get; set; }
        public int IdNacionalidad { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }
    }
}
