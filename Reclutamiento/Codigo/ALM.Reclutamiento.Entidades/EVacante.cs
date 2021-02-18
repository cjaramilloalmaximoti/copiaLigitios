using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EVacante
    {
        public int IdVacante { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Título")]
        public string Titulo { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(400)]
        [DisplayName("Descripción")]
        public string Descripcion { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Sub Título")]
        public string SubTitulo { get; set; }

        [DisplayName("Cliente")]
        public string Cliente { get; set; }

        [DisplayName("Fecha de Contratación")]
        public DateTime FechaContratacion { get; set; }

        [DisplayName("Número de Vacantes")]
        public int NumeroVacantes { get; set; }

        [DisplayName("Salario $")]
        public double Salario { get; set; }

        [DisplayName("Tipo de Contrato")]
        public int IdTipoContrato { get; set; }

        [DisplayName("Cliente")]
        public int idCliente { get; set; }

        [DisplayName("Fuente de la Publicacion")]
        public int IdFuentePublicacion { get; set; }

        [DisplayName("Tipo de Jornada")]
        public int IdTipoJornada { get; set; }

        [DisplayName("Ciudad")]
        [Required(ErrorMessage ="Dato Requerido")]
        public string IdCiudad { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }

        [DisplayName("Fase")]
        public int Fase { get; set; }

        [DisplayName("Comentarios")]
        public string Comentarios { get; set; }

        [DisplayName("Fecha de Entrega")]
        public DateTime FechaEntrega { get; set; }

        public int IdUsuarioUltimoModifico { get; set; }
        public DateTime FechaModificacion { get; set; }
        public sbyte Estatus { get; set; }
        public string Fuentes { get; set; }
        public int IdEmpresa { get; set; }
    }
}
