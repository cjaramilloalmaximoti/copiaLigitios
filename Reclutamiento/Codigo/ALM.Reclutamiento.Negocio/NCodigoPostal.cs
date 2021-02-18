using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;

namespace ALM.Reclutamiento.Negocio
{
    public class NCodigoPostal
    {
        public List<EPais> ObtenerPaises(string nombre, int activo)
        {
            return new DCodigoPostal().ObtenerPaises(nombre, activo);
        }
        
        public void CargarCodigosPostales(XmlDocument xml, string pais, int idUsuario)
        {

            string lstEstados = "insert into Estado values";
            string lstCiudades = "insert into Ciudad values";
            string lstTipoAsentamientos = "insert into tipoasentamiento values";

            try
            {
                XmlNodeList nodes = xml.GetElementsByTagName("table");

                foreach (XmlNode xn in nodes)
                {

                    if (!lstEstados.Contains(xn["c_estado"].InnerText + "','" + xn["d_estado"].InnerText))
                    {
                        if (lstEstados == "insert into Estado values")
                        {
                            lstEstados = lstEstados + "('" + xn["c_estado"].InnerText + "','" + xn["d_estado"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                        else
                        {

                            lstEstados = lstEstados + ",('" + xn["c_estado"].InnerText + "','" + xn["d_estado"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                    }


                    if (!lstCiudades.Contains(xn["c_mnpio"].InnerText + "','" + xn["D_mnpio"].InnerText + "','" + xn["c_estado"].InnerText))
                    {
                        if (lstCiudades == "insert into Ciudad values")
                        {
                            lstCiudades = lstCiudades + "('" + xn["c_mnpio"].InnerText + "','" + xn["D_mnpio"].InnerText + "','" + xn["c_estado"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                        else
                        {
                            lstCiudades = lstCiudades + ",('" + xn["c_mnpio"].InnerText + "','" + xn["D_mnpio"].InnerText + "','" + xn["c_estado"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                    }


                    if (!lstTipoAsentamientos.Contains(xn["c_tipo_asenta"].InnerText + "','" + xn["d_tipo_asenta"].InnerText))
                    {
                        if (lstTipoAsentamientos == "insert into tipoasentamiento values")
                        {
                            lstTipoAsentamientos = lstTipoAsentamientos + "('" + xn["c_tipo_asenta"].InnerText + "','" + xn["d_tipo_asenta"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                        else
                        {
                            lstTipoAsentamientos = lstTipoAsentamientos + ",('" + xn["c_tipo_asenta"].InnerText + "','" + xn["d_tipo_asenta"].InnerText + "','" + pais + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        }
                    }

                }

                

                new DCodigoPostal().DeleteTablasCP(pais);
                new DCodigoPostal().InsEstados(lstEstados + ";");
                new DCodigoPostal().InsCiudades(lstCiudades + ";");
                new DCodigoPostal().InsTipoAsentamiento(lstTipoAsentamientos + ";");
                
            }
            finally
            {
                lstEstados = null;
                lstCiudades = null;
                lstTipoAsentamientos = null;
            }
        }
        
        public void CargarCodigosPostalesColonias(XmlDocument xmlCol, string pais, int idUsuario)
        {

            string lstColonias = "insert into colonia values";

            try
            {


                XmlNodeList nodes = xmlCol.GetElementsByTagName("table");
                bool inicio = false;
                int contador = 0;
                foreach (XmlNode xn in nodes)
                {
                    contador++;
                    if (!inicio)
                    {
                        lstColonias = lstColonias + "('" + xn["id_asenta_cpcons"].InnerText + "','" + xn["d_asenta"].InnerText + "','" + xn["d_codigo"].InnerText + "','" + pais + "','" + xn["c_estado"].InnerText + "','" + xn["c_mnpio"].InnerText + "','" + xn["c_tipo_asenta"].InnerText + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                        inicio = true;
                    }
                    else
                    {
                        lstColonias = lstColonias + ",('" + xn["id_asenta_cpcons"].InnerText + "','" + xn["d_asenta"].InnerText + "','" + xn["d_codigo"].InnerText + "','" + pais + "','" + xn["c_estado"].InnerText + "','" + xn["c_mnpio"].InnerText + "','" + xn["c_tipo_asenta"].InnerText + "'," + idUsuario + ",now()," + idUsuario + ",now()," + 1 + ")";
                    }


                    if (contador == 500)
                    {
                        new DCodigoPostal().InsColonias(lstColonias + ";");
                        contador = 0;
                        lstColonias = "insert into colonia values";
                        inicio = false;
                    }

                }

                if (contador > 0)
                {
                    new DCodigoPostal().InsColonias(lstColonias + ";");

                    new DCodigoPostal().InsFechaUltimaCarga(pais, idUsuario);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                lstColonias = null;
            }
        }

        public List<ECiudad> ObtenerCiudadTexto(string estadoClave, string ciudadClave)
        {
            return new DCodigoPostal().ObtenerCiudadTexto(estadoClave, ciudadClave);
        }

        public List<EColonia> ObtenerColonias(string claveCiudad, string claveEstado, string nombre, int activo)
        {
            return new DCodigoPostal().ObtenerColonias(claveCiudad, claveEstado, nombre, activo);
        }

        public List<EColonia> buscarCP(string cp)
        {
            return new DCodigoPostal().buscarCP(cp);
        }

        public string ObtenerFechaUltimaCarga(string pais, int idUsuario)
        {
            return new DCodigoPostal().ObtenerFechaUltimaCarga(pais);
        }

        public List<EEstados> Obtenerestados(string clavePais, int activo)
        {
            return new DCodigoPostal().ObtenerEstados(clavePais, activo);
        }

        public List<ECiudad> ObtenerCiudades(string claveEstado, string nombre, int activo)
        {
            return new DCodigoPostal().ObtenerCiudades(claveEstado, nombre, activo);
        }       
    }
}
