
namespace ALM.Empresa.Utilerias
{
    public class EstiloCelda
    {
        #region campos

        private int idTipoCelda;
        private int index;
        private int cuantosDecimales;
        private bool par;
        private bool totalizado = false;
        private bool negrita = false;

        #endregion

        #region propiedades

        public int IdTipoCelda
        {
            get { return idTipoCelda; }
            set { idTipoCelda = value; }
        }

        public int Index
        {
            get { return index; }
            set { index = value; }
        }

        public int CuantosDecimales
        {
            get { return cuantosDecimales; }
            set { cuantosDecimales = value; }
        }

        public bool Par
        {
            get { return par; }
            set { par = value; }
        }

        public bool Totalizado
        {
            get { return totalizado; }
            set { totalizado = value; }
        }

        public bool Negrita
        {
            get { return negrita; }
            set { negrita = value; }
        }

        #endregion

        #region constructores

        public EstiloCelda()
        {
        }

        #endregion
    }
}
