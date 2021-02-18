using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NRolUsuario
    {
        public List<ERolUsuario> ObtenerRolUsuario(int idUsuario, int idEmpresa)
        {
            return new DRolUsuario().ObtenerRolUsuario(idUsuario, idEmpresa);
        }

        public void InsertarRolUsuario(int idUsuario, int idRol, int idIsuarioLog, short origenOperacion, int idEmpresa)
        {
            new DRolUsuario().InsertarRolUsuario(idUsuario, idRol, idIsuarioLog, origenOperacion, idEmpresa);
        }

        public void EliminarRolUsuario(int idUsuario, int idRol, int idEmpresa)
        {
            new DRolUsuario().EliminarRolUsuario(idUsuario, idRol, idEmpresa);
        }
    }
}
