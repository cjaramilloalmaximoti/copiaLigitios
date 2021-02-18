using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Negocio
{
    public class NCatalogo
    {
        public int InsertarCatalogo(ECatalogo parametro, int idIsuarioLog)
        {
            return new DCatalogo().InsertarCatalogo(parametro, idIsuarioLog);
        }

        public int Actualizar(ECatalogo parametro, int idIsuarioLog)
        {
            return new DCatalogo().Actualizar(parametro, idIsuarioLog);
        }

        public List<ECatalogo> Listar(ECatalogo parametro)
        {
            return new DCatalogo().Listar(parametro);
        }

        public List<ECatalogo> ObtCatalogoPorNombre(string nombreCatalogo, int idEmpresa)
        {
            return new DCatalogo().ObtCatalogoPorNombre(nombreCatalogo, idEmpresa);
        }

        public List<ECatalogo> ObtCatalogoDelSubCatalogo(int idCatalogo, int idEmpresa)
        {
            return new DCatalogo().ObtCatalogoDelSubCatalogo(idCatalogo, idEmpresa);
        }

        public List<ECatalogo> ObtInfoSubCatalogoPorIdPadre(int idCatalogo, int idTipoCatalogo, int idEmpresa)
        {
            return new DCatalogo().ObtInfoSubCatalogoPorIdPadre(idCatalogo, idTipoCatalogo, idEmpresa);
        }

        public List<ECatalogo> ObtInfoSubCatalogoPorNombrePadre(int idCatalogo, string nombreCatalogo, int idEmpresa)
        {
            return new DCatalogo().ObtInfoSubCatalogoPorNombrePadre(idCatalogo, nombreCatalogo, idEmpresa);
        }

        public List<ECatalogo> ObtCatalogoCtrlCaracteristica(int idCaracteristicaParticular, int idEmpresa)
        {
            return new DCatalogo().ObtCatalogoCtrlCaracteristica(idCaracteristicaParticular, idEmpresa);
        }
    }
}