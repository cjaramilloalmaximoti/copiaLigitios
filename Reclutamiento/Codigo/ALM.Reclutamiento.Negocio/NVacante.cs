using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Datos;

namespace ALM.Reclutamiento.Negocio
{
    public class NVacante
    {
        public int InsertarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {
            NFuncionesHttpClient funcion = null;
            string resultado = null;
            Utilerias.Utilerias utilerias = null;
            string resultadoValidacion = null;
            EEmpresa empresa = null;
            int cuantosUsuarios = 0;
            int cuantosClientes = 0;
            int cuantosRegistros = 0;
            try
            {
                empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(vacante.IdEmpresa));
                if (empresa != null)
                {
                    cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(vacante.IdEmpresa, 0);
                    // cuantosClientes = CuantosClientesActivos(cliente.IdEmpresa, 0) + 1;
                    cuantosRegistros = CuantasVacantesActivas(vacante.IdEmpresa, vacante.Estatus);
                    funcion = new NFuncionesHttpClient();
                    Task<string>.Run(async () =>
                        await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                        EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                        empresa.Dominio + "/" +
                        (int)Constante.Origen.Clientes + "/" +
                        cuantosUsuarios.ToString() + "/" +
                        cuantosClientes.ToString() + "/" +
                        cuantosRegistros.ToString() + "/" +
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
                            return new DVacantes().InsertarVacante(vacante, detalles); // CAT Para Agregar las Fuentes Seccionadas
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

        public void InsertarVacante_Fuente(int IdInsertado, string detalles) {
                var auxiliar = detalles.Replace("?", IdInsertado.ToString());
            try
            {
                new DVacantes().InsertarVacante_Fuente(auxiliar);
            }
            finally { 
            }
        }

        public void InsertarVacante_prospecto(int IdVacante, string detalles) 
        {
            
            try
            {
                new DVacantes().InsertarVacante_prospecto(IdVacante, detalles); 
            }
            finally
            {

            }

        }

        public void InsertarVacante_prospectoInvitado(EVacante vacante, EProspecto[] prospectos, string detalles)
        {
            DVacantes datos = null;
            DBitacora bitacora = null;
            try
            {
                datos = new DVacantes();
                bitacora = new DBitacora();
                datos.InsertarVacante_prospecto(0, detalles);
                foreach(EProspecto prospecto in prospectos)
                {
                    datos.EnviarCorreo(vacante, prospecto);
                    bitacora.InsertarBitacora(new EBitacora()
                    {
                        IdProspecto = prospecto.IdProspecto,
                        Comentario = "Se envió un correo de invitación a la vacante: " + vacante.Titulo,
                        IdUsuarioCreacion = vacante.IdUsuarioUltimoModifico
                    });
                }
            }
            finally
            {
                datos = null;
                bitacora = null;
            }

        }

        public List<EVacante> ObtenerVacantes(EVacante prmVacante)
        {
            return new DVacantes().ObtenerVacantes(prmVacante);
        }

        public void ActualizarVacante(EVacante vacante, string detalles) // CAT Para Agregar las Fuentes Seccionadas
        {
            NFuncionesHttpClient funcion = null;
            string resultado = null;
            Utilerias.Utilerias utilerias = null;
            string resultadoValidacion = null;
            EEmpresa empresa = null;
            int cuantosUsuarios = 0;
            int cuantosClientes = 0;
            int cuantosRegistros = 0;

            try
            {
                if (vacante.Estatus==1)
                {
                    empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(vacante.IdEmpresa));
                    if (empresa != null)
                    {
                        cuantosUsuarios = new DUsuario().CuantosUsuariosActivos(vacante.IdEmpresa, 0);
                        // cuantosClientes = CuantosClientesActivos(vacante.IdEmpresa, vacante.IdCliente) + 1;
                        cuantosRegistros = CuantasVacantesActivas(vacante.IdEmpresa, vacante.Estatus);
                        funcion = new NFuncionesHttpClient();
                        Task<string>.Run(async () =>
                            await funcion.ObtenerEntidad<string>(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor +
                            EClaseEstatica.LstParametro.Find(x => x.Nombre == "Empresa").Valor +
                            empresa.Dominio + "/" +
                            (int)Constante.Origen.Clientes + "/" +
                            cuantosUsuarios.ToString() + "/" +
                            cuantosClientes.ToString() + "/" +
                            cuantosRegistros.ToString() + "/" +
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
                                new DVacantes().ActualizarVacante(vacante, detalles); // CAT Para Agregar las Fuentes Seccionadas
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
                    new DVacantes().ActualizarVacante(vacante, detalles); // CAT Para Agregar las Fuentes Seccionadas
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

        /// <summary>
        /// Eliminar un prospecto de una vacante
        /// </summary>
        /// <param name="IdVacante">Id de la vacante</param>
        /// <param name="IdProspecto">Id del prospecto</param>
        /// <returns>Valor Entero de los registros afectados</returns>
        public void EliminarVacante_prospecto(int IdVacante, int IdProspecto)
        {
            try
            {
                new DVacantes().EliminarVacante_prospecto(IdVacante, IdProspecto);
            }
            finally
            {

            }
        }

        public int CuantasVacantesActivas(int idempresa, int estatus)
        {
            return new DVacantes().CuantasVacantesActivas(idempresa, estatus);
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
