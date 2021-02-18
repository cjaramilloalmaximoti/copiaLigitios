namespace ALM.Reclutamiento.AccesoDatos
{
    public class ColumnaDataReader
    {
        private string nombreColumna;

        /// <summary>
        /// Nombre de la columna
        /// </summary>
        public string NombreColumna
        {
            get
            {
                return nombreColumna;
            }

            set
            {
                nombreColumna = value;
            }
        }

        /// <summary>
        /// Nombre de la columna sin guiones, solo de lectura ya que a partir de la propiedad NombreColumna se obtiene su valor quitando  los guiones que este último contenga.
        /// </summary>
        public string NombreColumnaSinGuion
        {
            get
            {
                return nombreColumna.Replace("_", string.Empty);
            }
        }

        /// <summary>
        /// Constructor predeterminado
        /// </summary>
        public ColumnaDataReader()
        {
        }
    }
}
