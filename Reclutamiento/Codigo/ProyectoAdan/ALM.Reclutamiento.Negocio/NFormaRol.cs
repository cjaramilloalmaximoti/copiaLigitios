using ALM.Empresa.Datos;
using ALM.Empresa.Entidades;

namespace ALM.Empresa.Negocio
{
    public class NFormaRol
    {
        public int Insertar(EFormaRol parametro)
        {
            return new DFormaRol().Insertar(parametro);
        }
    }
}
