using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EProspecto 
    {
        public int IdProspecto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Apellidos")]
        public string Apellidos { get; set; }

        public string NombreCompleto { get; set; }
        
        [DisplayName("Fecha Nacimiento")]
        public DateTime? FechaNacimiento { get; set; }


        [StringLength(13, ErrorMessage = Constante.TamanioCampo)]
        public string RFC { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("E-mail")]
        public string Email { get; set; }


        [StringLength(10)]
        [DisplayName("Teléfono Móvil")]
        public string TelefonoMovil { get; set; }


        [StringLength(10)]
        [DisplayName("Teléfono Otro")]
        public string TelefonoOtro { get; set; }

        [DisplayName("Sexo")]
        public int IdSexo { get; set; }


        [StringLength(100)]
        [DisplayName("Dirección")]
        public string Direccion { get; set; }

        public string Clave_Colonia { get; set; }
        public string CP { get; set; }

        [StringLength(250)]
        [DisplayName("Comentario")]
        public string Comentario { get; set; }

        [DisplayName("Salario Inicial $")]
        public float Salario { get; set; }

        [DisplayName("Edad")]
        public Int64 Edad { get; set; }

        [DisplayName("Salario Final $")]
        public float SalarioFinal { get; set; }

        [DisplayName("Ciudad")]
        public int IdCiudad { get; set; }

        [DisplayName("Estado Civil")]
        public int IdEstadoCivil { get; set; }

        [DisplayName("Escolaridad")]
        public int IdEscolaridad { get; set; }

        [StringLength(200)]
        [DisplayName("Foto")]
        public string Foto { get; set; }

        [StringLength(200, ErrorMessage = Constante.TamanioCampo)]
        [RegularExpression(Constante.ArchivoLogo, ErrorMessage = Constante.FormatoIncorrectoArchivoLogo)]
        public string Foto_2 { get; set; }

        public int IdNivelIngles { get; set; }

        [StringLength(50)]
        [DisplayName("Nivel de Inglés")]
        public string NivelIngles { get; set; }

        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }

        [DisplayName("Es Activo")]
        public bool Estatus { get; set; }

        public int IdEmpresa { get; set; }

        [DisplayName("Última Fecha de Contacto:")]
        public DateTime? FechaContacto { get; set; }
        public DateTime UltimaFecha { get; set; }
        public string NombreSexo { get; set; }
        public string NombreCiudad { get; set; }
        public string NombreEscolaridad { get; set; }
        public string NombreEstadoCivil { get; set; }
        public bool Finalista { get; set; }
        public int Invitaciones { get; set; }
        public int Seleccionado { get; set; }
        public string Calle { get; set; }
        public string CiudadEstado { get; set; }
    }
}
