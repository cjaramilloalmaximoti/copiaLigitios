using System;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EFormas
    {
        private bool yaPintadoEnMenu = false;
        public int IdForma { get; set; }
        public string ClaveCodigo { get; set; }
        public string Nombre { get; set; }
        public bool EsOpcionMenu { get; set; }
        public bool Estatus { get; set; }
        public int IdFormaPadre { get; set; }
        public string TextoLink { get; set; }
        public string Accion { get; set; }
        public string Controlador { get; set; }
        public bool EsDropdown { get; set; }
        public Int64 Privilegios { get; set; }
        public int Principal { get; set; }

        public bool YaPintadoEnMenu
        {
            get { return yaPintadoEnMenu; }
            set { yaPintadoEnMenu = value; }
        }
        public int IdFormaOrdenada { get; set; }
        public int IdTipoCatalogo { get; set; }
        public string Catalogo { get; set; }
        public string SubCatalogo { get; set; }
        public string Descripcion { get; set; } //Prop
    }
}