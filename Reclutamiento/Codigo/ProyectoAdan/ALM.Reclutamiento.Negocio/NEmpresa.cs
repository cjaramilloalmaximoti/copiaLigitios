using ALM.Empresa.Datos;
using ALM.Empresa.Entidades;
using System.Collections.Generic;
using System.IO;


namespace ALM.Empresa.Negocio
{
    public class NEmpresa
    {
        public List<EEmpresa> ObtenerEmpresas()
        {
            return new DEmpresa().ObtenerEmpresas();
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
                if (File.Exists(ruta + parametro.RutaLogo))
                {
                    File.Delete(ruta + parametro.RutaLogo);
                }
                File.WriteAllBytes(ruta + parametro.RutaLogo, archivo);
            }
            new DEmpresa().ActualizarEmpresa(parametro);
            NClaseEstatica.EstablecerLstEmpresa();
        }
    }
}