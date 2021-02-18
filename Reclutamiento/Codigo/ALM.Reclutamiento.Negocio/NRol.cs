using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NRol
    {
        public List<ERol> Listar(ERol rol)
        {
            return new DRol().Listar(rol);
        }

        public int Insertar(string nombreRol, int idIsuarioLog, short origenOperacion, int idEmpresa)
        {
            return new DRol().Insertar(nombreRol, idIsuarioLog, origenOperacion, idEmpresa);
        }

        public void Actualizar(ERol rol, int idIsuarioLog, short origenOperacion)
        {
            new DRol().Actualizar(rol, idIsuarioLog, origenOperacion);
        }

        public int Eliminar(ERol rol, int idEmpresa)
        {
            return new DRol().Eliminar(rol, idEmpresa);
        }
    }
}