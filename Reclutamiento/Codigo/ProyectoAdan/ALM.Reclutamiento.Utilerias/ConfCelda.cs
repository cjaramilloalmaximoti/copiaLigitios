
namespace ALM.Empresa.Utilerias
{
    public class ConfCelda
    {
        #region campos

        private string nombreCampo;
        private string celda;
        private int caracteresCelda;
        private int idTipoCelda;
        private int cuantosDecimales;
        private string nombreColumna;
        private bool esFecha = false;
        private bool esNumero = false;
        private bool esPorcentaje = false;

        #endregion

        #region propiedades

        public string NombreCampo
        {
            get { return nombreCampo; }
            set { nombreCampo = value; }
        }

        public string Celda
        {
            get { return celda; }
            set { celda = value; }
        }

        public int CaracteresCelda
        {
            get { return caracteresCelda; }
            set { caracteresCelda = value; }
        }

        public int IdTipoCelda
        {
            get { return idTipoCelda; }
            set { idTipoCelda = value; }
        }

        public int CuantosDecimales
        {
            get { return cuantosDecimales; }
            set { cuantosDecimales = value; }
        }

        public string NombreColumna
        {
            get { return nombreColumna; }
            set { nombreColumna = value; }
        }

        public bool EsFecha
        {
            get { return esFecha; }
            set { esFecha = value; }
        }

        public bool EsNumero
        {
            get { return esNumero; }
            set { esNumero = value; }
        }

        public bool EsPorcentaje
        {
            get { return esPorcentaje; }
            set { esPorcentaje = value; }
        }

        #endregion

        #region constructores

        public ConfCelda()
        {
        }

        #endregion
    }
}
