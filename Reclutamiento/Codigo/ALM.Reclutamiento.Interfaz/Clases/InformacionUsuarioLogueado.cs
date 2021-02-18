using ALM.Reclutamiento.Entidades;
using ALM.Reclutamiento.Negocio;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

namespace ALM.Empresa.Interfaz
{
    public static class InformacionUsuarioLogueado
    {
        public enum Privilegio
        {
            Privilegio1 = 1,
            Privilegio2 = 2,
            Privilegio3 = 4,
            Privilegio4 = 8,
            Privilegio5 = 16,
            Privilegio6 = 32,
            Privilegio7 = 64,
            Privilegio8 = 128
        }

        public enum FiltrosReportesEnSession
        {
            FiltrosTipoCatalogo
        }

        public enum DataReportesEnSession
        {
            DataReporteTipoCatalogo
        }

        public static List<EFormas> LstFormas
        {
            get
            {
                if (HttpContext.Current.Session["LstFormas"] == null)
                {
                    if (HttpContext.Current.Session["IdUsuario"] != null)
                    {
                        if (EsAdministrador)
                        {
                            HttpContext.Current.Session["LstFormas"] = new NForma().ObtenerListaFormasAdministrador(InformacionUsuarioLogueado.IdEmpresa, InformacionUsuarioLogueado.EsSuperAdministrador);
                        }
                        else
                        {
                            HttpContext.Current.Session["LstFormas"] = new NForma().ObtenerListaFormasPorUsuario(IdUsuario, InformacionUsuarioLogueado.IdEmpresa);
                        }
                    }
                    else
                    {
                        return new List<EFormas>();
                    }
                }
                return (List<EFormas>)HttpContext.Current.Session["LstFormas"];
            }
        }

        public static List<EFormas> LstFormasMenu
        {
            get
            {
                return LstFormas.FindAll(temp => temp.EsOpcionMenu && (temp.Privilegios | (int)Privilegio.Privilegio1) != 0);
            }
        }

        public static int IdUsuario
        {
            get
            {
                return int.Parse(HttpContext.Current.Session["IdUsuario"].ToString());
            }
        }

        public static int IdEmpresa
        {
            get
            {
                return int.Parse(HttpContext.Current.Session["IdEmpresa"].ToString());
            }
        }

        public static string NombreUsuario
        {
            get
            {
                return HttpContext.Current.Session["NombreCompleto"].ToString();
            }
            set
            {
                HttpContext.Current.Session["NombreCompleto"] = value;
            }
        }

        public static string CorreoElectronico
        {
            get
            {
                return HttpContext.Current.Session["CorreoElectronico"].ToString();
            }
            set
            {
                HttpContext.Current.Session["CorreoElectronico"] = value;
            }
        }

        public static bool EsSuperAdministrador
        {
            get
            {
                if (HttpContext.Current.Session["EsSuperAdministrador"] != null)
                {
                    return (bool)HttpContext.Current.Session["EsSuperAdministrador"];
                }
                else
                {
                    return false;
                }

            }
        }

        public static bool EsAdministrador
        {
            get
            {
                return (bool)HttpContext.Current.Session["EsAdministrador"];
            }
        }

        public static string CodigoSuperAdministrador
        {
            get
            {
                return HttpContext.Current.Session["CodigoSuperAdministrador"].ToString();
            }
            set
            {
                HttpContext.Current.Session["CodigoSuperAdministrador"] = value;
            }
        }

        public static string NombreComercial
        {
            get
            {
                return HttpContext.Current.Session["NombreComercial"].ToString();
            }
            set
            {
                HttpContext.Current.Session["NombreComercial"] = value;
            }
        }

        public static string RutaLogo
        {
            get
            {
                return HttpContext.Current.Session["RutaLogo"].ToString();
            }
            set
            {
                HttpContext.Current.Session["RutaLogo"] = value;
            }
        }

        public static short OrigenOperacion
        {
            get
            {
                return 1;
            }
        }

        public static int SegundosAntesFinalizarTimeOut
        {
            get
            {
                return 10000; // 10 segundos
            }
        }

        public static DateTime FechaActualizacionTimeOut
        {
            get
            {
                return (DateTime)HttpContext.Current.Session["FechaActualizacionTimeOut"];
            }
            set
            {
                HttpContext.Current.Session["FechaActualizacionTimeOut"] = value;
            }
        }

        public static string Dominio
        {
            get
            {
                return EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(IdEmpresa)).Dominio;
            }
        }

