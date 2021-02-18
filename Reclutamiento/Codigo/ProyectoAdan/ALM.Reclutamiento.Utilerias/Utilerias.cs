using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Xml.Serialization;

namespace ALM.Empresa.Utilerias
{
    public class Utilerias
    {
        private string _clave;
        public bool ReemplazarMVC;

        /// <summary>
        /// clave para desencriptar
        /// </summary>
        public string Clave
        {
            get { return _clave; }
            set { _clave = value; }
        }

        /// <summary>
        /// cifra cadenas
        /// </summary>
        /// <param name="cadena">cadena a cifrar</param>
        /// <returns>cadena cifrada</returns>
        public string Cifrar(string cadena)
        {
            byte[] llave; //Arreglo donde guardaremos la llave para el cifrado 3DES.
            byte[] arreglo = null; //Arreglo donde guardaremos la cadena descifrada.
            MD5CryptoServiceProvider md5 = null;
            TripleDESCryptoServiceProvider tripledes = null;
            ICryptoTransform convertir = null;
            byte[] resultado = null;
            try
            {
                // Ciframos utilizando el Algoritmo MD5.
                md5 = new MD5CryptoServiceProvider();
                arreglo = UTF8Encoding.UTF8.GetBytes(cadena);
                llave = md5.ComputeHash(UTF8Encoding.UTF8.GetBytes(_clave));
                md5.Clear();

                //Ciframos utilizando el Algoritmo 3DES.
                tripledes = new TripleDESCryptoServiceProvider();
                tripledes.Key = llave;
                tripledes.Mode = CipherMode.ECB;
                tripledes.Padding = PaddingMode.PKCS7;
                convertir = tripledes.CreateEncryptor(); // Iniciamos la conversión de la cadena
                resultado = convertir.TransformFinalBlock(arreglo, 0, arreglo.Length); //Arreglo de bytes donde guardaremos la cadena cifrada.
                tripledes.Clear();

                string cifrado = Convert.ToBase64String(resultado, 0, resultado.Length); // Convertimos la cadena y la regresamos.

                if (ReemplazarMVC && EClaseEstatica.LstReemplazarMVC != null && EClaseEstatica.LstReemplazarMVC.Count > 0)
                {
                    foreach (EReemplazarMVC reemplazar in EClaseEstatica.LstReemplazarMVC)
                    {
                        cifrado = cifrado.Replace(reemplazar.RealMVC, reemplazar.Reemplazar);
                    }
                }
                return cifrado;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                llave = null;
                arreglo = null;
                md5 = null;
                tripledes = null;
                convertir = null;
                resultado = null;
            }
        }

        /// <summary>
        /// Descifra cadenas
        /// </summary>
        /// <param name="cadena">cadena</param>
        /// <returns>cadena descifrada</returns>
        public string Descifrar(string cadena)
        {
            if (ReemplazarMVC && EClaseEstatica.LstReemplazarMVC != null && EClaseEstatica.LstReemplazarMVC.Count > 0)
            {
                foreach (EReemplazarMVC reemplazar in EClaseEstatica.LstReemplazarMVC)
                {
                    cadena = cadena.Replace(reemplazar.Reemplazar, reemplazar.RealMVC);
                }
            }

            byte[] llave;
            byte[] arreglo = Convert.FromBase64String(cadena); // Arreglo donde guardaremos la cadena descovertida.
            MD5CryptoServiceProvider md5 = null;
            TripleDESCryptoServiceProvider tripledes = null;
            ICryptoTransform convertir = null;
            byte[] resultado = null;
            string cadena_descifrada = null;
            try
            {
                // Ciframos utilizando el Algoritmo MD5.
                md5 = new MD5CryptoServiceProvider();
                llave = md5.ComputeHash(UTF8Encoding.UTF8.GetBytes(_clave));
                md5.Clear();

                //Ciframos utilizando el Algoritmo 3DES.
                tripledes = new TripleDESCryptoServiceProvider();
                tripledes.Key = llave;
                tripledes.Mode = CipherMode.ECB;
                tripledes.Padding = PaddingMode.PKCS7;
                convertir = tripledes.CreateDecryptor();
                resultado = convertir.TransformFinalBlock(arreglo, 0, arreglo.Length);
                tripledes.Clear();

                cadena_descifrada = UTF8Encoding.UTF8.GetString(resultado); // Obtenemos la cadena
                return cadena_descifrada; // Devolvemos la cadena
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                llave = null;
                arreglo = null;
                md5 = null;
                tripledes = null;
                convertir = null;
                resultado = null;
                cadena_descifrada = null;
            }
        }

        public static String ObjectToXMLGeneric<T>(T filter)
        {

            string xml = null;
            using (StringWriter sw = new StringWriter())
            {

                XmlSerializer xs = new XmlSerializer(typeof(T));
                xs.Serialize(sw, filter);
                try
                {
                    xml = sw.ToString();
                    xml = xml.Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>\r\n", "");
                    xml = xml.Replace("xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"", "");
                    xml = xml.Replace("\r\n", "");
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
            return xml;
        }

        public static T Deserialize<T>(string toDeserialize)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));
            StringReader textReader = new StringReader(toDeserialize);
            return (T)xmlSerializer.Deserialize(textReader);
        }

        public static string Serialize<T>(T toSerialize)
        {
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));
            StringWriter textWriter = new StringWriter();
            xmlSerializer.Serialize(textWriter, toSerialize);
            return textWriter.ToString();
        }

        public string LogError(string error, string _rutaFile, string catalogo)
        {
            try
            {
                string message = string.Format("Error generado el: {0}", DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss tt"));
                message += " al  sincronizar " + catalogo;
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;
                message += error;
                message += Environment.NewLine;
                message += "-----------------------------------------------------------";
                message += Environment.NewLine;
                string path = _rutaFile;
                using (StreamWriter writer = new StreamWriter(path, true))
                {
                    writer.WriteLine(message);
                    writer.Close();
                }

                return message;
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
