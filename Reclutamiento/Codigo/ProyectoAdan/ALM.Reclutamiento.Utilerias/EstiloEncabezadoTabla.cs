
namespace ALM.Empresa.Utilerias
{
    public class EstiloEncabezadoTabla
    {
        #region campos

        private int indiceEstilo;
        private int indiceFills;
        private string colorEncabezado;

        #endregion

        #region propiedades

        public int IndiceEstilo
        {
            get { return indiceEstilo; }
            set { indiceEstilo = value; }
        }

        public int IndiceFills
        {
            get { return indiceFills; }
            set { indiceFills = value; }
        }

        public string ColorEncabezado
        {
            get { return colorEncabezado; }
            set { colorEncabezado = value; }
        }

        #endregion

        #region constructores

        public EstiloEncabezadoTabla()
        {
        }

        #endregion
    }
}