        public static void EstablecerInformacionUsuario(EUsuario usuario, string rutaLocal)
        {
            EEmpresa empresa = null;
            try
            {
                empresa = EClaseEstatica.LstEmpresa.Find(x => x.IdEmpresa.Equals(usuario.IdEmpresa));
                HttpContext.Current.Session["IdUsuario"] = usuario.IdUsuario;
                HttpContext.Current.Session["NombreCompleto"] = string.IsNullOrEmpty(usuario.NombreCompleto) ? "Sin nombre asignado" : usuario.NombreCompleto;
                HttpContext.Current.Session["CorreoElectronico"] = string.IsNullOrEmpty(usuario.CorreoElectronico) ? "Sin correo asignado" : usuario.CorreoElectronico;
                HttpContext.Current.Session["EsSuperAdministrador"] = usuario.EsSuperAdministrador;
                HttpContext.Current.Session["EsAdministrador"] = usuario.EsAdministrador;
                HttpContext.Current.Session["IdEmpresa"] = usuario.IdEmpresa;
                HttpContext.Current.Session["CodigoSuperAdministrador"] = (usuario.CodigoSuperAdministrador ?? string.Empty);
                HttpContext.Current.Session["NombreComercial"] = empresa.NombreComercial;
                HttpContext.Current.Session["RutaLogo"] = !string.IsNullOrEmpty(empresa.Logo) && File.Exists(rutaLocal + @"Imagenes\" + empresa.IdEmpresa.ToString() + @"/" + empresa.Logo) ? @"Imagenes/" + empresa.IdEmpresa.ToString() + @"/" + empresa.Logo : "Imagenes/LogoPrincipal.png";
            }
            finally
            {
                empresa = null;
            }
        }

        public static bool ValidarPermiso(string claveCodigo, Privilegio privilegioValidar)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 1 && temp.ClaveCodigo.ToUpper().Equals(claveCodigo.ToUpper()));
                if (forma != null)
                {
                    return (forma.Privilegios & (int)privilegioValidar) > 0;
                }
                else
                {
                    return false;
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static bool ValidarPermiso(string controlador, string accion, Privilegio privilegioValidar)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 1 && temp.Controlador.ToUpper().Equals(controlador.ToUpper().Replace("CONTROLLER", string.Empty)) &&
                    temp.Accion.ToUpper().Equals(accion.ToUpper()));
                if (forma != null)
                {
                    return (forma.Privilegios & (int)privilegioValidar) > 0;
                }
                else
                {
                    return false;
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static bool ValidarPermisoSpecial(string controlador, string accion, Privilegio privilegioValidar)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 1 && controlador.ToUpper().Replace("CONTROLLER", string.Empty).Contains(temp.Controlador.ToUpper()) &&
                    accion.ToUpper().Contains(temp.Accion.ToUpper()));
                if (forma != null)
                {
                    return (forma.Privilegios & (int)privilegioValidar) > 0;
                }
                else
                {
                    return false;
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static string ValidarPermisoPantalla(string controlador, string accion, Privilegio privilegioValidar)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 1 && temp.Controlador.ToUpper().Equals(controlador.ToUpper().Replace("CONTROLLER", string.Empty)) &&
                    temp.Accion.ToUpper().Equals(accion.ToUpper()));
                if (forma != null)
                {
                    return (forma.Privilegios & (int)privilegioValidar) > 0 ? string.Empty : "disabled";
                }
                else
                {
                    return "disabled";
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static string ValidarPermisoPantallaLink(string controlador, string accion, Privilegio privilegioValidar)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 1 && temp.Controlador.ToUpper().Equals(controlador.ToUpper().Replace("CONTROLLER", string.Empty)) &&
                    temp.Accion.ToUpper().Equals(accion.ToUpper()));
                if (forma != null)
                {
                    return (forma.Privilegios & (int)privilegioValidar) > 0 ? string.Empty : "linkDisabled";
                }
                else
                {
                    return "linkDisabled";
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static string ObtenerNombreCatalogo(int idTipoCatalogo)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 0 && temp.IdTipoCatalogo.Equals(idTipoCatalogo));
                if (forma != null)
                {
                    return forma.Catalogo;
                }
                else
                {
                    return "";
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static string ObtenerNombreSubCatalogo(int idTipoCatalogo)
        {
            EFormas forma = null;
            try
            {
                forma = LstFormas.Find(temp => temp.Principal == 0 && temp.IdTipoCatalogo.Equals(idTipoCatalogo));
                if (forma != null)
                {
                    return forma.SubCatalogo;
                }
                else
                {
                    return "";
                }
            }
            finally
            {
                forma = null;
            }
        }

        public static int? IdSegmento
        {
            get
            {
                int? intNulo = null;
                if (HttpContext.Current.Session["IdSegmento"] != null)
                {
                    intNulo = int.Parse(HttpContext.Current.Session["IdSegmento"].ToString());
                }
                return intNulo;
            }
            set
            {
                HttpContext.Current.Session["IdSegmento"] = value;
            }
        }

        public static int? IdDeudor
        {
            get
            {
                int? intNulo = null;
                if (HttpContext.Current.Session["IdDeudor"] != null)
                {
                    intNulo = int.Parse(HttpContext.Current.Session["IdDeudor"].ToString());
                }
                return intNulo;
            }
            set
            {
                HttpContext.Current.Session["IdDeudor"] = value;
            }
        }

        public static string NombreDeudor
        {
            get
            {
                if (HttpContext.Current.Session["NombreDeudor"] != null)
                {
                    return HttpContext.Current.Session["NombreDeudor"].ToString();
                }
                else
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Current.Session["NombreDeudor"] = value;
            }
        }

        public static string Global
        {
            get
            {
                if (HttpContext.Current.Session["Global"] != null)
                {
                    return HttpContext.Current.Session["Global"].ToString();
                }
                else
                {
                    return null;
                }
            }
            set
            {
                HttpContext.Current.Session["Global"] = value;
            }
        }

        public static bool ReactivarDeudor
        {
            get
            {
                return ValidarPermiso("SeguimientoDeudor", Privilegio.Privilegio5);
            }
        }
    }
}