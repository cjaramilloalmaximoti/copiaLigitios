using ALM.Empresa.Datos;
using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text;
using System.Net;
using System.IO;

namespace ALM.Empresa.Negocio
{
    public class NCliente
    {
        
        public List<ECliente> ObtenerClientes(string razonSocial, int activo, int idEmpresa)
        {
            return new DCliente().ObtenerClientes(razonSocial, activo, idEmpresa);
        }

        public List<ECliente> ObtenerClientesCartera(string nombreComercial, int idEmpresa)
        {
            return new DCliente().ObtenerClientesCartera(nombreComercial, idEmpresa);
        }

        public List<ECliente> ObtenerClientesCarteraTodos(string nombreComercial, int idEmpresa)
        {
            return new DCliente().ObtenerClientesCarteraTodos(nombreComercial, idEmpresa);
        }

        public int InsertarCliente(ECliente cliente, int idUsuarioLog)
        {
            NFuncionesHttpClient funcion = null;
            string resultado = null;
            Utilerias.Utilerias utilerias = null;
            string resultadoValidacion = null;
            EEmpresa empresa = null;
            int cuantosUsuarios = 0;
            int cuantosClientes = 0;
            try
            {
                empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(cliente.IdEmpresa));
                if (empresa != null)
                {
                    cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(cliente.IdEmpresa, 0);
                    cuantosClientes = CuantosClientesActivos(cliente.IdEmpresa, 0) + 1;
                    funcion = new NFuncionesHttpClient();
                    Task<string>.Run(async () =>
                        await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                        EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                        empresa.Dominio + "/" +
                        (int)Constante.Origen.Clientes + "/" +
                        cuantosUsuarios.ToString() + "/" +
                        cuantosClientes.ToString() + "/" +
                        empresa.ProductKey + "/" +
                         DateTime.Now.ToString("yyyyMMdd"),
                         empresa.IdEmpresa
                        )).Wait();
                    resultado = funcion.NewItem.ToString();
                    if (!string.IsNullOrEmpty(resultado))
                    {
                        utilerias = new Utilerias.Utilerias();
                        utilerias.Clave = "";
                        utilerias.Clave = utilerias.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                        resultado = utilerias.Descifrar(resultado);
                        resultadoValidacion = resultado.Split('|')[2];
                        if (resultadoValidacion.Split('-')[0] == "1" && resultadoValidacion.Split('-')[1] == "0")
                        {
                            return new DCliente().InsertarCliente(cliente, idUsuarioLog);
                        }
                        else
                        {
                            empresa = null;
                            throw new Exception("Controlado: Le informamos que ya no puede dar de alta más clientes (" + ObtenerResultadoValidacion(resultadoValidacion) + ")");
                        }
                    }
                    else
                    {
                        empresa = null;
                        throw new Exception("Controlado: Formato incorrecto AlMaximoTI");
                    }
                }
                else
                {
                    throw new Exception("Controlado: No se encontro información de la empresa del usuario");
                }
            }
            finally
            {
                funcion = null;
                resultado = null;
                utilerias = null;
                resultadoValidacion = null;
                empresa = null;
            }
        }

        public void ActualizarCliente(ECliente cliente, int idUsuarioLog)
        {
            NFuncionesHttpClient funcion = null;
            string resultado = null;
            Utilerias.Utilerias utilerias = null;
            string resultadoValidacion = null;
            EEmpresa empresa = null;
            int cuantosUsuarios = 0;
            int cuantosClientes = 0;
            try
            {
                if (cliente.Activo)
                {
                    empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(cliente.IdEmpresa));
                    if (empresa != null)
                    {
                        cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(cliente.IdEmpresa, 0);
                        cuantosClientes = CuantosClientesActivos(cliente.IdEmpresa, cliente.IdCliente) + 1;
                        funcion = new NFuncionesHttpClient();
                        Task<string>.Run(async () =>
                            await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                            EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                            empresa.Dominio + "/" +
                            (int)Constante.Origen.Clientes + "/" +
                            cuantosUsuarios.ToString() + "/" +
                            cuantosClientes.ToString() + "/" +
                            empresa.ProductKey + "/" +
                             DateTime.Now.ToString("yyyyMMdd"),
                             empresa.IdEmpresa
                            )).Wait();
                        resultado = funcion.NewItem.ToString();
                        if (!string.IsNullOrEmpty(resultado))
                        {
                            utilerias = new Utilerias.Utilerias();
                            utilerias.Clave = "";
                            utilerias.Clave = utilerias.Descifrar(System.Configuration.ConfigurationManager.AppSettings["ALMCL01"]);
                            resultado = utilerias.Descifrar(resultado);
                            resultadoValidacion = resultado.Split('|')[2];
                            if (resultadoValidacion.Split('-')[0] == "1" && resultadoValidacion.Split('-')[1] == "0")
                            {
                                new DCliente().ActualizarCliente(cliente, idUsuarioLog);
                            }
                            else
                            {
                                empresa = null;
                                throw new Exception("Controlado: Le informamos que ya no puede activar un cliente más (" + ObtenerResultadoValidacion(resultadoValidacion) + ")");
                            }
                        }
                        else
                        {
                            empresa = null;
                            throw new Exception("Controlado: Formato incorrecto AlMaximoTI");
                        }
                    }
                }
                else
                {
                    new DCliente().ActualizarCliente(cliente, idUsuarioLog);
                }
            }
            finally
            {
                funcion = null;
                resultado = null;
                utilerias = null;
                resultadoValidacion = null;
                empresa = null;
            }
        }

        public int CuantosClientesActivos(int idEmpresa, int idCliente)
        {
            return new DCliente().CuantosClientesActivos(idEmpresa, idCliente);
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
