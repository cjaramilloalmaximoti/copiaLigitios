using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NForma
    {
        public List<EFormas> ObtenerListaFormasPorUsuario(int idUsuario, int idEmpresa)
        {
            return new DForma().ObtenerListaFormasPorUsuario(idUsuario, idEmpresa);
        }

        public List<EFormas> ObtenerListaFormasAdministrador(int idEmpresa, bool esSuperAdministrador)
        {
            return new DForma().ObtenerListaFormasAdministrador(idEmpresa, esSuperAdministrador);
        }

        public List<EFormas> ObtenerListaFormasPorRol(int idRol, string nombreForma, int idEmpresa)
        {
            return new DForma().ObtenerListaFormasPorRol(idRol, nombreForma, idEmpresa);
        }

        public List<EFormas> ObtenerListaFormas(int idEmpresa)
        {
            return new DForma().ObtenerListaFormas(idEmpresa);
        }
    }
}