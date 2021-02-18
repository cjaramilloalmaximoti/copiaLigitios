using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EProspectoCaracteristica
    {
        public int IdProspectoCaracteristica { get; set; }
        public int IdCaracteristicaParticular { get; set; }
        public int IdProspecto { get; set; }
        public int IdCategoria { get; set; }
        public int IdEmpresa { get; set; }
        public string Categoria { get; set; }
        public string Caracteristica { get; set; }
        public string Control { get; set; }
        public string FormatoControl { get; set; }
        public int? NumeroDecimales { get; set; }
        public string Valor { get; set; }
        public string IdsCategorias { get; set; }
        public bool Requerido { get; set; }

        public string ValorColumna { get; set; }
        public string NombreControl
        {
            get { return "Ctrl" + IdCaracteristicaParticular.ToString(); }
        }
    }
}
