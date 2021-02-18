using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EDocumentos
    {
        public int Id { get; set; }

        public int IdCliente { get; set; }

        public int IdProspecto { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Documento")]
        public int IdDocumento { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(250)]
        [DisplayName("Url Documento")]
        public string Url { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(200, ErrorMessage = Constante.TamanioCampo)]
        [RegularExpression(Constante.ArchivoLogo, ErrorMessage = Constante.FormatoIncorrectoArchivoLogo)]
        public string Url_2 { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [DisplayName("Estatus")]
        public bool Estatus { get; set; }

        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }
        public int IdEmpresa { get; set; }

        public string descDocumento { get; set; }


        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(150, ErrorMessage = Constante.TamanioCampo)]
        [RegularExpression(Constante.ArchivoDocumento, ErrorMessage = Constante.FormatoIncorrectoDocumento)]
        public string Archivo_2 { get; set; }

        public string NombreOriginal { get; set; }
    }
}
