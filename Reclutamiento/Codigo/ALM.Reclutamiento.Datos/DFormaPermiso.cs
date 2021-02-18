using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;

namespace ALM.Reclutamiento.Datos
{
    public class DFormaPermiso : Conexion
    {
        public List<EFormaPermiso> Obtener(int idForma, int idEmpresa)
        {
            //idEmpresa = 0;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtPermisosForma");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdForma", idForma));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EFormaPermiso>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void Actualizar(List<EFormaPermiso> listformaPermiso, int idIsuarioLog, int idEmpresa)
        {
            //idEmpresa = 0;
            try
            {
                AbrirConexion();

                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActFormaPermiso");

                foreach (EFormaPermiso formaPermiso in listformaPermiso)
                {
                    accesoDatos.LimpiarParametros();
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdForma", formaPermiso.IdForma));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdPermiso", formaPermiso.IdPermiso));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                    accesoDatos.ListaParametros.Add(new MySqlParameter("pNombrePermiso", formaPermiso.NombrePermiso));

                    accesoDatos.Ejecutar();
                }
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}