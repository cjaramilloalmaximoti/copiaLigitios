using ALM.Empresa.Entidades;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Utilerias
{
    public class LeerArchivoSegmento
    {

        #region campos

        private ArchivoExcel archivoExcel;
        private Sheet sheet;
        private Workbook workBook;
        private Worksheet workSheet;
        private WorkbookPart workbookPart;
        private CellFormats cellFormats;
        private NumberingFormats numberingFormats;
        private Row row;
        private List<Cell> lstCell;
        private List<Row> lstRows = null;
        private string nombreHoja = null;
        private SharedStringTablePart sharedStringTablePart = null;

        #endregion

        public void Finalizar()
        {
            archivoExcel = null;
            sheet = null;
            workBook = null;
            workSheet = null;
            workbookPart = null;
            row = null;
            lstCell = null;
            lstRows = null;
            nombreHoja = null;
            sharedStringTablePart = null;
            cellFormats = null;
            numberingFormats = null;
        }

        /*
        public List<EColumnaSegmento> ObteneEncabezadoExcel(string rutaArchivoExcel, int idEmpresa, int idSegmento)
        {
            byte[] bytesLeidos = new Byte[0];
            MemoryStream objMs = null;
            List<EColumnaSegmento> lstEncabezados = null;
            object valor = null;
            try
            {
                archivoExcel = new ArchivoExcel();
                objMs = new MemoryStream();
                bytesLeidos = File.ReadAllBytes(rutaArchivoExcel);
                objMs.Write(bytesLeidos, 0, bytesLeidos.Length);
                lstEncabezados = new List<EColumnaSegmento>();
                using (SpreadsheetDocument excel = SpreadsheetDocument.Open(objMs, true))
                {
                    workBook = archivoExcel.EncontrarWorkBook(excel);
                    workbookPart = excel.WorkbookPart;
                    sharedStringTablePart = workbookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
                    cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.CellFormats;
                    numberingFormats = workbookPart.WorkbookStylesPart.Stylesheet.NumberingFormats;

                    sheet = archivoExcel.EncontrarPrimeraHojaSheet(workBook);

                    if (sheet != null)
                    {
                        workSheet = archivoExcel.EncontrarWorksheet(excel, sheet);
                        row = archivoExcel.ObtenerFilaIgual(workSheet, 1);
                        if (row != null)
                        {
                            lstCell = row.Elements<Cell>().ToList<Cell>();
                            foreach (Cell celda in lstCell)
                            {
                                valor = archivoExcel.ObtenerValorCelda(sharedStringTablePart, cellFormats, numberingFormats, celda);                               
                                lstEncabezados.Add(new EColumnaSegmento()
                                {
                                    IdEmpresa = idEmpresa,
                                    IdSegmento = idSegmento,
                                    Encabezado = valor.ToString(),
                                    Columna = celda.CellReference.Value.Replace(row.RowIndex.ToString(), string.Empty)
                                });
                            }
                        }
                        else
                        {
                            throw new System.ArgumentException("El archivo de excel no contiene renglon encabezado");
                        }
                    }
                    else
                    {
                        throw new System.ArgumentException("No se obtuvo información del archivo");
                    }
                }
                return lstEncabezados;
            }
            finally
            {
                if (objMs != null)
                {
                    objMs.Close();
                    objMs.Dispose();
                    objMs = null;
                }
                bytesLeidos = null;
                workBook = null;
                lstEncabezados = null;
                valor = null;
                Finalizar();
            }
        }

        public List<EDeudor> ObteneDeudoresExcel(string rutaArchivoExcel, List<EMapeoColumnasSegmento> lstMapeoColumnas, int idEmpresa, int idSegmento)
        {
            byte[] bytesLeidos = new Byte[0];
            MemoryStream objMs = null;
            List<EDeudor> lstDeudor = null;
            object valor = null;
            EDeudor deudor = null;
            Type tipo = null;
            List<PropertyInfo> lstPropiedades = null;
            PropertyInfo propiedad = null;
            Cell celda = null;
            Decimal? decimalNulo = null;
            Decimal? decimalNuloValor = null;
            Int32? entero32Nulo = null;
            Int32? entero32NuloValor = null;
            Int64? entero64Nulo = null;
            Int64? entero64NuloValor = null;
            DateTime? fechaNulo = null;
            DateTime? fechaNuloValor = null;
            bool? boolNulo = null;
            bool? boolNuloValor = null;
            int renglonFalla = 0;
            string columnaFalla = null;
            string propiedadFalla = null;
            try
            {
                archivoExcel = new ArchivoExcel();
                objMs = new MemoryStream();
                bytesLeidos = File.ReadAllBytes(rutaArchivoExcel);
                objMs.Write(bytesLeidos, 0, bytesLeidos.Length);
                lstDeudor = new List<EDeudor>();
                using (SpreadsheetDocument excel = SpreadsheetDocument.Open(objMs, true))
                {
                    workBook = archivoExcel.EncontrarWorkBook(excel);
                    workbookPart = excel.WorkbookPart;
                    sharedStringTablePart = workbookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
                    cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.CellFormats;
                    numberingFormats = workbookPart.WorkbookStylesPart.Stylesheet.NumberingFormats;

                    sheet = archivoExcel.EncontrarPrimeraHojaSheet(workBook);

                    if (sheet != null)
                    {
                        workSheet = archivoExcel.EncontrarWorksheet(excel, sheet);
                        lstRows = archivoExcel.ObtenerFilasMayorOIgual(workSheet, 2);
                        if (lstRows != null && lstRows.Count > 0)
                        {
                            foreach (Row rowT in lstRows)
                            {
                                renglonFalla = int.Parse(rowT.RowIndex.ToString());
                                deudor = new EDeudor();
                                deudor.IdEmpresa = idEmpresa;
                                deudor.IdSegmento = idSegmento;
                                deudor.RowIndex = int.Parse(rowT.RowIndex.ToString());
                                tipo = deudor.GetType();
                                lstPropiedades = tipo.GetProperties().ToList<PropertyInfo>();
                                lstCell = rowT.Elements<Cell>().ToList<Cell>();
                                try
                                {
                                    foreach (EMapeoColumnasSegmento mapeo in lstMapeoColumnas)
                                    {
                                        columnaFalla = mapeo.Columna;
                                        propiedadFalla = mapeo.Propiedad;
                                        propiedad = lstPropiedades.Find(x => x.Name.ToUpper().Equals(mapeo.Propiedad.ToUpper()));
                                        if (propiedad != null)
                                        {
                                            celda = archivoExcel.ObtenerCeldaAEditar(lstCell, mapeo.Columna, rowT.RowIndex);
                                            valor = archivoExcel.ObtenerValorCelda(sharedStringTablePart, cellFormats, numberingFormats, celda);

                                            if (propiedad.PropertyType == typeof(Decimal))
                                            {
                                                if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                {
                                                    valor = Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N20"));
                                                }
                                            }
                                            else
                                                if (propiedad.PropertyType == typeof(Decimal?))
                                                {
                                                    if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                    {
                                                        decimalNuloValor = Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N20"));
                                                        valor = decimalNuloValor;
                                                    }
                                                    else
                                                    {
                                                        valor = decimalNulo;
                                                    }
                                                }
                                                else
                                                    if (propiedad.PropertyType == typeof(Int32))
                                                    {
                                                        if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                        {
                                                            valor = int.Parse(Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N0")).ToString());
                                                        }
                                                    }
                                                    else
                                                        if (propiedad.PropertyType == typeof(Int32?))
                                                        {
                                                            if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                            {
                                                                entero32NuloValor = int.Parse(Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N0")).ToString());
                                                                valor = entero32NuloValor;
                                                            }
                                                            else
                                                            {
                                                                valor = entero32Nulo;
                                                            }
                                                        }
                                                        else
                                                            if (propiedad.PropertyType == typeof(Int64))
                                                            {
                                                                if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                                {
                                                                    valor = Int64.Parse(Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N0")).ToString());
                                                                }
                                                            }
                                                            else
                                                                if (propiedad.PropertyType == typeof(Int64?))
                                                                {
                                                                    if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                                    {
                                                                        entero64NuloValor = Int64.Parse(Decimal.Parse(Decimal.Parse(valor.ToString().Replace("$", string.Empty).Replace(",", string.Empty).Trim(), System.Globalization.NumberStyles.Float).ToString("N0")).ToString());
                                                                        valor = entero64NuloValor;
                                                                    }
                                                                    else
                                                                    {
                                                                        valor = entero64Nulo;
                                                                    }
                                                                }
                                                                else
                                                                    if (propiedad.PropertyType == typeof(DateTime) && (valor != null && !string.IsNullOrEmpty(valor.ToString())))
                                                                    {
                                                                        if (valor.GetType() != typeof(DateTime))
                                                                        {
                                                                            valor = ValidarFechaNombreArchivo(valor.ToString(), null);
                                                                        }
                                                                    }
                                                                    else
                                                                        if (propiedad.PropertyType == typeof(DateTime?))
                                                                        {
                                                                            if ((valor == null || string.IsNullOrEmpty(valor.ToString())))
                                                                            {
                                                                                valor = fechaNulo;
                                                                            }
                                                                            else
                                                                                if (valor.GetType() == typeof(DateTime))
                                                                                {
                                                                                   
                                                                                }
                                                                                else
                                                                                {
                                                                                    fechaNuloValor = (DateTime?)ValidarFechaNombreArchivo(valor.ToString(), null);
                                                                                    valor = fechaNuloValor;
                                                                                }
                                                                        }
                                                                        else
                                                                            if (propiedad.PropertyType == typeof(bool))
                                                                            {
                                                                                valor = bool.Parse(valor.ToString());
                                                                            }
                                                                            else
                                                                                if (propiedad.PropertyType == typeof(bool?))
                                                                                {
                                                                                    if (valor != null && !string.IsNullOrEmpty(valor.ToString()))
                                                                                    {
                                                                                        boolNuloValor = bool.Parse(valor.ToString());
                                                                                        valor = boolNuloValor;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        valor = boolNulo;
                                                                                    }
                                                                                }
                                                                                else
                                                                                    if (propiedad.PropertyType == typeof(string))
                                                                                    {
                                                                                        valor = (valor == null || string.IsNullOrEmpty(valor.ToString())) ? string.Empty : valor.ToString().Trim();
                                                                                    }

                                            propiedad.SetValue(deudor, valor);
                                        }
                                    }
                                }
                                catch (Exception ex)
                                {
                                    deudor.Excepcion = new Exception(ex.Message + "\r\n\r\nError en Columna: " + columnaFalla + " , renglon: " + renglonFalla + " , propiedad: " + propiedadFalla, ex.InnerException);
                                }
                                lstDeudor.Add(deudor);
                            }
                        }
                        else
                        {
                            throw new System.ArgumentException("El archivo de excel no conttiene renglones con información de deudores");
                        }
                    }
                    else
                    {

                        throw new System.ArgumentException("No se obtuvo información del archivo");
                    }
                }
                return lstDeudor;
            }
            finally
            {
                if (objMs != null)
                {
                    objMs.Close();
                    objMs.Dispose();
                    objMs = null;
                }
                bytesLeidos = null;
                workBook = null;
                lstDeudor = null;
                valor = null;
                deudor = null;
                tipo = null;
                lstPropiedades = null;
                propiedad = null;
                celda = null;
                Finalizar();
            }
        }

        public List<EDeudor> ObteneDeudoresEliminarExcel(byte[] bytesLeidos, int idEmpresa, int idSegmento)
        {
            MemoryStream objMs = null;
            List<EDeudor> lstDeudor = null;
            object valor = null;
            EDeudor deudor = null;
            Type tipo = null;
            List<PropertyInfo> lstPropiedades = null;
            PropertyInfo propiedad = null;
            Cell celda = null;
            int renglonFalla = 0;
            string columnaFalla = null;
            string columna = null;
            try
            {
                archivoExcel = new ArchivoExcel();
                objMs = new MemoryStream();
                objMs.Write(bytesLeidos, 0, bytesLeidos.Length);
                lstDeudor = new List<EDeudor>();
                using (SpreadsheetDocument excel = SpreadsheetDocument.Open(objMs, true))
                {
                    workBook = archivoExcel.EncontrarWorkBook(excel);
                    workbookPart = excel.WorkbookPart;
                    sharedStringTablePart = workbookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
                    cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.CellFormats;
                    numberingFormats = workbookPart.WorkbookStylesPart.Stylesheet.NumberingFormats;

                    sheet = archivoExcel.EncontrarPrimeraHojaSheet(workBook);

                    if (sheet != null)
                    {
                        workSheet = archivoExcel.EncontrarWorksheet(excel, sheet);
                        row = archivoExcel.ObtenerFilaIgual(workSheet, 1);
                        if (row != null)
                        {
                            lstCell = row.Elements<Cell>().ToList<Cell>();
                            foreach (Cell celda2 in lstCell)
                            {
                                valor = archivoExcel.ObtenerValorCelda(sharedStringTablePart, cellFormats, numberingFormats, celda2);
                                if (valor.ToString().Trim().ToUpper() == "Credito".ToUpper())
                                {
                                    columna = celda2.CellReference.Value.Replace(row.RowIndex.ToString(), string.Empty);
                                }
                            }
                        }
                        else
                        {
                            throw new System.ArgumentException("El archivo de excel no contiene renglon encabezado");
                        }

                        if (string.IsNullOrEmpty(columna))
                        {
                            throw new System.ArgumentException("El archivo de excel no contiene la columna \"Credito\" en el renglon encabezado");
                        }

                        lstRows = archivoExcel.ObtenerFilasMayorOIgual(workSheet, 2);
                        if (lstRows != null && lstRows.Count > 0)
                        {
                            foreach (Row rowT in lstRows)
                            {
                                renglonFalla = int.Parse(rowT.RowIndex.ToString());
                                deudor = new EDeudor();
                                deudor.IdEmpresa = idEmpresa;
                                deudor.IdSegmento = idSegmento;
                                deudor.RowIndex = int.Parse(rowT.RowIndex.ToString());
                                tipo = deudor.GetType();
                                lstPropiedades = tipo.GetProperties().ToList<PropertyInfo>();
                                lstCell = rowT.Elements<Cell>().ToList<Cell>();

                                columnaFalla = columna;
                                propiedad = lstPropiedades.Find(x => x.Name.ToUpper().Equals("Credito".ToUpper()));
                                if (propiedad != null)
                                {
                                    celda = archivoExcel.ObtenerCeldaAEditar(lstCell, columna, rowT.RowIndex);
                                    valor = archivoExcel.ObtenerValorCelda(sharedStringTablePart, cellFormats, numberingFormats, celda);

                                    if (propiedad.PropertyType == typeof(string))
                                    {
                                        valor = (valor == null || string.IsNullOrEmpty(valor.ToString())) ? string.Empty : valor.ToString().Trim();
                                    }

                                    propiedad.SetValue(deudor, valor);
                                }
                                lstDeudor.Add(deudor);
                            }
                        }
                        else
                        {
                            throw new System.ArgumentException("El archivo de excel no conttiene renglones con información de deudores");
                        }
                    }
                    else
                    {

                        throw new System.ArgumentException("No se obtuvo información del archivo");
                    }
                }
                return lstDeudor;
            }
            finally
            {
                if (objMs != null)
                {
                    objMs.Close();
                    objMs.Dispose();
                    objMs = null;
                }
                bytesLeidos = null;
                workBook = null;
                lstDeudor = null;
                valor = null;
                deudor = null;
                tipo = null;
                lstPropiedades = null;
                propiedad = null;
                celda = null; 
                columnaFalla = null;
                columna = null;
                Finalizar();
            }
        }

        private object ValidarFechaNombreArchivo(string fecha, string formatoFecha)
        {
            DateTime fechaDiaCarga;
            double miOADate;
            try
            {
                fechaDiaCarga = DateTime.Now;
                if (!string.IsNullOrEmpty(formatoFecha))
                {
                    if (DateTime.TryParseExact(fecha.Replace(".", string.Empty).Trim(), formatoFecha, System.Globalization.CultureInfo.GetCultureInfo("en-us"), System.Globalization.DateTimeStyles.None, out fechaDiaCarga))
                    {
                        return fechaDiaCarga;
                    }
                }
                else
                    if (DateTime.TryParse(fecha, out fechaDiaCarga))
                    {
                        return fechaDiaCarga;
                    }
                    else
                    {
                        if (double.TryParse(fecha, out miOADate))
                        {
                            return DateTime.FromOADate(miOADate);
                        }
                    }
                return null;
            }
            finally
            {
            }
        }
        */
    }

}