using ALM.ServicioAdminEmpresas.Entidades;
using ALM.ServicioAdminEmpresas.Negocio;
using System;
using System.Web.Http;

namespace ALM.ServicioAdminEmpresas.RestService.Controllers
{
    public class InicioController : ApiController
    {
        [HttpGet]
        [Route("api/v1/Inicio/Empresa/{dominio}/{origen}/{usuarios}/{clientes}/{registros}/{productKey}/{fechaLlamada}")]
        public IHttpActionResult ValidarEmpresa(string dominio, int origen, short usuarios, short clientes, Int64 registros, string productKey, int fechaLlamada)
        {
            string valor;
            string key = productKey.Replace("__", "+");
            try
            {
                valor = new NEmpresa().ValidarEmpresa(dominio, origen, usuarios, clientes, registros, key, fechaLlamada);
                return Json(valor);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpGet]
        [Route("api/v1/Inicio/SuperUsuario/{login}/{password}/{dominio}/{productKey}/{fechaLlamada}")]
        public IHttpActionResult ValidarSuperUsuario(string login, string password, string dominio, string productKey, int fechaLlamada)
        {
            string valor;
            string key = productKey.Replace("__", "+");
            try
            {
                valor = new NSuperAdministrador().ValidarSuperUsuario(login, password, dominio, key, fechaLlamada);
                return Json(valor);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpGet]
        [Route("api/v1/Inicio/LimpiarEmpresa/{codigo}/{productKey}/{fechaLlamada}")]
        public IHttpActionResult LimpiarEmpresa(string codigo, string productKey, int fechaLlamada)
        {
            string key = productKey.Replace("__", "+");
            try
            {
                return Json(new NSuperAdministrador().LimpiarEmpresa(codigo, key, fechaLlamada));
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
    }
}