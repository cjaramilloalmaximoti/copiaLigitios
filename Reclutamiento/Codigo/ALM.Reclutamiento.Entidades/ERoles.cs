using System;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class ERoles
    {
        public int IdRol { get; set; }
        public string NombreRol { get; set; }
        public bool Chequeado { get; set; }
    }
}
