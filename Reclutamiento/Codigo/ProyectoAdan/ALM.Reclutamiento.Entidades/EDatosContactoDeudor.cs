using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Empresa.Entidades
{
    [Serializable]
    public class EDatosContactoDeudor
    {
        public int IdDatosContactoDeudor { get; set; }
        public int IdDeudor { get; set; }
        public int IdEmpresa { get; set; }

        [DisplayName("Validado")]
        public bool Validado { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [DisplayName("Teléfono")]
        public string Telefono { get; set; }

        [StringLength(50)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Correo Electrónico")]
        public string CorreoElectronico { get; set; }

        [StringLength(50)]
        [DisplayName("Calle y Num")]
        public string CalleNum { get; set; }

        [StringLength(50)]
        [DisplayName("Colonia")]
        public string Colonia { get; set; }

        [StringLength(50)]
        [DisplayName("Ciudad")]
        public string Ciudad { get; set; }

        [StringLength(50)]
        [DisplayName("Estado")]
        public string Estado { get; set; }

        [DisplayName("Comentarios")]
        [StringLength(512)]
        public string Comentarios { get; set; }

        public int Consecutivo { get; set; }
    }
}
