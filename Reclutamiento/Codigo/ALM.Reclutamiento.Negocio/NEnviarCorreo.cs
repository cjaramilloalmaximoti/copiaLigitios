using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EnviarCorreo = ALM.Correo;

namespace ALM.Reclutamiento.Negocio
{


    public class NEnviarCorreo
    {
        public void EnviarCorreoErrorImportarDeudores(string destinatario, string segmento, int idEmpresa, int total, int incorrectos)
        {
            EnviarCorreo.Correo correo = null;
            try
            {
                var fecha = DateTime.Today;

                correo = new EnviarCorreo.Correo();

                correo.EsSSL = true;
                correo.NombreUsuarioCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente" && x.IdEmpresa.Equals(idEmpresa)).Valor;
                correo.ContraseniaCredencial = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Contrasenia" && x.IdEmpresa.Equals(idEmpresa)).Valor;
                correo.De = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente" && x.IdEmpresa.Equals(idEmpresa)).Valor;
                correo.AliasDe = EClaseEstatica.LstParametro.Find(x => x.Nombre == "Remitente" && x.IdEmpresa.Equals(idEmpresa)).Valor;
                correo.SMTP = EClaseEstatica.LstParametro.Find(x => x.Nombre == "SMTP" && x.IdEmpresa.Equals(idEmpresa)).Valor;

                correo.EsHTMLBody = true;
                correo.Puerto = int.Parse(EClaseEstatica.LstParametro.Find(x => x.Nombre == "Puerto" && x.IdEmpresa.Equals(idEmpresa)).Valor.ToString());

                correo.Body = EClaseEstatica.LstParametro.Find(x => x.Nombre == "EmailImportarDeudores" && x.IdEmpresa.Equals(idEmpresa)).Valor.ToString();
                correo.Titulo = EClaseEstatica.LstParametro.Find(x => x.Nombre == "TituloImportarDeudores" && x.IdEmpresa.Equals(idEmpresa)).Valor;
                correo.Body = correo.Body.Replace("%%SEGMENTO%%", segmento); ;
                correo.Body = correo.Body.Replace("%%TOTAL%%", total.ToString());
                correo.Body = correo.Body.Replace("%%INCORRECTOS%%", incorrectos.ToString());

                correo.EnviarCorreo(destinatario, EClaseEstatica.LstParametro.Find(x => x.Nombre == "CorreoCCImportarDeudores" && x.IdEmpresa.Equals(idEmpresa)).Valor.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
