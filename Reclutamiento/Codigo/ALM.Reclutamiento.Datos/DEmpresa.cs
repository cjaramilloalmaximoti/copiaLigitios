using System;
using ALM.Reclutamiento.AccesoDatos;
using ALM.Reclutamiento.Entidades;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;

namespace ALM.Reclutamiento.Datos
{
    public class DEmpresa : Conexion
    {
        public List<EEmpresa> ObtenerEmpresas(EEmpresa parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtEmpresas");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", parametro.NombreComercial));
                if (parametro.Estatus < 0)
                    parametro.Estatus = 2;
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", parametro.Estatus.ToString()));
                return accesoDatos.CargarTabla().DataTableMapToList<EEmpresa>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EEmpresa> ObtenerEmpresasID(EEmpresa parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtEmpresasID");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", parametro.Dominio));
                return accesoDatos.CargarTabla().DataTableMapToList<EEmpresa>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public List<EEmpresa> ObtenerIdEmpresaSiguiente()
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtIdEmpresaSiguiente");
                return accesoDatos.CargarTabla().DataTableMapToList<EEmpresa>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        public void RegistrarEmpresa(EEmpresa parametro)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsEmpresa");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", parametro.Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", parametro.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pProductKey", parametro.ProductKey));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAdministrador", parametro.Administrador));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", parametro.Contrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", parametro.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRutaLogo", parametro.Logo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmail", parametro.Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRepresentante", parametro.NombreRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmailRepresentante", parametro.EmailRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoRepresentante", parametro.TelefonoRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pObservaciones", parametro.Observaciones));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreOtroContacto", parametro.NombreOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmailOtroContacto", parametro.EmailOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoOtroContacto", parametro.TelefonoOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsVigente", parametro.EsVigente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroUsuarios", parametro.NumeroUsuarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroClientes", parametro.NumeroClientes));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroRegistros", parametro.NumeroRegistros));

                accesoDatos.Ejecutar();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }

        }

        public void ActualizarEmpresa(EEmpresa parametro)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                AbrirConexion();

                utileria = new Utilerias.Utilerias();
                utileria.Clave = "";
                utileria.Clave = utileria.Descifrar(System.Configuration.ConfigurationManager.AppSettings[Constante.Clave]);


                parametro.Contrasenia = utileria.Cifrar(parametro.Contrasenia);

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActEmpresa");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", parametro.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDominio", parametro.Dominio));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pProductKey", parametro.ProductKey));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pAdministrador", parametro.Administrador));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pContrasenia", parametro.Contrasenia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreComercial", parametro.NombreComercial));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC",parametro.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRutaLogo", parametro.Logo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmail", parametro.Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreRepresentante", parametro.NombreRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmailRepresentante", parametro.EmailRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoRepresentante", parametro.TelefonoRepresentante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pObservaciones", parametro.Observaciones));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreOtroContacto", parametro.NombreOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmailOtroContacto", parametro.EmailOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoOtroContacto", parametro.TelefonoOtroContacto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsActivo", parametro.EsActivo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEsVigente", parametro.EsVigente));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroUsuarios", parametro.NumeroUsuarios));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroClientes", parametro.NumeroClientes));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNumeroRegistros", parametro.NumeroRegistros));
                accesoDatos.Ejecutar();

            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
    }
}