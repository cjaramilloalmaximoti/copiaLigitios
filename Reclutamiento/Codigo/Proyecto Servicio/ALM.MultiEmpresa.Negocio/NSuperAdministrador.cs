using ALM.ServicioAdminEmpresas.Datos;
using ALM.ServicioAdminEmpresas.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EnviarCorreo = ALM.Correo;

namespace ALM.ServicioAdminEmpresas.Negocio
{
    public class NSuperAdministrador
    {
        private Random random = new Random();

        public string ValidarSuperUsuario(string login, string contasenia, string dominio, string productKey, int fechaLlamada)
        {
            ESuperAdministrador eSuperAdministrador = null;
            EValidarEmpresa eValidarEmpresa = null;
            try
            {
                if (!string.IsNullOrEmpty(login) && login.Contains("@") && login.Split('@').Length == 2)
                {
                    eSuperAdministrador = new ESuperAdministrador()
                    {
                        Login = login.Split('@')[0],
                        Dominio = "@" + login.Split('@')[1],
                        Contraseña = contasenia
                    };
                    new DSuperAdministrador().ValidarSuperUsuario(ref eSuperAdministrador);
                    if (!string.IsNullOrEmpty(eSuperAdministrador.Email))
                    {
                        eValidarEmpresa = new EValidarEmpresa()
                        {
                            Dominio = dominio,
                            ProductKey = productKey,
                            FechaLlamada = int.Parse(DateTime.Now.ToString("yyyyMMdd"))
                        };
                    }
                    else
                    {
                        eValidarEmpresa = new EValidarEmpresa()
                        {
                            FechaLlamada = int.Parse(DateTime.Now.ToString("yyyyMMdd"))
                        };
                    }
                }
                else
                {
                    eValidarEmpresa = new EValidarEmpresa()
                    {
                        FechaLlamada = int.Parse(DateTime.Now.ToString("yyyyMMdd"))
                    };
                }

                new NEmpresa().ValidarEmpresaSuperUsuario(ref eValidarEmpresa);

                if (!string.IsNullOrEmpty(eValidarEmpresa.CodIncidencia))
                {
                    GenerarCodigoSuperAdministrador(eValidarEmpresa, eSuperAdministrador);
                }

                return eValidarEmpresa.Mensaje;
            }
            finally
            {
                eValidarEmpresa = null;
            }
        }

        public bool LimpiarEmpresa(string codigo, string productKey, int fechaLlamada)
        {
            EValidarEmpresa eValidarEmpresa = null;
            NEmpresa nEmpresa = null;
            try
            {
                nEmpresa = new NEmpresa();
                eValidarEmpresa = new EValidarEmpresa()
                {
                    ProductKey = productKey,
                    FechaLlamada = int.Parse(DateTime.Now.ToString("yyyyMMdd")),
                    CodigoSuperAdministrador = codigo
                };
                // eValidarEmpresa.Dominio, falta mapear el campo de dominio para hacer la comparación
                // dentro de la función DesEncriptarProductKey
                nEmpresa.DesEncriptarProductKey(ref eValidarEmpresa);

                return new NEmpresa().LimpiarCodigoSuperAdministrador(ref eValidarEmpresa);
            }
            finally
            {
                eValidarEmpresa = null;
            }
        }

        public void GenerarCodigoSuperAdministrador(EValidarEmpresa eValidarEmpresa, ESuperAdministrador eSuperAdministrador)
        {
            eValidarEmpresa.CodigoSuperAdministrador = RandomString(4);
            new NEmpresa().ActualizarCodigoSuperAdministrador(ref eValidarEmpresa);
            EnviarCorreoCodigoSuperAdministrador(eValidarEmpresa, eSuperAdministrador);
        }

        private string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        public void EnviarCorreoCodigoSuperAdministrador(EValidarEmpresa eValidarEmpresa, ESuperAdministrador eSuperAdministrador)
        {
            EnviarCorreo.Correo correo = null;
            Utilerias.Utilerias utilerias = null;

            try
            {

                var fecha = DateTime.Today;

                utilerias = new Utilerias.Utilerias();
                utilerias.Clave = "";
                utilerias.Clave = utilerias.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                correo = new EnviarCorreo.Correo();

                correo.EsSSL = true;
                correo.NombreUsuarioCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.ContraseniaCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Contrasenia").Valor;
                correo.De = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.AliasDe = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente").Valor;
                correo.SMTP = EClaseEstatica.LstParametro.Find(x => x.Nombre == "SMTP").Valor;

                correo.EsHTMLBody = true;
                correo.Puerto = int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre == "Puerto").Valor.ToString());


                correo.Body = EClaseEstatica.LstParametro.Find(x => x.Nombre == "EmailCodigoSuperAdministrador").Valor.ToString();
                correo.Titulo = EClaseEstatica.LstParametro.Find(x => x.Nombre == "TituloCodigoSuperAdministrador").Valor;
                correo.Body = correo.Body.Replace("%%Dominio%%", eValidarEmpresa.ProductKey_Dominio);
                correo.Body = correo.Body.Replace("%%RFC%%", eValidarEmpresa.ProductKey_RFC);
                correo.Body = correo.Body.Replace("%%Codigo%%", eValidarEmpresa.CodigoSuperAdministrador);


                correo.EnviarCorreo(eSuperAdministrador.Email, null);

            }
            finally
            { }
        }
    }
}