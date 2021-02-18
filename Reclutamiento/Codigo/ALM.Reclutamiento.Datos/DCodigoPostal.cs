using ALM.Reclutamiento.Entidades;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DCodigoPostal : Conexion
    {

        public List<EEstados> ObtenerEstados(string clavePais, int activo)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtEstados");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClavePais", clavePais));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));

                return accesoDatos.CargarTabla().DataTableMapToList<EEstados>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECiudad> ObtenerCiudades(string claveEstado, string nombre, int activo)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCiudades");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveEstado", claveEstado));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));

                return accesoDatos.CargarTabla().DataTableMapToList<ECiudad>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EPais> ObtenerPaises(string nombre, int activo)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtPaises");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));

                return accesoDatos.CargarTabla().DataTableMapToList<EPais>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EColonia> ObtenerColonias(string claveCiudad, string claveEstado, string nombre, int activo)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtColonias");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveCiudad", claveCiudad));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveEstado", claveEstado));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));

                return accesoDatos.CargarTabla().DataTableMapToList<EColonia>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EColonia> buscarCP(string cp)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCP");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCP", cp));

                return accesoDatos.CargarTabla().DataTableMapToList<EColonia>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void DeleteTablasCP(string pais)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPTruTablasCP");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPais", pais));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsEstados(string estados)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsEstados");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstados", estados));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsCiudades(string ciudades)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsCiudades");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCiudades", ciudades));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsTipoAsentamiento(string tipoAsentamientos)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsTipoAsentamientos");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTipoAsentamiento", tipoAsentamientos));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }


        public void InsColonias(string colonias)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsColonias");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pColonias", colonias));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void InsFechaUltimaCarga(string pais, int idusuario)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsFechaUltimaCarga");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPais", pais));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuario", idusuario));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public string ObtenerFechaUltimaCarga(string pais)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtFechaUltimaCarga");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pPais", pais));


                string resultado = accesoDatos.ObtenerEscalar().ToString();

                if (resultado.Length == 0)
                {
                    resultado = "Aún no se ha realizado Carga para este país";
                }
                else
                {
                    resultado = "La ultima carga se realizo el día: " + Convert.ToDateTime(resultado).ToShortDateString();
                }


                return resultado;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<ECiudad> ObtenerCiudadTexto(string estadoClave,string ciudadClave)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCiudadTexto");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveEstado", estadoClave));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveCiudad", ciudadClave));

                return accesoDatos.CargarTabla().DataTableMapToList<ECiudad>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}
