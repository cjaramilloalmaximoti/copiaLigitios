using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Empresa.Entidades
{
    [Serializable]
    public class ESubCatalogo
    {
        public int IdEmpresa { get; set; }

        [DisplayName("IdCatalogo")]
        public int IdSubCatalogo { get; set; }
        
        [Required(ErrorMessage = "Dato requerido")]
        public int IdCatalogo { get; set; }
        
        public int IdTipoCatalogo { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(12, ErrorMessage = Constante.TamanioCampo)]
        [DisplayName("Clave")]
        public string Clave { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64, ErrorMessage = Constante.TamanioCampo)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [StringLength(256, ErrorMessage = Constante.TamanioCampo)]
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }        


        [DisplayName("CatalogoPadre")]
        public string Catalogo { get; set; }


        public bool EsActivo { get; set; }

        
        public int EsActivoFiltro { get; set; }

    }
}