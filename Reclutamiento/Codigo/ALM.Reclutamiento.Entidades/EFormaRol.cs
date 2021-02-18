using System;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EFormaRol
    {
        public int IdForma { get; set; }
        public int IdEmpresa { get; set; }
        public int IdRol { get; set; }
        public Int64 Privilegio { get; set; }
    }
}
