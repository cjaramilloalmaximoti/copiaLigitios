using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Empresa.Entidades
{
    [Serializable]
    public class EUsuario
    {
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Empresa")]
        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Usuario")]
        public string Login { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Nombre completo")]
        public string NombreCompleto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Correo electrónico")]
        public string CorreoElectronico { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(16)]
        [RegularExpression(@"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$", ErrorMessage = "La contraseña debe tener entre 8 y 16 Caracteres. Como mínimo, una mayúscula, una minúscula, un carácter y un número")]
        [DisplayName("Contraseña")]
        public string Contrasenia { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [Compare("Contrasenia", ErrorMessage = "La contraseña no coindice")]
        [RegularExpression(@"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$", ErrorMessage = "La contraseña debe tener entre 8 y 16 Caracteres. Como mínimo, una mayúscula, una minúscula, un carácter y un número")]
        [DisplayName("Confirmar contraseña")]
        public string ConfirmarContrasenia { get; set; }

        [DisplayName("¿Es activo?")]
        public bool Activo { get; set; }

        public string CodigoRecuperaContrasenia { get; set; }

        [StringLength(512)]
        [DisplayName("Comentarios")]
        public string Comentarios { get; set; }

        [DisplayName("Institución")]
        public int IdInstitucion { get; set; }

        public string Dominio { get; set; }

        public string CodigoSuperAdministrador { get; set; }

        public bool EsSuperAdministrador { get; set; }

        public bool EsAdministrador { get; set; }

        [StringLength(250)]
        [DisplayName("Domicilio")]
        public string Domicilio { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(32)]
        [DisplayName("Teléfono")]
        public string Telefono { get; set; }

        [StringLength(100)]
        [DisplayName("Referencia")]
        public string Referencia { get; set; }

        [StringLength(32)]
        [DisplayName("Referencia tel.")]
        public string ReferenciaTelefono { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Fecha nacimiento")]
        public DateTime FechaNacimiento { get; set; }

        private string fechaNacimientoString;

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Fecha nacimiento")]
        public string FechaNacimientoString { get { return FechaNacimiento.ToString("dd/MM/yyyy"); } set { fechaNacimientoString = value; FechaNacimiento = DateTime.Parse(value); } }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Contraseña")]
        public string ContraseniaLog { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        [DisplayName("Usuario")]
        public string LoginLog { get; set; }

        /// <summary>
        /// Constructor predeterminado
        /// </summary>
        ///
        public EUsuario()
        {
        }
    }
}