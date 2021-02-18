using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;

namespace ALM.Reclutamiento.Negocio
{
    public class NFormaRol
    {
        public int Insertar(EFormaRol parametro)
        {
            return new DFormaRol().Insertar(parametro);
        }
    }
}
