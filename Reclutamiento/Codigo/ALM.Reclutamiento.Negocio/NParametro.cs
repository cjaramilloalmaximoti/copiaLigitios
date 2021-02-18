using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NParametro
    {
        public List<EParametro> ObtenerParametros()
        {
            return new DParametro().ObtenerParametros();
        }

        public void Actualizar(EParametro parametro, int idIsuarioLog, short origenOperacion)
        {
            new DParametro().Actualizar(parametro, idIsuarioLog, origenOperacion);
            NClaseEstatica.EstablecerLstParametros();
        }

        public List<EParametro> Listar(EParametro parametro)
        {
            return new DParametro().Listar(parametro);
        }

        public void ActualizarParametroEmpresa(EParametro parametro, int idIsuarioLog, short origenOperacion)
        {
            new DParametro().ActualizarParametroEmpresa(parametro, idIsuarioLog, origenOperacion);
            NClaseEstatica.EstablecerLstParametros();
        }

        public List<EParametro> ListarParametroEmpresa(EParametro parametro)
        {
            return new DParametro().ListarParametroEmpresa(parametro);
        }
    }
}
