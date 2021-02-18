using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;

namespace ALM.Reclutamiento.Negocio
{
    public class NProspectoCaracteristica
    {
        public List<EProspectoCaracteristica> ObtenerListadoControlesDinamicos(EProspectoCaracteristica parametro)
        {
            return new DProspectoCaracteristica().ObtenerListadoControlesDinamicos(parametro);
        }

        public List<EProspectoCaracteristica> ObtenerListadoControlesDinamicosVacantes(EProspectoCaracteristica parametro)
        {
            return new DProspectoCaracteristica().ObtenerListadoControlesDinamicosVacantes(parametro);
        }

        public void InsProspectoCaracteristica(List<EProspectoCaracteristica> lstParametro)
        {
            new DProspectoCaracteristica().InsProspectoCaracteristica(lstParametro);
        }

        public void InsVacanteCaracteristica(List<EProspectoCaracteristica> lstParametro)
        {
            new DProspectoCaracteristica().InsVacanteCaracteristica(lstParametro);
        }

        public List<EProspectoCaracteristica> ObtCaracteristicasPorProspecto(EProspectoCaracteristica parametro)
        {
            return new DProspectoCaracteristica().ObtCaracteristicasPorProspecto(parametro);
        }

        public List<EProspectoCaracteristica> ObtCaracteristicasPorVacante(EProspectoCaracteristica parametro)
        {
            return new DProspectoCaracteristica().ObtCaracteristicasPorVacante(parametro);
        }

        public void EliProspectoCaracteristica(int IdProspectoCaracteristica)
        {
            new DProspectoCaracteristica().EliProspectoCaracteristica(IdProspectoCaracteristica);
        }

        public void EliVacanteCaracteristica(int IdVacanteCaracteristica)
        {
            new DProspectoCaracteristica().EliVacanteCaracteristica(IdVacanteCaracteristica);
        }
    }
}
