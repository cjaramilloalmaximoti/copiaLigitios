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
    public class NUsuario
    {
        /// <summary>
        /// Valida logueo usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a 
        /// </param>
        public EUsuario ValidarUsuario(EUsuario pUsuario)
        {
            NFuncionesHttpClient funcion = null;
            string resultado = null;
            Utilerias.Utilerias utilerias = null;
            string resultadoValidacion = null;
            EUsuario usuario = null;
            EEmpresa empresa = null;
            int cuantosUsuarios = 0;
            int cuantosClientes = 0;
            try
            {
                if (pUsuario.Login.ToUpper().Contains("@AlMaximoTI.com".ToUpper()))
                {
                    if (!string.IsNullOrEmpty(pUsuario.Contrasenia) && pUsuario.Contrasenia.Split('@').Length == 2 && !string.IsNullOrEmpty(pUsuario.Contrasenia.Split('@')[0]) && !string.IsNullOrEmpty(pUsuario.Contrasenia.Split('@')[1]))
                    {
                        empresa = EClaseEstatica.LstEmpresa.Find(x => x.Dominio.ToUpper().Equals("@" + pUsuario.Contrasenia.Split('@')[1].ToUpper()));
                        if (empresa != null)
                        {
                            funcion = new NFuncionesHttpClient();
                            Task<string>.Run(async () =>
                                await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                                EClaseEstatica.LstParametro.Find(x => x.Nombre == "SuperUsuario").Valor +
                                pUsuario.Login + "/" +
                                pUsuario.Contrasenia.Split('@')[0] + "/" +
                                "@" + pUsuario.Contrasenia.Split('@')[1] + "/" +
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
                                    usuario = new EUsuario()
                                    {
                                        IdUsuario = 0,
                                        NombreCompleto = empresa.Administrador + " (ALM)",
                                        CorreoElectronico = empresa.Administrador + empresa.Dominio,
                                        EsSuperAdministrador = true,
                                        EsAdministrador = true,
                                        IdEmpresa = empresa.IdEmpresa
                                    };
                                    return usuario;
                                }
                                else
                                {
                                    empresa = null;
                                    throw new Exception("Controlado: Credenciales de la cuenta de usuario son incorrectas.");
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
                            throw new Exception("Controlado: El Dominio de la empresa no existe.");
                        }
                    }
                    else
                    {
                        throw new Exception("Controlado: Formato incorrecto AlMaximoTI");
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(pUsuario.Login) && pUsuario.Login.Split('@').Length == 2 && !string.IsNullOrEmpty(pUsuario.Login.Split('@')[0]) && !string.IsNullOrEmpty(pUsuario.Login.Split('@')[1]))
                    {
                        pUsuario.Dominio = "@" + pUsuario.Login.Split('@')[1];
                        pUsuario.Login = pUsuario.Login.Split('@')[0];
                        empresa = EClaseEstatica.LstEmpresa.Find(x => x.Dominio.ToUpper().Equals(pUsuario.Dominio.ToUpper()));
                        if (empresa != null)
                        {
                            pUsuario.IdEmpresa = empresa.IdEmpresa;
                            cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(empresa.IdEmpresa, 0);
                            cuantosClientes = new NCliente().CuantosClientesActivos(empresa.IdEmpresa, 0);
                            funcion = new NFuncionesHttpClient();
                            Task<string>.Run(async () =>
                                await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                                EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                                empresa.Dominio + "/" +
                                (int)Constante.Origen.Login + "/" +
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
                                    return usuario = new DUsuario().ValidarUsuario(pUsuario);
                                }
                                else
                                {
                                    empresa = null;
                                    string mensajeError = ObtenerResultadoValidacion(resultadoValidacion);
                                    throw new Exception("Controlado: " + mensajeError + ".");
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
                            throw new Exception("Controlado: El Dominio de la empresa no existe.");
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            finally
            {
                funcion = null;
                resultado = null;
                utilerias = null;
                resultadoValidacion = null;
            }
        }

        public bool LimpiarEmpresa(string codigo, int idEmpresa)
        {
            NFuncionesHttpClient funcion = null;
            EEmpresa empresa = null;
            bool respuesta = false;
            try
            {
                funcion = new NFuncionesHttpClient();
                empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(idEmpresa));
                if (empresa != null)
                {
                    Task<bool>.Run(async () =>
                                        await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                                        EClaseEstatica.LstParametro.Find(x => x.Nombre == "LimpiarEmpresa").Valor +
                                        codigo.Trim() + "/" +
                                        empresa.ProductKey + "/" +
                                         DateTime.Now.ToString("yyyyMMdd"),
                                         empresa.IdEmpresa
                                        )).Wait();
                    if (bool.TryParse(funcion.NewItem.ToString(), out respuesta))
                    {
                        return respuesta;
                    }
                }
                return false;
            }
            finally
            {
                funcion = null;
                empresa = null;
            }
        }

        /// <summary>
        /// Marca como en recuperacion de contraseña al usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a actualizar</param>
        public EUsuario RecuperarContraseniaUsuario(EUsuario pUsuario, short origenOperacion)
        {
            return new DUsuario().RecuperarContraseniaUsuario(pUsuario, origenOperacion);
        }

        public EUsuario ConsultarUsuarioPorId(int idUser, int idEmpresa)
        {
            return new DUsuario().ConsultarUsuarioPorId(idUser, idEmpresa);
        }

        /// <summary>
        /// Actualiza registro usuario
        /// </summary>
        /// <param name="pUsuario">Información de usuario a actualizar</param>
        public void ActualizarContraseniaUsuario(EUsuario pUsuario, int idIsuarioLog, short origenOperacion)
        {
            new DUsuario().ActualizarContraseniaUsuario(pUsuario, idIsuarioLog, origenOperacion);
            NClaseEstatica.EstablecerLstEmpresa();
        }

        public List<EUsuario> ObtenerUsuarios(string nombreCompleto, int activo, int idEmpresa)
        {
            return new DUsuario().ObtenerUsuarios(nombreCompleto, activo, idEmpresa);
        }

        public int InsertarUsuario(EUsuario usuario, List<ERol> lstRoles, int idUsuarioModifica, int idIsuarioLog, short origenOperacion)
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
                empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(usuario.IdEmpresa));
                if (empresa != null)
                {
                    cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(usuario.IdEmpresa, 0) + 1;
                    cuantosClientes = new NCliente().CuantosClientesActivos(usuario.IdEmpresa, 0);
                    funcion = new NFuncionesHttpClient();
                    Task<string>.Run(async () =>
                        await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                        EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                        empresa.Dominio + "/" +
                        (int)Constante.Origen.Usuarios + "/" +
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
                            return new DUsuario().InsertarUsuario(usuario, lstRoles, idUsuarioModifica, idIsuarioLog, origenOperacion);
                        }
                        else
                        {
                            empresa = null;
                            throw new Exception("Controlado: Le informamos que ya no puede dar de alta más usuarios (" + ObtenerResultadoValidacion(resultadoValidacion) + ")");
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

        public void ActualizarUsuario(EUsuario usuario, List<ERol> lstRoles, int idUsuarioModifica, int idIsuarioLog, short origenOperacion)
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
                if (usuario.Activo)
                {
                    empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(usuario.IdEmpresa));
                    if (empresa != null)
                    {
                        cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(usuario.IdEmpresa, usuario.IdUsuario) + 1;
                        cuantosClientes = new NCliente().CuantosClientesActivos(usuario.IdEmpresa, 0);
                        funcion = new NFuncionesHttpClient();
                        Task<string>.Run(async () =>
                            await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                            EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                            empresa.Dominio + "/" +
                            (int)Constante.Origen.Usuarios + "/" +
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
                                new DUsuario().ActualizarUsuario(usuario, lstRoles, idUsuarioModifica, idIsuarioLog, origenOperacion);
                            }
                            else
                            {
                                empresa = null;
                                throw new Exception("Controlado: Le informamos que ya no puede activar un usario más (" + ObtenerResultadoValidacion(resultadoValidacion) + ")");
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
                    new DUsuario().ActualizarUsuario(usuario, lstRoles, idUsuarioModifica, idIsuarioLog, origenOperacion);
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

        public void EliminarUsuario(int idUsuario, int idEmpresa)
        {
            new DUsuario().EliminarUsuario(idUsuario, idEmpresa);
        }

        public bool ValidarLoginUnico(string login, int idUsuario, int idEmpresa)
        {
            return new DUsuario().ValidarLoginUnico(login, idUsuario, idEmpresa);
        }

        public bool ValidarCorreoUnico(string correo, int idUsuario, int idEmpresa)
        {
            return new DUsuario().ValidarCorreoUnico(correo, idUsuario, idEmpresa);
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

        public List<ESelect2Json> ObtenerUsuariosAnalista(string nombreCompleto, int idEmpresa)
        {
            return new DUsuario().ObtenerUsuariosAnalista(nombreCompleto, idEmpresa);
        }
    }
}