using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Entidades
{
    public class Constante
    {
        #region Conexion
        public static String Clave = "ALMCL01";
        public static String RutaSP = "../Persistencia/Consultas.config";
        #endregion

        #region MensajeValidador

        public const string CampoRequerido = "Campo requerido";

        public const string FormatoIncorrecto = "Formato del campo incorrecto";

        public const string TamanioCampo = "Tamaño del campo incorrecto";

        #endregion

        #region Generales
        public static String RegularExpretionPassword = @"(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$";
        public static String SinRegistro = string.Empty;
        public static int EntSinRegistro = 0;
        public static String Home = "Home";
        public static String Index = "Index";
        public static String Id = "id";
        public static String Expedientes = "Expedientes";
        public static String ExpedientesParticular = "ExpedientesParticular";
        public static String CustomError = "CustomError";
        public static String ErrorAcceso = "Información de acceso no válido.";
        public static String ERR = "ERR";
        public static String OlvideCon = "OlvideContrasenia";
        public static String diag = "/";
        public static String OK = "OK";
        public static String VAL = "VAL";
        public static String NO = "NO";
        public static String TAM = "TAM";
        public static string EXT = "EXT";
        public static int TamanioMinContrasenia = 8;
        public static int TamanioMaxContrasenia = 16;
        public static String ExpCorre = "\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
        public static int TamanioBloquePeticiones = 10000;
        public const string ArchivoLogo = @"^.*\.(jpg|gif|jpeg|png|bmp|JPG|GIF|JPEG|PNG|BMP)$";
        public const string FormatoIncorrectoArchivoLogo = "Selecciona un archivo (jpg,gif,jpeg,png,bmp).";
        public const string ArchivoExcel = @"^.*\.(xlsx|XLSX)$";
        public const string FormatoIncorrectoArchivoExcel = "Selecciona un archivo xslx.";
        public const string EMAil = @"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)(@([\w\-]+)((\.(\w){2,3})+))?$";
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
            Otros = 4
        }

        public enum Catalogo
        {
            Tipo_Gestión,
        }

        public enum Subcatalogo
        {
            Estatus_Tipo_Gestion
        }
    }
}