using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NFormaPermiso
    {
        public List<EFormaPermiso> Obtener(int idForma, int idEmpresa)
        {
            return new DFormaPermiso().Obtener(idForma, idEmpresa);
        }

        public void Actualizar(List<EFormaPermiso> listformaPermiso, int idIsuarioLog, int idEmpresa)
        {
            new DFormaPermiso().Actualizar(listformaPermiso, idIsuarioLog, idEmpresa);
        }
    }
}