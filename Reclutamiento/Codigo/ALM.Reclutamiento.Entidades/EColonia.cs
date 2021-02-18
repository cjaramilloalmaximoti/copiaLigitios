using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace ALM.Reclutamiento.Entidades
{
    public class EColonia
    {
        public int IdColonia { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Nombre Colonia")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Dato requerido")]
        [StringLength(100)]
        [DisplayName("Codigo Postal")]
        public string CodigoPostal { get; set; }
        public string Clave_Colonia { get; set; }
        public string Clave_Ciudad { get; set; }
        public string Clave_Estado { get; set; }
        public string Clave_Asentamiento { get; set; }
        public int Estatus { get; set; }

        public int IdCiudad { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaModificacion { get; set; }


        public SelectList NombreList { get; set; }
        public SelectList IdList { get; set; }
        public SelectList ColoniaList { get; set; }

        public EColonia()
        {
            this.NombreList = new SelectList(new List<string>());

        }
    }
}
