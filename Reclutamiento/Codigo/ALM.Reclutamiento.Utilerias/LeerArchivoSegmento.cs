using ALM.Reclutamiento.Entidades;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Utilerias
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
                                if (valor == null || string.IsNullOrEmpty(valor.ToString()))
                                {
                                    throw new System.ArgumentException("El archivo de excel tiene en la celda " + celda.CellReference.Value + " un formato invalido");
                                }
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
    }
}