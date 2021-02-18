using System;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ERolUsuario
    {
        public int IdRol { get; set; }
        public string NombreRol { get; set; }
        public Int64 Seleccionado { get; set; }
    }
}