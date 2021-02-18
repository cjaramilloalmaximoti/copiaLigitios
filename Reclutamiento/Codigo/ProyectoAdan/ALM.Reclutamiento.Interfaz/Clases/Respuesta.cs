using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ALM.Empresa.Interfaz
{
    public class Respuesta
    {
        public string Codigo { get; set; }
        public string MensajeUsuario { get; set; }

        public string Extras { get; set; }
        public System.Web.Mvc.JsonResult RespuestaInformacion { get; set; }
    }
}