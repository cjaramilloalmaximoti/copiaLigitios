using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.ServicioAdminEmpresas.Entidades
{
    public class Constante
    {
        #region Conexion
        public static String Clave = "ALMCL01";
        public static String RutaSP = "../Persistencia/Consultas.config";
        #endregion

        public enum Privilegio
        {
            Consultar = 1,
            Agregar = 2,
            Actualizar = 4,
            Eliminar = 8
        }

        public enum Origen
        {
            Login = 1,
            Usuarios = 2,
            Clientes = 3,
            Registros = 4,
            Otros = 5
        }
    }
}