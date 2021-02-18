using System;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EFormaPermiso
    {
        public int IdForma { get; set; }
        public int IdPermiso { get; set; }
        public int IdEmpresa { get; set; }
        public string Permiso { get; set; }
        public string NombrePermiso { get; set; }
        public string Nombre { get; set; }
        public Int64 Privilegio { get; set; }
    }
}