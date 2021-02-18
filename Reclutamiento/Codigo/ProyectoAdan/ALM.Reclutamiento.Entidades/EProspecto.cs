using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace ALM.Empresa.Entidades {

    [Serializable]
    class EProspecto {

        public int IdProspecto { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Apellidos")]
        public string Apellidos { get; set; }

        [Required]
        [StringLength(255)]
        [DisplayName("Dirección")]
        public string Direccion { get; set; }

        [Required]
        [DisplayName("Fecha de Nacimiento")]
        public DateTime FechaNacimiento { get; set; }

        [Required]
        [StringLength(13)]
        [DisplayName("RFC")]
        public string RFC { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Correo Electrónico")]
        public string CorreoElectronico { get; set; }

        [Required]
        [StringLength(10)]
        [DisplayName("Teléfono Móvil")]
        public string TelefonoMovil { get; set; }

        [StringLength(10)]
        [DisplayName("Otro Teléfono")]
        public string TelefonoOtro { get; set; }

        [Required]
        [StringLength(100)]
        [DisplayName("Sexo")]
        public int Sexo { get; set; }

        [Required]
        [DisplayName("Colonia")]
        public int IdColonia { get; set; }

        [Required]
        [DisplayName("Nacionalidad")]
        public int IdNacionalidad { get; set; }

        [Required]
        [DisplayName("Estado Civil")]
        public int IdEstadoCivil { get; set; }

        [Required]
        [DisplayName("Profesión")]
        public int IdProfesion { get; set; }

        public int Estatus { get; set; }
    }
}
