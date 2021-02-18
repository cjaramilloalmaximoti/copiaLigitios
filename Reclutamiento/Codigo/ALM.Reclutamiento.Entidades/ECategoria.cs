using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ECategoria
    {
        public int IdCategoria { get; set; }

        [StringLength(100)]
        public string Nombre { get; set; }

        public DateTime FechaCreacion { get; set; }

        public int IdUsuarioCreacion { get; set; }

        public DateTime FechaModificacion { get; set; }

        public int IdUsuarioUltimoModifico { get; set; }

        public sbyte Estatus { get; set; }

        public int IdEmpresa { get; set; }

    }
}
