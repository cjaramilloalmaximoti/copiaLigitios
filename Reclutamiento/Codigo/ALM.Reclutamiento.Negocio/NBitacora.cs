using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NBitacora
    {
        public List<EBitacora> ObtenerBitacoraIdProspecto(int idProspecto)
        {
            return new DBitacora().ObtenerBitacoraIdProspecto(idProspecto);
        }

        public int insertarBitacora(EBitacora bitacora)
        {
            return new DBitacora().InsertarBitacora(bitacora);
        }
    }
}
