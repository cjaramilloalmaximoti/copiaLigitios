using ALM.Empresa.Datos;
using ALM.Empresa.Entidades;
using ALM.Empresa.Utilerias;
using System.Collections.Generic;
using System.IO;

namespace ALM.Empresa.Negocio
{
    public class NSegmento
    {
        /*
        public List<ESegmento> ObtenerSegmentos(int? pIdCartera, int? pIdCliente, int idEmpresa)
        {
            return new DSegmento().ObtenerSegmentos(pIdCartera, pIdCliente, idEmpresa);
        }

        
        public int InsertarSegmento(ESegmento segmento, int idIsuarioLog, byte[] archivo, string ruta)
        {
            List<EColumnaSegmento> lstColumnas = null;
            DSegmento dSegmento = null;
            LeerArchivoSegmento leerArchivoSegmento = null;
            //ruta temporal para guardar el archivo y leer los encabezados
            string rutaTmp = string.Empty;

            try
            {
                rutaTmp = ruta + segmento.IdEmpresa.ToString() + @"\Segmento\Temp\";

                dSegmento = new DSegmento();
                leerArchivoSegmento = new LeerArchivoSegmento();

                if (archivo != null)
                {
                    //Si rutaTmp existe, la elimina con todo su contenido
                    if (Directory.Exists(rutaTmp)) {
                        System.IO.Directory.Delete(rutaTmp, true);
                    }

                    //crea la rutaTmp
                    Directory.CreateDirectory(rutaTmp);
                    File.WriteAllBytes(rutaTmp + segmento.Archivo, archivo);
                    // id temporal para leer los encabezados del archivo
                    int idSegmentoTemp = 0;

                    lstColumnas = leerArchivoSegmento.ObteneEncabezadoExcel(rutaTmp + segmento.Archivo, segmento.IdEmpresa, idSegmentoTemp);
                    segmento.IdSegmento = dSegmento.InsertarSegmento(segmento, idIsuarioLog);
                    ruta = ruta + segmento.IdEmpresa.ToString() + @"\Segmento\" + segmento.IdSegmento + @"\";

                    if (!Directory.Exists(ruta))
                    {
                        System.IO.Directory.CreateDirectory(ruta);
                    }

                    if (File.Exists(rutaTmp + segmento.Archivo)) {
                        if(!File.Exists(ruta + segmento.Archivo))
                            File.Move(rutaTmp + segmento.Archivo, ruta + segmento.Archivo);
                        else
                            File.Replace(rutaTmp + segmento.Archivo, ruta + segmento.Archivo, rutaTmp + segmento.Archivo + "_anterior");
                    } else {
                        File.WriteAllBytes(ruta + segmento.Archivo, archivo);
                    }

                    //se actualiza el id del segmento insertado
                    foreach (var columna in lstColumnas) {
                        columna.IdSegmento = segmento.IdSegmento;
                    }
                    dSegmento.InsertarColumnasSegmento(lstColumnas);
                }
                return segmento.IdSegmento;
            }
            finally
            {
                lstColumnas = null;
                dSegmento = null;
                leerArchivoSegmento = null;

                if(!string.IsNullOrEmpty(rutaTmp) && Directory.Exists(rutaTmp))
                    Directory.Delete(rutaTmp, true);
            }
        }
        

        public void ActualizarSegmento(ESegmento segmento, int idIsuarioLog, byte[] archivo, string ruta)
        {
            List<EColumnaSegmento> lstColumnas = null;
            DSegmento dSegmento = null;
            LeerArchivoSegmento leerArchivoSegmento = null;
            try
            {
                dSegmento = new DSegmento();
                leerArchivoSegmento = new LeerArchivoSegmento();

                dSegmento.ActualizarSegmento(segmento, idIsuarioLog, archivo != null);
                if (archivo != null)
                {
                    ruta = ruta + segmento.IdEmpresa.ToString() + @"\Segmento\" + segmento.IdSegmento + @"\";
                    if (Directory.Exists(ruta))
                    {
                        System.IO.Directory.Delete(ruta, true);
                    }
                    if (!Directory.Exists(ruta))
                    {
                        System.IO.Directory.CreateDirectory(ruta);
                    }
                    File.WriteAllBytes(ruta + segmento.Archivo, archivo);

                    lstColumnas = leerArchivoSegmento.ObteneEncabezadoExcel(ruta + segmento.Archivo, segmento.IdEmpresa, segmento.IdSegmento);
                    dSegmento.InsertarColumnasSegmento(lstColumnas);
                }
            }
            finally
            {
                lstColumnas = null;
                dSegmento = null;
                leerArchivoSegmento = null;
            }
        }

        public List<EColumnaSegmento> ObtenerColumnasSegmento(int pIdSegmento, int pIdEmpresa)
        {
            return new DSegmento().ObtenerColumnasSegmento(pIdSegmento, pIdEmpresa);
        }

        public List<EMapeoColumna> ObtenerMapeoSegmento(int pIdSegmento, int pIdEmpresa)
        {
            return new DSegmento().ObtenerMapeoSegmento(pIdSegmento, pIdEmpresa);
        }

        public void InsertarMapeoSegmento(List<EMapeoColumna> lst)
        {
            new DSegmento().InsertarMapeoSegmento(lst);
        }

        public List<object> GuardarInformacionDeudores(int pIdSegmento, string pSegmento, int pIdEmpresa, string pArchivo, string ruta, int idIsuarioLog, string correoUsuario) 
        {
            List<EMapeoColumnasSegmento> lstMapeoColumnas = null;
            LeerArchivoSegmento leerArchivoSegmento = null;
            List<EDeudor> lstDeudor = null;
            List<object> lst = new List<object>();
             int cuantosFallaron = 0; 
            try
            {
                ruta = ruta + pIdEmpresa.ToString() + @"\Segmento\" + pIdSegmento + @"\" + pArchivo;
                lstMapeoColumnas = new DSegmento().ObteneMapeoColumnasSegmento(pIdSegmento, pIdEmpresa);
                leerArchivoSegmento = new LeerArchivoSegmento();
                lstDeudor = leerArchivoSegmento.ObteneDeudoresExcel(ruta, lstMapeoColumnas, pIdEmpresa, pIdSegmento);
                
                lst.Add(lstDeudor.Count);
                cuantosFallaron = new DSegmento().InsertarDeudores(lstDeudor, idIsuarioLog);
                lst.Add(cuantosFallaron);

                if (cuantosFallaron > 0)
                {
                    new NEnviarCorreo().EnviarCorreoErrorImportarDeudores(correoUsuario, pSegmento, pIdEmpresa, lstDeudor.Count, cuantosFallaron);
                }
                
                return lst;
            }
            finally
            {
                lstMapeoColumnas = null;
                leerArchivoSegmento = null;
            }
        }

        public List<ESelect2Json> ObtenerSegmentosBuscar(string pNombreCompleto, int idEmpresa)
        {
            return new DSegmento().ObtenerSegmentosBuscar(pNombreCompleto, idEmpresa);
        }

        public List<ESegmento> ObtenerSegmentosPorAnalista(int pIdUsuario, int idEmpresa)
        {
            return new DSegmento().ObtenerSegmentosPorAnalista(pIdUsuario, idEmpresa);
        }

        public int EliminarInformacionDeudores(int pIdSegmento, int pIdEmpresa, byte[] archivo, int idIsuarioLog, bool eliminar)
        {
            LeerArchivoSegmento leerArchivoSegmento = null;
            List<EDeudor> lstDeudor = null;
            try
            {
                leerArchivoSegmento = new LeerArchivoSegmento();
                lstDeudor = leerArchivoSegmento.ObteneDeudoresEliminarExcel(archivo, pIdEmpresa, pIdSegmento);

                if (lstDeudor == null || lstDeudor.Count == 0)
                {
                    throw new System.ArgumentException("El archivo de excel no contiene información de deudores a desactivar/eliminar");
                }

                return new DSegmento().EliminarDeudores(lstDeudor, idIsuarioLog, eliminar);
            }
            finally
            {
                leerArchivoSegmento = null;
            }
        }
        */
    }
}