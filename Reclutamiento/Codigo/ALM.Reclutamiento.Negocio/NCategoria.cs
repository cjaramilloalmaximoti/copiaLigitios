using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Datos;

namespace ALM.Reclutamiento.Negocio
{
     public class NCategoria
    {
        public int InsertarCategoria(ECategoria categoria)
        {
            return new DCategoria().InsertarCategoria(categoria);
        }

        public List<ECategoria> ObtenerCategorias(ECategoria categoria)
        {
            return new DCategoria().obtenerCategorias(categoria);
        }

        public void ActualizarCategoria(ECategoria categoria)
        {
            new DCategoria().ActualizarCategoria(categoria);
        }

        public List<ECategoria> obtenerCategoriasTipo(int empresaid)
        {
            return new DCategoria().obtenerCategoriasTipo(empresaid);
        }
    }
}
