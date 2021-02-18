using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EReferenciaLaboral
    {
        public int IdReferencia { get; set; }
        public int IdProspecto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150)]
        [DisplayName("Empresa")]
        public string Empresa { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150)]
        [DisplayName("Domicilio")]
        public string Domicilio { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Contacto")]
        public string Contacto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Contacto E-mail")]
        public string Contacto_Email { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Contacto Tel.")]
        public string Contacto_Telefono { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150)]
        [DisplayName("Motivo Separación")]
        public string MotivoSeparacion { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150)]
        [DisplayName("Puesto")]
        public string Puesto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Tiempo Laborado")]
        public string TiempoLaborado { get; set; }

        [StringLength(250)]
        [DisplayName("Comentario")]
        public string Comentario { get; set; }

        [DisplayName("Comentario")]
        public bool Estatus { get; set; }

        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }
        public int IdEmpresa { get; set; }
    }
}
