using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;
using System.IO;


namespace ALM.Reclutamiento.Negocio
{
    public class NEmpresa
    {
        public List<EEmpresa> ObtenerEmpresas(EEmpresa parametros)
        {
            return new DEmpresa().ObtenerEmpresas(parametros);
        }
        public List<EEmpresa> ObtenerEmpresasID(EEmpresa parametros)
        {
            return new DEmpresa().ObtenerEmpresasID(parametros);
        }

        public List<EEmpresa> ObtenerIdEmpresaSiguiente()
        {
            return new DEmpresa().ObtenerIdEmpresaSiguiente();
        }

        public void RegistrarEmpresa(EEmpresa parametro, byte[] archivo, string ruta)
        {
            if (archivo != null)
            {
                ruta = ruta + parametro.IdEmpresa.ToString() + @"\";
                if (!Directory.Exists(ruta))
                {
                    System.IO.Directory.CreateDirectory(ruta);
                }
                if (File.Exists(ruta + parametro.Logo))
                {
                    File.Delete(ruta + parametro.Logo);
                }
                File.WriteAllBytes(ruta + parametro.Logo, archivo);
            }

            new DEmpresa().RegistrarEmpresa(parametro);
            NClaseEstatica.EstablecerLstEmpresa();
        }

        public void ActualizarEmpresa(EEmpresa parametro, byte[] archivo, string ruta)
        {
            if (archivo != null)
            {
                ruta = ruta + parametro.IdEmpresa.ToString() + @"\";
                if (!Directory.Exists(ruta))
                {
                    System.IO.Directory.CreateDirectory(ruta);
                }
                if (File.Exists(ruta + parametro.Logo))
                {
                    File.Delete(ruta + parametro.Logo);
                }
                File.WriteAllBytes(ruta + parametro.Logo, archivo);
            }
            new DEmpresa().ActualizarEmpresa(parametro);
            NClaseEstatica.EstablecerLstEmpresa();
        }
    }
}