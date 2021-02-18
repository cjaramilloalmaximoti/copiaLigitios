namespace ALM.ServicioAdminEmpresas.AccesoDatos
{
    using MySql.Data.MySqlClient;

    public class MySqlClient
    {
        #region "Variables privadas"

        private string cadenaConexion = string.Empty;

        private string consulta = string.Empty;

        private System.Data.CommandType tipoComando = System.Data.CommandType.StoredProcedure;

        private System.Collections.Generic.List<MySqlParameter> listaParametros = new System.Collections.Generic.List<MySqlParameter>();

        private MySqlConnection conexion = null;

        #endregion

        #region "Constructores"

        public MySqlClient()
        {
        }

        public MySqlClient(string cadenaConexion)
        {
            this.CadenaConexion = cadenaConexion;
        }

        #endregion

        #region "Propiedades públicas"

        public string CadenaConexion
        {
            get { return this.cadenaConexion; }
            set { this.cadenaConexion = value; }
        }

        public string Consulta
        {
            get { return this.consulta; }
            set { this.consulta = value; }
        }

        public System.Data.CommandType TipoComando
        {
            get { return this.tipoComando; }
            set { this.tipoComando = value; }
        }

        public System.Collections.Generic.List<MySqlParameter> ListaParametros
        {
            get { return this.listaParametros; }
            set { this.listaParametros = value; }
        }

        #endregion

        #region "Métodos públicos"

        public void AbrirConexion()
        {
            try
            {
                this.EstablecerProveedorConexion(ref this.conexion);

                this.conexion.ConnectionString = this.CadenaConexion;

                this.conexion.Open();
            }
            catch (System.Exception ex)
            {
                System.Diagnostics.EventLog.WriteEntry("AccesoDatos.Persistencia", "AccesoDatos.Persistencia.Error. " + ex.Message, System.Diagnostics.EventLogEntryType.Error);
                throw;
            }
        }

        public void CerrarConexion()
        {
            try
            {
                if (this.conexion != null)
                {
                    if (this.conexion.State != System.Data.ConnectionState.Closed)
                    {
                        this.conexion.Close();
                    }
                }
            }
            finally
            {
                if (this.conexion != null)
                {
                    this.conexion.Dispose();
                }

                this.conexion = null;
            }
        }

        public int Ejecutar()
        {
            MySqlCommand comando = null;

            try
            {

                if (this.SiExisteConexion(ref this.conexion) == false)
                {
                    throw new System.InvalidOperationException("No existe Conexión de Clase con la Base de Datos.");
                }

                this.EstablecerProveedorComando(ref comando);

                comando.Connection = this.conexion;
                comando.CommandTimeout = 0;
                comando.CommandType = this.TipoComando;
                comando.CommandText = this.Consulta;

                for (int i = 0; i < this.ListaParametros.Count; i++)
                {
                    comando.Parameters.Add(this.ListaParametros[i]);
                }

                return comando.ExecuteNonQuery();
            }
            finally
            {
                if (comando != null)
                {
                    comando.Dispose();
                }

                comando = null;

                if (this.SiLimpiarParametros() == true)
                {
                    this.LimpiarParametros();
                }
            }
        }
        public System.Data.DataTable CargarTabla()
        {
            MySqlCommand comando = null;
            MySqlDataAdapter adaptador = null;
            System.Data.DataSet conjuntoDatos = new System.Data.DataSet("ConjuntoDatos");

            try
            {

                if (this.SiExisteConexion(ref this.conexion) == false)
                {
                    throw new System.InvalidOperationException("No existe Conexión de Clase con la Base de Datos.");
                }

                this.EstablecerProveedorComando(ref comando);

                comando.Connection = this.conexion;
                comando.CommandTimeout = 0;
                comando.CommandType = this.TipoComando;
                comando.CommandText = this.Consulta;

                for (int i = 0; i < this.ListaParametros.Count; i++)
                {
                    comando.Parameters.Add(this.ListaParametros[i]);
                }

                this.EstablecerProveedorAdaptador(ref adaptador, ref comando);

                adaptador.Fill(conjuntoDatos);

                conjuntoDatos.Tables[0].TableName = "Tabla";

                return conjuntoDatos.Tables["Tabla"];
            }
            finally
            {
                if (comando != null)
                {
                    comando.Dispose();
                }

                comando = null;

                adaptador = null;

                if (conjuntoDatos != null)
                {
                    conjuntoDatos.Dispose();
                }

                conjuntoDatos = null;

                if (this.SiLimpiarParametros() == true)
                {
                    this.LimpiarParametros();
                }
            }
        }

        public System.Data.DataSet CargarConjuntoDatos()
        {
            MySqlCommand comando = null;
            MySqlDataAdapter adaptador = null;
            System.Data.DataSet conjuntoDatos = new System.Data.DataSet("ConjuntoDatos");

            try
            {

                if (this.SiExisteConexion(ref this.conexion) == false)
                {
                    throw new System.InvalidOperationException("No existe Conexión de Clase con la Base de Datos.");
                }

                this.EstablecerProveedorComando(ref comando);

                comando.Connection = this.conexion;
                comando.CommandTimeout = 0;
                comando.CommandType = this.TipoComando;
                comando.CommandText = this.Consulta;

                for (int i = 0; i < this.ListaParametros.Count; i++)
                {
                    comando.Parameters.Add(this.ListaParametros[i]);
                }

                this.EstablecerProveedorAdaptador(ref adaptador, ref comando);

                adaptador.Fill(conjuntoDatos);
                ;
                return conjuntoDatos;
            }
            finally
            {
                if (comando != null)
                {
                    comando.Dispose();
                }

                comando = null;

                adaptador = null;

                if (conjuntoDatos != null)
                {
                    conjuntoDatos.Dispose();
                }

                conjuntoDatos = null;

                if (this.SiLimpiarParametros() == true)
                {
                    this.LimpiarParametros();
                }
            }
        }

        public object ObtenerEscalar()
        {
            MySqlCommand comando = null;

            try
            {

                if (this.SiExisteConexion(ref this.conexion) == false)
                {
                    throw new System.InvalidOperationException("No existe Conexión de Clase con la Base de Datos.");
                }

                this.EstablecerProveedorComando(ref comando);

                comando.Connection = this.conexion;
                comando.CommandTimeout = 0;
                comando.CommandType = this.TipoComando;
                comando.CommandText = this.Consulta;

                for (int i = 0; i < this.ListaParametros.Count; i++)
                {
                    comando.Parameters.Add(this.ListaParametros[i]);
                }

                return comando.ExecuteScalar();
            }
            finally
            {
                if (comando != null)
                {
                    comando.Dispose();
                }

                comando = null;

                if (this.SiLimpiarParametros() == true)
                {
                    this.LimpiarParametros();
                }
            }
        }
                
        public System.Collections.Generic.List<T> ListarDatos<T>(System.Data.DataTable tablaDatos) where T : class
        {
            if (tablaDatos == null)
            {
                throw new System.ArgumentNullException("tablaDatos", "La Tabla de datos no puede ser null.");
            }
            return tablaDatos.DataTableMapToList<T>();
        }
        public MySqlParameter GenerarParametro(string nombre, object valor, System.Data.DbType tipoDato, System.Data.ParameterDirection direccion)
        {
            MySqlParameter parametro = null;

            try
            {
                this.EstablecerProveedorParametro(ref parametro);

                parametro.ParameterName = nombre;
                parametro.Value = valor;
                parametro.DbType = tipoDato;
                parametro.Direction = direccion;

                return parametro;
            }
            finally
            {
                parametro = null;
            }
        }

        public void LimpiarParametros()
        {
            this.ListaParametros.Clear();
        }

        public string ObtenerConsultaXml(string nombreArchivoExtension, string etiquetaConsulta)
        {
            System.Uri rutaUri = null;
            System.Xml.XmlDocument documento = new System.Xml.XmlDocument();
            System.Xml.XmlNode nodo;

            string rutaConsultasXml = string.Empty;
            string consulta = string.Empty;

            try
            {
                rutaConsultasXml = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase) + "\\" + nombreArchivoExtension;
                rutaUri = new System.Uri(rutaConsultasXml);
                rutaConsultasXml = rutaUri.LocalPath;

                documento.Load(rutaConsultasXml);
                nodo = documento.SelectSingleNode("/configuration/Consulta[@EtiquetaId='" + etiquetaConsulta + "']");

                if (nodo == null)
                {
                    throw new System.Xml.XmlException("No se ha encontrado la Etiqueta Nodo de la Consulta.");
                }
                else
                {
                    consulta = nodo.InnerText;
                }

                return consulta;
            }
            finally
            {
                rutaUri = null;
                documento = null;
                nodo = null;
            }
        }

        #endregion

        #region "Métodos privados"

        private void EstablecerProveedorConexion(ref MySqlConnection conexion)
        {

            conexion = new MySqlConnection();
        }

        private void EstablecerProveedorComando(ref MySqlCommand comando)
        {

            comando = new MySqlCommand();
        }

        private void EstablecerProveedorAdaptador(ref MySqlDataAdapter adaptador, ref MySqlCommand comando)
        {
            adaptador = new MySqlDataAdapter((MySqlCommand)comando);
        }

        private void EstablecerProveedorParametro(ref MySqlParameter parametro)
        {
            parametro = new MySqlParameter();
        }

        private bool SiExisteConexion(ref MySqlConnection conexion)
        {
            bool existeConexion = false;

            if (conexion != null)
            {
                if (conexion.State != System.Data.ConnectionState.Closed && conexion.State != System.Data.ConnectionState.Broken && conexion.State != System.Data.ConnectionState.Connecting)
                {
                    existeConexion = true;
                }
            }

            return existeConexion;
        }

        private string ObtenerCadenaParametros()
        {
            System.Text.StringBuilder cadenaParametros = new System.Text.StringBuilder();

            try
            {
                for (int i = 0; i < this.ListaParametros.Count; i++)
                {
                    cadenaParametros.Append(this.ListaParametros[i].ParameterName + " " + this.ListaParametros[i].Value.ToString() + " " + this.ListaParametros[i].DbType.ToString() + " " + this.ListaParametros[i].Direction.ToString() + "; ");
                }

                return cadenaParametros.ToString();
            }
            finally
            {
                cadenaParametros = null;
            }
        }

        private bool SiLimpiarParametros()
        {
            bool limpiarParametros = true;

            for (int i = 0; i < this.ListaParametros.Count; i++)
            {
                if (this.ListaParametros[i].Direction != System.Data.ParameterDirection.Input)
                {
                    limpiarParametros = false;
                    break;
                }
            }

            return limpiarParametros;
        }

        private Tipo ClonarObjeto<Tipo>(Tipo origen)
        {
            System.Runtime.Serialization.IFormatter formateador = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            System.IO.Stream stream = new System.IO.MemoryStream();

            try
            {
                if (!typeof(Tipo).IsSerializable)
                {
                    throw new System.ArgumentException("El Tipo origen debe ser serializable.", "origen");
                }

                if (object.ReferenceEquals(origen, null))
                {
                    return default(Tipo);
                }

                formateador.Serialize(stream, origen);

                stream.Seek(0, System.IO.SeekOrigin.Begin);

                return (Tipo)formateador.Deserialize(stream);
            }
            finally
            {
                formateador = null;

                if (stream != null)
                {
                    stream.Close();
                    stream.Dispose();
                }

                stream = null;
            }
        }

        #endregion
    }
}