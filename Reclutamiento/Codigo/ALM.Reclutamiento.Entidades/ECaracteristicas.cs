using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
   public class ECaracteristicas
    {
        public int IdCaracteristica { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(200)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(200)]
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }

        public int IdTipo { get; set; }

        [DisplayName("Tipo Control")]
        public string TipoControl { get; set; }

        [DisplayName("Tipo Control")]
        [Required(ErrorMessage = "Dato requerido")]
        public int IdTipoControl { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Aprobada")]
        public int Aprobada { get; set; }

        [StringLength(250)]
        [DisplayName("Comentario")]
        public string Comentario { get; set; }

        [DisplayName("Categoría")]
        public int IdCategoria { get; set; }

        public string NombreCategoria { get; set; }

        public int IdUsuarioCreacion { get; set; }

        public DateTime FechaCreacion { get; set; }

        public int IdUsuarioModificacion { get; set; }

        public DateTime FechaModificacion { get; set; }

        public int IdEmpresa { get; set; }

        public int intEsActivo { get; set; }

        [DisplayName("Es Activo")]
        public bool EsActivo { get; set; }

        public string Email { get; set; }
        public string Usuario { get; set; }
        public string Categorias { get; set; }
        public string Empresa { get; set; }
        public string codigoGenerado { get; set; }

        /*FSALAZAR 04/04/2019 REQ03042019 INI: Se agrega los campos de Formato, NumeroDecimales, 
         valor (del tipo de control) para las características particulares en al módulo de prospectos*/

        public string Formato { get; set; }
        public int NumeroDecimales { get; set; }
        public  string  ValorTipoControl { get; set; }
        //FSALAZAR 04/04/2019 REQ03042019 FIN
    }
}
