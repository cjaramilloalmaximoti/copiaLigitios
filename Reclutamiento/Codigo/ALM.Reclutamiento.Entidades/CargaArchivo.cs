using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace ALM.Reclutamiento.Entidades
{

    [Serializable]
    public class CargaArchivo
    {
        //HttpPostedFileBase
        public HttpPostedFileBase file { get; set; }
        public string Id { get; set; }
    }
}
