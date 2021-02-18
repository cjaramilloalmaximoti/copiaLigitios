using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text;
using System.Net;
using System.IO;

namespace ALM.Reclutamiento.Negocio
{
    public class NReferenciaLaboral
    {
        public List<EReferenciaLaboral> ObtenerReferenciaLaboralIdProspecto(EReferenciaLaboral referencia)
        {
            return new DReferenciaLaboral().ObtenerReferenciaLaboralIdProspecto(referencia);
        }

        public int insertarReferenciaLaboral(EReferenciaLaboral referencia, int idUsuarioLog)
        {
            return new DReferenciaLaboral().InsertarReferenciaLaboral(referencia, idUsuarioLog);
        }

        public void ActualizarReferenciaLaboral(EReferenciaLaboral referencia, int idUsuarioLog)
        {
            new DReferenciaLaboral().ActualizarReferenciaLaboral(referencia, idUsuarioLog);
        }
    }
}
