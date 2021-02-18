using ALM.Reclutamiento.Datos;
using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text;
using System.Net;
using System.IO;

namespace ALM.Reclutamiento.Negocio
{
    public class NProspecto
    {
        #region Vacante
        /// <summary>
        /// 
        /// </summary>
        /// <param name="IdVacante"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public List<EProspecto> ObtenerProspectosVacante(int IdVacante, int idEmpresa)
        {
            return new DProspecto().buscarProspectosVacante(IdVacante, idEmpresa);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ParametrosXML"></param>
        /// <param name="IdSexo"></param>
        /// <param name="IdEstadoCivil"></param>
        /// <param name="IdEscolaridad"></param>
        /// <param name="EdadMin"></param>
        /// <param name="EdadMax"></param>
        /// <returns></returns>
        public List<EProspecto> ObtenerProspectosPorCaracteristicas(int idEmpresa, string ParametrosXML, int IdSexo, int IdEstadoCivil, int IdEscolaridad, int EdadMin, int EdadMax, int IdVacante)
        {
            return new DProspecto().buscarProspectosPorCaracteristicas(idEmpresa, ParametrosXML, IdSexo, IdEstadoCivil, IdEscolaridad, EdadMin, EdadMax, IdVacante);
        }
        #endregion
        /// <summary>
        /// Obtener lista de prospectos
        /// </summary>
        /// <param name="nombre">Nombre a buscar</param>
        /// <param name="activo">Activo o Inactivo (1/0)</param> 
        /// <param name="idEmpresa">Id de la Empresa</param> 
        /// <returns>Lista de los Prospectos</returns> 
        public List<EProspecto> ObtenerProspectos(string nombre, int activo, int idEmpresa)
        {
            return new DProspecto().ObtenerProspectos(nombre, activo, idEmpresa);
        }

        //FSALAZAR 04/04/2019 REQ03042019 INI: Se pasan los dos nuevos valores junto con lo que ya exiten
        public List<EProspecto> ObtenerProspectosCaracteristicas(string nombre, int activo, string arrayCaracteristicas, int idEmpresa, List<ECaracteristicasGenerales> list)
        {
            return new DProspecto().ObtenerProspectosCaracteristicas(nombre, activo, arrayCaracteristicas, idEmpresa, list);
        }

        //INICIO JARAMILLO 
        public List<EProspecto> ObtenerProspectosCaracteristicasSeleccionados(string[] listaSeleccionados)
        {
            return new DProspecto().ObtenerProspectosCaracteristicasSeleccionados(listaSeleccionados);
        }
        //TERMINO JARAMILLO 

        public List<ECaracteristicasProspectos> ObtenerCaracteristicas(string idCaracteristicas)
        {
            return new DProspecto().ObtenerCaracteristicas(idCaracteristicas);
        }
        public List<ECaracteristicas> ObtenerCaracteristicasIds(string idCaracteristicas)
        {
            return new DProspecto().ObtenerCaracteristicasIds(idCaracteristicas);
        }

        //FSALAZAR 04/04/2019 REQ03042019 FIN

        public List<EProspecto> ObtenerProspectoId(int idProspecto)
        {
            return new DProspecto().ObtenerProspectoId(idProspecto);
        }

        public List<EProspecto> ObtenerProspectosCliente(int IdCliente)
        {
            return new DProspecto().buscarProspectosCliente(IdCliente);
        }

        /// <summary>
        /// Obtener detalles del Catalogo, llenar combos
        /// </summary>
        /// <param name="catalogo">Catalgo a bscar (Generos, escolarida, estado civil, etc)</param>
        /// <param name="activo">Estatus Activo, Inactivo (1/0)</param>
        /// <param name="idEmpresa">Id de la Empresa</param>
        /// <returns>Lista de los Catalogos</returns>
        public List<ECatalogo> ObtenerDetallesCatalogo(string catalogo, int activo, int idEmpresa)
        {
            return new DProspecto().ObtenerDetallesCatalogo(catalogo, activo, idEmpresa);
        }

        /// <summary>
        /// Insertar nuevo prospecto
        /// </summary>
        /// <param name="prospecto">Datos del Prospecto</param>
        /// <param name="idUsuarioLog">Id Usuario Logueado</param>
        /// <returns>Valor para checar si fue con exito la operacion</returns>
        public int InsertarProspecto(EProspecto prospecto, int idUsuarioLog, byte[] archivo, string ruta)
        {
            try
            {
                int id = new DProspecto().InsertarProspecto(prospecto, idUsuarioLog);

                if (archivo != null)
                {
                    ruta = ruta + @"\Prospecto\Foto\";
                    if (!Directory.Exists(ruta))
                    {
                        System.IO.Directory.CreateDirectory(ruta);
                    }
                    if (File.Exists(ruta + id + prospecto.Foto))
                    {
                        File.Delete(ruta + id + prospecto.Foto);
                    }
                    File.WriteAllBytes(ruta + id + prospecto.Foto, archivo);
                }

                return id;
            }
            finally
            {
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="prospecto"></param>
        /// <param name="idUsuarioLog"></param>
        /// <param name="archivo"></param>
        /// <param name="ruta"></param>
        public void ActualizarProspecto(EProspecto prospecto, int idUsuarioLog, byte[] archivo, string ruta)
        {
            try
            {
                new DProspecto().ActualizarProspecto(prospecto, idUsuarioLog);

                if (archivo != null)
                {
                    ruta = ruta + @"\Prospecto\Foto\";
                    if (!Directory.Exists(ruta))
                    {
                        System.IO.Directory.CreateDirectory(ruta);
                    }
                    if (File.Exists(ruta + prospecto.Foto))
                    {
                        File.Delete(ruta + prospecto.Foto);
                    }
                    File.WriteAllBytes(ruta + prospecto.Foto, archivo);
                }
            }
            finally
            {
            }
        }

        private string ObtenerResultadoValidacion(string resultadoValidacion)
        {
            switch (resultadoValidacion)
            {
                case "0-10":
                    return "La empresa es InActiva";
                case "0-20":
                    return "La empresa es No Vigente";
                case "0-30":
                    return "La empresa es Invalida, por número de usuarios";
                case "0-40":
                    return "La empresa es Invalida, por número de clientes";
                default:
                    return "Es Invalida por razones generales";
            }
        }
    }
}
