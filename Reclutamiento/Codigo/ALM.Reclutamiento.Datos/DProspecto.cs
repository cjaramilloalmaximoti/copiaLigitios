using ALM.Reclutamiento.Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using ALM.Reclutamiento.AccesoDatos;
using System.Windows.Forms;

namespace ALM.Reclutamiento.Datos
{
    public class DProspecto : Conexion
    {
        /// <summary>
        /// Obtener los Prospectos por Vacante
        /// </summary>
        /// <param name="IdVacante">Id de la Vacante a Buscar</param>
        /// <param name="IdEmpresa">Id de la Empresa a Buscar</param>
        /// <returns>Lista de Prospectos de la Vacante</returns>
        public List<EProspecto> buscarProspectosVacante(int IdVacante, int IdEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProsVacante");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", IdVacante));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", IdEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
        /// <summary>
        /// Obtener los Prospectos por Vacante
        /// </summary>
        /// <param name="IdVacante">Id de la Vacante a Buscar</param>
        /// <param name="IdEmpresa">Id de la Empresa a Buscar</param>
        /// <returns>Lista de Prospectos de la Vacante</returns>
        public List<EProspecto> buscarProspectosPorCaracteristicas(int idEmpresa, string ParametrosXML, int IdSexo, int IdEstadoCivil, int IdEscolaridad, int EdadMin, int EdadMax, int IdVacante)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectosPorCaracteristicas");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("ParametrosXML", ParametrosXML));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSexo", 1));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEstadoCivil", 1));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEscolaridad", 1));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEdadMin", 1));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEdadMax", 1));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdVacante", IdVacante));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
        /// <summary>
        /// Obtener Prospecto
        /// </summary>
        /// <param name="nombre">Nombre a Buscar</param>
        /// <param name="activo">Estatus Activo o Inactivo</param>
        /// <param name="idEmpresa">Id de la Empresa</param> 
        /// <returns>Lista de Prospectos encontrados en la BD</returns>

        public List<EProspecto> ObtenerProspectos(string nombre, int activo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectos");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

    //FSALAZAR 04/04/2019 REQ03042019 INI: Se pasan los dos nuevos valores junto con lo que ya exiten
    public List<EProspecto> ObtenerProspectosCaracteristicas(string nombre, int activo, string arrayCaracteristicas, int idEmpresa, List<ECaracteristicasGenerales> caracteristicasGenerales)
    {
      if (nombre != "") { nombre = "'%" + nombre + "%'"; }
      string[] split = arrayCaracteristicas.Split(new Char[] { '|', '^', '\"' });
      Array.Reverse(split);
      int i = 1;
      var IdCaracteristica = "";
      var Valor = "";
      var Tipo = "";
      var TipoActual = "";
      var Auxiliar = "";
      foreach (var item in split)
      {
        Console.WriteLine(item);
        if (i > 3)
        {
          i = i - 3;
        }
        if ((item != "") && (item != " ") && (item != ", "))
        {
          if ((item == "Nulo") || (item == "Mínimo") || (item == "Regular") || (item == "Alto") || (item == "Avanzado")) { i = 2; }
          switch (i)
          {
            case 1:
              if (Tipo == "") { Tipo = item; TipoActual = item; }
              else { Tipo = Tipo + " OR " + item; TipoActual = item; }
              break;
            case 2:
              if ((TipoActual != "Entero") && (TipoActual != "Fecha") && (TipoActual != "Moneda"))
              {
                if (Valor == "") { Valor = "prospectocaracteristica.Valor ='" + item + "'"; }
                else { Valor = Valor + " OR prospectocaracteristica.Valor = '" + item + "'"; }
              }
              else
              {
                if (TipoActual != "Fecha")
                {
                  if (Valor == "") { Auxiliar = item.Replace(",", " AND "); Valor = "prospectocaracteristica.Valor BETWEEN " + Auxiliar; }
                  else { Auxiliar = item.Replace(",", " AND "); Valor = Valor + " OR prospectocaracteristica.Valor BETWEEN " + Auxiliar; }
                }
                else
                {
                  if (Valor == "") { Auxiliar = item.Replace(",", "' as date) and cast('"); Valor = "STR_TO_DATE(Valor,'%d/%m/%Y') between cast('" + Auxiliar + "' as date)"; }
                  else { Auxiliar = item.Replace(",", "' as date) and cast('"); Valor = Valor + "OR STR_TO_DATE(Valor,'%d/%m/%Y') between cast('" + Auxiliar + "' as date)"; }
                }
              }
              break;
            case 3:
              if (IdCaracteristica == "") { IdCaracteristica = item + " AND " + Valor; Valor = string.Empty; }
              else { IdCaracteristica = IdCaracteristica + ") OR (prospectocaracteristica.IdCaracteristicaParticular = " + item + " AND " + Valor; Valor = string.Empty; }
              break;
          }
          i++;
        }

      }
            string textoCaracteristicas = "";
            if(caracteristicasGenerales != null)
            {
                foreach(ECaracteristicasGenerales caracteristica in caracteristicasGenerales)
                {
                    switch (caracteristica.Nombre)
                    {
                        case "Salario":
                            string[] valores = caracteristica.Valor.Split(',');
                            if(valores[0] != "")
                            {// columna SalarioInicial
                                textoCaracteristicas += " AND pro.Salario >= " + valores[0];
                            }
                            if(valores[1] != "")
                            {//columna SalarioFinal
                                textoCaracteristicas += " AND pro.SalarioFinal <= " + valores[1];
                            }
                            break;
                        case "Genero":
                            if(caracteristica.Valor != null)
                            textoCaracteristicas += " AND pro.IdSexo in (" + caracteristica.Valor + ")";
                            break;
                        case "Escolaridad":
                            if(caracteristica.Valor != null)
                            textoCaracteristicas += " AND pro.IdEscolaridad in (" + caracteristica.Valor + ")";
                            break;
                        case "Nivel":
                            if (caracteristica.Valor != null)
                                textoCaracteristicas += " AND find_in_set(NivelIngles,'" + caracteristica.Valor + "')";
                            break;
                    }
                }
            }
      try
      {

        AbrirConexion();
        accesoDatos.LimpiarParametros();
        accesoDatos.TipoComando = CommandType.StoredProcedure;
        accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectosCaracteristicasParticulares");
        accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", nombre));
        accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));
        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristica", IdCaracteristica));
        accesoDatos.ListaParametros.Add(new MySqlParameter("pValor", Valor));
        accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));
        accesoDatos.ListaParametros.Add(new MySqlParameter("pCaracteristicasGenerales", textoCaracteristicas));
                DataTable dataTable = new DataTable();
                dataTable.Columns.Add("");
        return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
      }
      catch(MySqlException mex)
      {
        if(mex.Number==1054 ||mex.Number == 1064)
          throw new Exception("Debe seleccionar un valor para cada uno de los filtros avanzados seleccionados");

        throw;
      }
      catch 
      {
        throw;
      }
      finally
      {
        CerrarConexion();
        accesoDatos.LimpiarParametros();
      }
    }

        //DESDE AQUI JARAMILLO
        public List<EProspecto> ObtenerProspectosCaracteristicasSeleccionados(string[] listaSeleccionados)
        {
            int count = 0;
            string consult = " WHERE";
            while (count < listaSeleccionados.Length)
            {
                consult = consult + " pro.IdProspecto= '" + listaSeleccionados[count]+"' ";
                //consult = consult + " concat_WS(' ',pro.Nombre, pro.Apellidos) = '"+listaSeleccionados[count]+"' ";
                count++;
                if (count<listaSeleccionados.Length)
                {
                    consult = consult + " OR ";
                }
            }

  
            try
            {
                
                AbrirConexion();
                
                accesoDatos.LimpiarParametros();
                
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectosCaracteristicasParticularesSeleccionados");
                
                accesoDatos.ListaParametros.Add(new MySqlParameter("aux", consult));
                
                DataTable dataTable = new DataTable();
                
                dataTable.Columns.Add("");
                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            catch (MySqlException mex)
            {
                if (mex.Number == 1054 || mex.Number == 1064)
                    throw new Exception("Debe seleccionar un valor para cada uno de los filtros avanzados seleccionados");

                throw;
            }
            catch
            {
                throw;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        //HASTA AQUI JARAMILLO

        public List<ECaracteristicasProspectos> ObtenerCaracteristicas(string IdCaracteristicas)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasValores");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristicas", IdCaracteristicas));
                return accesoDatos.CargarTabla().DataTableMapToList<ECaracteristicasProspectos>();
            }
            catch
            {
                throw;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }
        public List<ECaracteristicas> ObtenerCaracteristicasIds(string IdCaracteristicas)
        {
            AbrirConexion();
            accesoDatos.LimpiarParametros();
            accesoDatos.TipoComando = CommandType.StoredProcedure;
            accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtCaracteristicasIds");
            accesoDatos.ListaParametros.Add(new MySqlParameter("pIdCaracteristicas", IdCaracteristicas));
            return accesoDatos.CargarTabla().DataTableMapToList<ECaracteristicas>();
        }
        //FSALAZAR 04/04/2019 REQ03042019 FIN

        /// <summary>
        /// Obtener Prospecto por Id
        /// </summary>
        /// <param name="IdProspecto">Id Prospecto</param>
        /// <returns>Lista con el Prospecto encontrado en la BD</returns>
        public List<EProspecto> ObtenerProspectoId(int IdProspecto)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectoId");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", IdProspecto));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="catalogo"></param>
        /// <param name="activo"></param>
        /// <param name="idEmpresa"></param>
        /// <returns></returns>
        public List<ECatalogo> ObtenerDetallesCatalogo(string catalogo, int activo, int idEmpresa)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtDetallesCatalogo");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombreCatalogo", catalogo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pActivo", activo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", idEmpresa));

                return accesoDatos.CargarTabla().DataTableMapToList<ECatalogo>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Agregar un Prospecto a la BD
        /// </summary>
        /// <param name="prospecto">Datos del Prospecto a Agregar</param>
        /// <param name="idIsuarioLog">Id del Usuario Logueado</param>
        /// <returns>Valor entero del Ultimo registro Agregado</returns>
        public int InsertarProspecto(EProspecto prospecto, int idIsuarioLog)
        {
            int idProspecto = 0;
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPInsProspecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", prospecto.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", prospecto.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pApellidos", prospecto.Apellidos));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaNacimiento", prospecto.FechaNacimiento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", prospecto.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmail", prospecto.Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoMovil", prospecto.TelefonoMovil));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoOtro", prospecto.TelefonoOtro));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSexo", prospecto.IdSexo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveColonia", prospecto.Clave_Colonia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCP", prospecto.CP));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", prospecto.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalario", prospecto.Salario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalarioFinal", prospecto.SalarioFinal));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEstadoCivil", prospecto.IdEstadoCivil));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEscolaridad", prospecto.IdEscolaridad));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", prospecto.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", prospecto.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNivelIngles", prospecto.NivelIngles));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", prospecto.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFoto", prospecto.Foto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCalle", prospecto.Calle));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                else
                {
                    idProspecto = int.Parse(dt.Rows[0]["IdProspecto"].ToString());
                }
                new DBitacora().InsertarBitacora(new EBitacora()
                {
                    IdProspecto = idProspecto,
                    IdUsuarioCreacion = idIsuarioLog,
                    FechaCreacion = prospecto.FechaContacto == null? DateTime.Now: (DateTime)prospecto.FechaContacto,
                    Comentario = "Nuevo Prospecto agregado"
                });
                return idProspecto;
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Actualizar un Prospecto
        /// </summary>
        /// <param name="prospecto">Datos nuevos del Prospecto</param>
        /// <param name="idIsuarioLog">Id del Usuario Logueado</param>
        public void ActualizarProspecto(EProspecto prospecto, int idIsuarioLog)
        {
            DataTable dt = null;
            try
            {
                AbrirConexion();

                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPActProspecto");

                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdProspecto", prospecto.IdProspecto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNombre", prospecto.Nombre));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pApellidos", prospecto.Apellidos));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaNacimiento", prospecto.FechaNacimiento));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pRFC", prospecto.RFC));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEmail", prospecto.Email));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoMovil", prospecto.TelefonoMovil));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pTelefonoOtro", prospecto.TelefonoOtro));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdSexo", prospecto.IdSexo));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pClaveColonia", prospecto.Clave_Colonia));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCP", prospecto.CP));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pDireccion", prospecto.Direccion));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalario", prospecto.Salario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pSalarioFinal", prospecto.SalarioFinal));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEstadoCivil", prospecto.IdEstadoCivil));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEscolaridad", prospecto.IdEscolaridad));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdUsuarioLog", idIsuarioLog));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pEstatus", prospecto.Estatus));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pComentario", prospecto.Comentario));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pNivelIngles", prospecto.NivelIngles));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pIdEmpresa", prospecto.IdEmpresa));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFoto", prospecto.Foto));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCalle", prospecto.Calle));
                accesoDatos.ListaParametros.Add(new MySqlParameter("pFechaContacto", prospecto.FechaContacto));

                dt = accesoDatos.CargarTabla();

                if (dt.Rows[0]["ErrorMessage"] != DBNull.Value)
                {
                    throw new Exception(dt.Rows[0]["ErrorMessage"].ToString());
                }
                if(prospecto.FechaContacto != prospecto.UltimaFecha)
                {
                    int r = new DBitacora().InsertarBitacora(new EBitacora()
                    {
                        IdProspecto = prospecto.IdProspecto,
                        IdUsuarioCreacion = idIsuarioLog,
                        FechaCreacion = prospecto.FechaContacto == null ? DateTime.Now : (DateTime)prospecto.FechaContacto,
                        Comentario = "Actualizacion fecha de contacto"
                    });
                }
            }
            finally
            {
                dt = null;
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Buscar cuantos Prospectos estan Activos
        /// </summary>
        /// <param name="idEmpresa">Id de la Empresa</param>
        /// <param name="idProspecto">Id del Prospecto</param>
        /// <returns></returns>
        public int CuantosProspectosActivos(int idEmpresa, int idProspecto)
        {
            List<EProspecto> lstTemp = null;
            try
            {
                lstTemp = ObtenerProspectos(string.Empty, 1, idEmpresa);

                if (lstTemp != null && lstTemp.Count > 0)
                {
                    return lstTemp.FindAll(x => !x.IdProspecto.Equals(idProspecto)).Count;
                }
                return 0;
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

        /// <summary>
        /// Buscar Prospectos por Id de Cliente
        /// </summary>
        /// <param name="idCliente">Id del Cliente</param>
        /// <returns></returns>
        public List<EProspecto> buscarProspectosCliente(int IdCliente)
        {
            try
            {
                AbrirConexion();
                accesoDatos.LimpiarParametros();
                accesoDatos.TipoComando = CommandType.StoredProcedure;
                accesoDatos.Consulta = accesoDatos.ObtenerConsultaXml(Constante.RutaSP, "SPObtProspectoPorCliente");
                accesoDatos.ListaParametros.Add(new MySqlParameter("pCliente", IdCliente));

                return accesoDatos.CargarTabla().DataTableMapToList<EProspecto>();
            }
            finally
            {
                CerrarConexion();
                accesoDatos.LimpiarParametros();
            }
        }

    }
}
