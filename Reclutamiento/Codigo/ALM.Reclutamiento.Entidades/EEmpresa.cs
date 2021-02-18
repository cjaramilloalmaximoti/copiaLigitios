using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EEmpresa : ICloneable
    {
        public int IdEmpresa { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Dominio")]
        public string Dominio { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(15)]
        [DisplayName("RFC")]
        public string RFC { get; set; }

        [StringLength(256)]
        public string ProductKey { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(30)]
        [DisplayName("Administrador")]
        public string Administrador { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Contraseña")]
        public string Contrasenia { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Comercial")]
        public string NombreComercial { get; set; }

        [StringLength(200)]
        [DisplayName("Logo")]
        public string Logo { get; set; }

        [StringLength(200)]
        [DisplayName("Email")]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        public string Email { get; set; }

        //datos nuevos *********************************************
        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Representante")]

        public string NombreRepresentante { get; set; }
        
        [StringLength(100)]
        [DisplayName("Email Representante")]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        public string EmailRepresentante { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(15)]
        [DisplayName("Telefono Representante")]
        public string TelefonoRepresentante { get; set; }

        
        [StringLength(250)]
        [DisplayName("Observaciones")]
        public string Observaciones { get; set; }

        
        [StringLength(100)]
        [DisplayName("Nombre Otro Contacto")]
        public string NombreOtroContacto { get; set; }

        
        [StringLength(100)]
        [DisplayName("Email Otro Contacto")]
        [EmailAddress(ErrorMessage = "Formato incorrecto")]
        public string EmailOtroContacto { get; set; }

        
        [StringLength(15)]
        [DisplayName("Telefono Otro Contacto")]
        public string TelefonoOtroContacto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(10)]
        [DisplayName("Es Activo")]
        public int EsActivo { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(10)]
        [DisplayName("Es Vigente")]
        public int EsVigente { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Numero Usuarios")]
        public int NumeroUsuarios { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Numero Clientes")]
        public int NumeroClientes { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Numero Registros")]
        public int NumeroRegistros { get; set; }
        //**********************************************************

        [StringLength(200, ErrorMessage = Constante.TamanioCampo)]
        [RegularExpression(Constante.ArchivoLogo, ErrorMessage = Constante.FormatoIncorrectoArchivoLogo)]
        public string RutaLogo_2 { get; set; }

        public int Estatus { get; set; }
        public string Activo { get; set; }

        public object Clone()
        {
            return this.MemberwiseClone();
        }

    }
}
