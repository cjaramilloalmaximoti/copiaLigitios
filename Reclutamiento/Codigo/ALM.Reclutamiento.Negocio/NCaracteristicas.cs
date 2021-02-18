using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Datos;
using System;

namespace ALM.Reclutamiento.Negocio
{
    public class NCaracteristicas
    {
        /// <summary>
        /// Obtener caracteristicas
        /// </summary>
        /// <param name="carac"></param>
        /// <param name="masFiltros"></param>
        /// <returns></returns>
        public List<ECaracteristicas> ObtenerCaracteristicas(ECaracteristicas carac, string masFiltros)
        {
            return new DCaracteristicas().obtenerCaracteristicas(carac, masFiltros );
        }

        /// <summary>
        /// Validar Codigo
        /// </summary>
        /// <param name="codigo"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<ECaracteristicas> ValidarCodigo(string codigo, int id)
        {
            return new DCaracteristicas().validarCodigo(codigo, id);
        }

        /// <summary>
        /// Insertar Caracteristica
        /// </summary>
        /// <param name="carac">Datos de la Caracteristica</param>
        /// <param name="detalles">Detalles de la caracteristica, las categorias seleccionadas</param>
        /// <param name="servidor">Servidor delnde se van a conectar los enlaces de la aprobacion</param>
        /// <param name="mailAdmin">Correo del Administrador</param>
        /// <returns></returns>
        public int InsertarCaracteristica(ECaracteristicas carac,string detalles, string servidor, string mailAdmin)
        {
            return new DCaracteristicas().InsertarCaracteristica(carac, detalles, servidor, mailAdmin);
        }

        /// <summary>
        /// Actualizar una Caracteristica
        /// </summary>
        /// <param name="carac">Datos de la Caracteristica</param>
        /// <param name="detalles">Detalles de la caracteristica, las categorias seleccionadas</param>
        /// <param name="servidor">Servidor de conexion de los enlaces de aprobacion</param>
        public void ActualizarCaracteristica(ECaracteristicas carac, string detalles, string servidor)
        {
            new DCaracteristicas().ActualizarCaracteristica(carac, detalles, servidor);
        }

        /// <summary>
        /// Aprobar o Rechazar caracteristica
        /// </summary>
        /// <param name="carac">datos de la caracteristica</param>
        public void aprobarRechazar(ECaracteristicas carac)
        {
            new DCaracteristicas().aprobarRechazar(carac);
        }

        /// <summary>
        /// Obtener una Lista de las Tipos de Controles en la BD
        /// </summary>
        /// <returns>Una lista (list) de tipos de controles obtenidas en la BD</list></returns>
        public List<ETipoControl> ObtenerTiposControl()
        {
            return new DCaracteristicas().ObtenerTiposControl();
        }
    }
}
