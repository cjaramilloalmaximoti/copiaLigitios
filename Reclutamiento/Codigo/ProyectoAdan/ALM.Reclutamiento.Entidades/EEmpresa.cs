using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades
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
        [StringLength(256)]
        [DisplayName("ProductKey")]
        public string ProductKey { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(30)]
        [DisplayName("Administrador")]
        public string Administrador { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Contraseña")]
        public string Contraseña { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Comercial")]
        public string NombreComercial { get; set; }
        
        [StringLength(200)]
        [DisplayName("Logo")]
        public string RutaLogo { get; set; }

        [StringLength(200, ErrorMessage = Constante.TamanioCampo)]
        [RegularExpression(Constante.ArchivoLogo, ErrorMessage = Constante.FormatoIncorrectoArchivoLogo)]
        public string RutaLogo_2 { get; set; }

        public object Clone()
        {
            return this.MemberwiseClone();
        }

    }
}
