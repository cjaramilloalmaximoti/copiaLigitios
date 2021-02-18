using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ECliente
    {
        public int IdCliente { get; set; }

        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(13)]
        [DisplayName("RFC")]
        public string RFC { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Razón Social")]
        public string RazonSocial { get; set; }

        [StringLength(64)]
        [DisplayName("Nombre Comercial")]
        public string NombreComercial { get; set; }

        public string Clave_Colonia { get; set; }

        public string CP { get; set; }

        public string Calle { get; set; }

        [StringLength(250)]
        [DisplayName("Dirección")]
        [Required(ErrorMessage = "Dato requerido")]
        public string Direccion { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Empresa E-mail")]
        public string EmpresaCorreo { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [DisplayName("Empresa Tel.")]
        public string EmpresaTelefono { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Contacto Nombre")]
        public string Contacto_Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Contacto E-mail")]
        public string Contacto_Email { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [DisplayName("Contacto Tel.")]
        public string Contacto_Telefono { get; set; }

        [StringLength(128)]
        [DisplayName("Comentarios")]
        public string Comentarios { get; set; }

        [DisplayName("Es Activo")]
        public bool Estatus { get; set; }

        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }

        public string NombreColonia { get; set; }
        public string NombreCiudad { get; set; }
        public string NombreEstado { get; set; }
    }
}
