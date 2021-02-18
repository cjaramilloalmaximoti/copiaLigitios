using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ALM.Reclutamiento.Entidades
{
    [Serializable]
    public class EMapeoColumnasSegmento
    {
        public string Columna { get; set; }
        public string Propiedad { get; set; }
    }
}
