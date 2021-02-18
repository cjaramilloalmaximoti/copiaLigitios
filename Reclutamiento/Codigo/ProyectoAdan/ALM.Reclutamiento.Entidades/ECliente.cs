using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades {
    [Serializable]
    public class ECliente {
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

        [StringLength(250)]
        [DisplayName("Dirección")]
        public string Direccion { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Contacto Nombre")]
        public string Contacto_Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Contacto C. Electrónico")]
        public string Contacto_Email { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [DisplayName("Contacto tel.")]
        public string Contacto_Telefono { get; set; }

        [StringLength(128)]
        [DisplayName("Comentarios")]
        public string Comentarios { get; set; }

        public bool Activo { get; set; }
    }
}
