using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ECiudad
    {
        public int IdCiudad { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Ciudad")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Ciudad")]
        public string Clave_Ciudad { get; set; }
        public string Clave_Estado { get; set; }
        public int Estatus { get; set; }
        public int IdEstado { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }
        public int IdNacionalidad { get; set; }
    }
}
