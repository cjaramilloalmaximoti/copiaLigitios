using System;

namespace ALM.Empresa.Entidades
{
    [Serializable]
    public class ERoles
    {
        public int IdRol { get; set; }
        public string NombreRol { get; set; }
        public bool Chequeado { get; set; }
    }
}
