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
    public class ECatalogo
    {
        public int IdCatalogo { get; set; }
        public int IdEmpresa { get; set; }
        public short IdTipoCatalogo { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(12, ErrorMessage = Constante.TamanioCampo)]
        [DisplayName("Clave")]
        public string Clave { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(64)]
        [DisplayName("Nombre")]
        public string Nombre { get; set; }

        [StringLength(256)]
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }

        public bool EsActivo { get; set; }

        public int Estaus { get; set; }

        public string TipoCatalogo { get; set; }


        #region Reference fields

        /// <summary>
        /// Identificador a partir del cual se se buscará en base de datos y se establecerá la identidad.
        /// </summary>
        public string IdReferencia { get; set; }

        /// <summary>
        /// Identificador del Catálogo padre (si el objeto que se va a sincronizar es un Subcatálogo)
        /// </summary>
        public string IdCatalogoPadre { get; set; }

        #endregion
    }
}