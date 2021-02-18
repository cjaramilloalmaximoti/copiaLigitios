﻿using System;

namespace ALM.Reclutamiento.Entidades
{
    public class ESelect2Json : ICloneable
    {
        public string id { get; set; }
        public string text { get; set; }

        #region metodos

        public object Clone()
        {
            return MemberwiseClone();
        }

        #endregion
    }
}
