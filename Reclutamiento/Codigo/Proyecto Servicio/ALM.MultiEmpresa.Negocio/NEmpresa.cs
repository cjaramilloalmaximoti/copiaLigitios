using ALM.ServicioAdminEmpresas.Datos;
using ALM.ServicioAdminEmpresas.Entidades;
using System;

namespace ALM.ServicioAdminEmpresas.Negocio
{
    public class NEmpresa
    {
        public string ValidarEmpresa(string dominio, int origen, short usuarios, short clientes, Int64 registros, string productKey, int fechaLlamada)
        {
            EValidarEmpresa eValidarEmpresa = null;
            try
            {
                eValidarEmpresa = new EValidarEmpresa()
                {
                    Dominio = dominio,
                    Origen = (Constante.Origen)origen,
                    Usuarios = usuarios,
                    Clientes = clientes,
                    Registros = registros,
                    ProductKey = productKey,
                    FechaLlamada = int.Parse(DateTime.Now.ToString("yyyyMMdd"))
                };
                if (DesEncriptarProductKey(ref eValidarEmpresa))
                {
                    new DEmpresa().ValidarEmpresa(ref eValidarEmpresa);

                    if (eValidarEmpresa.CodIncidencia != "0")
                    {
                        eValidarEmpresa.Mensaje = GenerarMensaje(eValidarEmpresa.CodIncidencia);
                    }
                }
                else
                {
                    eValidarEmpresa.Mensaje = GenerarMensaje("Otro");
                }
                EncriptarMensaje(ref eValidarEmpresa);

                return eValidarEmpresa.Mensaje;
            }
            finally
            {
                eValidarEmpresa = null;
            }
        }

        public void ValidarEmpresaSuperUsuario(ref EValidarEmpresa eValidarEmpresa)
        {
            if (DesEncriptarProductKey(ref eValidarEmpresa))
            {
                new DEmpresa().ValidarEmpresaSuperUsuario(ref eValidarEmpresa);

                if (string.IsNullOrEmpty(eValidarEmpresa.CodIncidencia))
                {
                    eValidarEmpresa.Mensaje = GenerarMensaje("0");
                }
            }
            else
            {
                eValidarEmpresa.Mensaje = GenerarMensaje("0");
            }
            EncriptarMensaje(ref eValidarEmpresa);
        }

        public void ActualizarCodigoSuperAdministrador(ref EValidarEmpresa validar)
        {
            new DEmpresa().ActualizarCodigoSuperAdministrador(ref validar);
        }

        public bool LimpiarCodigoSuperAdministrador(ref EValidarEmpresa validar)
        {
            return new DEmpresa().LimpiarCodigoSuperAdministrador(ref validar);
        }

        private string GenerarMensaje(string codIncidencia)
        {
            return "@Dominio.com" + "|" + "ABC990101" + "|" + "0" + "-" + codIncidencia + "|" + "19010101";
        }

        public void EncriptarMensaje(ref EValidarEmpresa eValidarEmpresa)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                eValidarEmpresa.Mensaje = utileria.Cifrar(eValidarEmpresa.Mensaje);
            }
            finally
            {
                utileria = null;
            }
        }

        public bool DesEncriptarProductKey(ref EValidarEmpresa eValidarEmpresa)
        {
            Utilerias.Utilerias utileria = null;
            string productKey = null;
            bool valido = false;
            try
            {
                if (!string.IsNullOrEmpty(eValidarEmpresa.ProductKey))
                {
                    utileria = new Utilerias.Utilerias();
                    utileria.Clave = "";
                    utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                    utileria.ReemplazarMVC = true;
                    productKey = utileria.Descifrar(eValidarEmpresa.ProductKey);

                    if (!string.IsNullOrEmpty(productKey) && productKey.Contains("|") && productKey.Split('|').Length == 2)
                    {
                        eValidarEmpresa.ProductKey_Dominio = productKey.Split('|')[0];
                        eValidarEmpresa.ProductKey_RFC = productKey.Split('|')[1];
                        
                        valido = eValidarEmpresa.ProductKey_Dominio == eValidarEmpresa.Dominio;
                    }
                }

                return valido;
            }
            finally
            {
                utileria = null;
            }
        }
    }
}