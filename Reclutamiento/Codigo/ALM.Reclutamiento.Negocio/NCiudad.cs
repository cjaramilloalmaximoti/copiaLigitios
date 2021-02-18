using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text;
using System.Net;
using System.IO;


namespace ALM.Reclutamiento.Negocio
{
    public class NCiudad
    {
        public List<ECiudad> ObtenerCiudades(int activo)
        {
            return new DCIudad().ObtenerCiudades(activo);
        }
    }
}
