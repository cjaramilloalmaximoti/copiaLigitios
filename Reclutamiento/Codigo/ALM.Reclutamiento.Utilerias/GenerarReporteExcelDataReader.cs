using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ALM.Reclutamiento.Utilerias
{
    public class GenerarReporteExcelDataReader
    {
        #region campos

        private List<ConfCelda> lstCeldas = null;
        private List<EstiloCelda> lstEstiloCelda = null;
        private List<EstiloEncabezadoTabla> lstEncabezadoEspecial = null;
        private ArchivoExcel archivoExcel;
        private Sheet sheet;
        private Workbook workBook;
        private Worksheet workSheet;
        private Cell cell;
        private uint renglonesDesplazar = 0;
        private Row row;
        private IEnumerable<Cell> lstCell;
        private string columnaInicial;
        private string columnaFinal;
        private uint renglon;
        private DocumentFormat.OpenXml.DoubleValue alturaComun;
        private string titulo = string.Empty;
        private uint renglonTitulo = 0;
        private string columnaTitulo = string.Empty;
        private uint renglonEncabezadoTabla = 0;
        private uint renglonTabla = 0;
        private string colorEncabezado = string.Empty;
        private string colorRow = string.Empty;
        private string colorFuenteEncabezado = string.Empty;
        private IDataReader dataReaderReporte = null;
        private List<string> lstNombresHojas = new List<string>();
        private int indiceHoja = 0;
        private string nombreHoja = string.Empty;
        private Regex regexTemp = null;
        private uint renglonTotalizado = uint.Parse("0");
        private string colorTotalizado = string.Empty;
        private string colorFuenteTotalizado = string.Empty;
        private int renglonesMaxArchivoExcel = 0;
        private DataSet dtsInfoConfiguracion = null;

        #endregion

        #region constructores

        /// <summary>
        /// Constructor predeterminado
        /// </summary>
        public GenerarReporteExcelDataReader()
        {
        }

        #endregion

        /// <summary>
        /// <!--Autor: Helmut Hernandez Jimenez -->
        /// </summary>
        public void Finalizar()
        {
            archivoExcel = null;
            sheet = null;
            workBook = null;
            workSheet = null;
            cell = null;
            row = null;
            lstCell = null;
            lstCeldas = null;
            lstEstiloCelda = null;
            lstEncabezadoEspecial = null;
            dataReaderReporte = null;
            columnaInicial = null;
            columnaFinal = null;
            alturaComun = null;
            titulo = null;
            colorEncabezado = null;
            colorRow = null;
            colorFuenteEncabezado = null;
            columnaTitulo = null;
            lstNombresHojas = null;
            nombreHoja = null;
            regexTemp = null;
            colorTotalizado = null;
            colorFuenteTotalizado = null;
        }

        /// <summary>
        /// Genera el archivo de excel.
        /// </summary>
        /// <param name="rutaArchivoExcel">Ruta en donde se encuentra la plantilla de excel a generar.</param>
        /// <param name="objetoBD">Objeto BD a obtener información reporte.</param> 
        /// <returns>Arreglo de byte´s para generar el archivo de excel</returns>
        public string GenerarReporteExcel(string titulo, string rutaArchivos, string nombreArchivo, DateTime fechaInicioGeneracion, IDataReader dataReaderReporte, DataSet dtsInfoConfiguracion)
        {
            WorksheetPart worksheetPart;
            int sheetIndex;
            WorkbookView workBookView = null;
            string nombreRutaArchivo = null;
            bool mostrarHoja = true;
            string formatoFechaEnNombre = null;
            string archivo = null;
            try
            {
                this.renglonesMaxArchivoExcel = 1000000;
                archivoExcel = new ArchivoExcel();
                this.dataReaderReporte = dataReaderReporte;
                this.dtsInfoConfiguracion = dtsInfoConfiguracion;
                this.titulo = titulo;

                ObtenerConfiguracionReporte();

                formatoFechaEnNombre = "_ddMMyyyy_HHmmss";

                archivo = nombreArchivo + fechaInicioGeneracion.ToString(formatoFechaEnNombre) + ".xlsx";
                nombreRutaArchivo = rutaArchivos + archivo;
                using (SpreadsheetDocument excel = SpreadsheetDocument.Create(nombreRutaArchivo, SpreadsheetDocumentType.Workbook))
                {
                    archivoExcel.InicializarWorkbook_Optimizado(excel, "AlMaximoTI");
                    workBook = archivoExcel.EncontrarWorkBook(excel);
                    GenerarEstilos();
                    mostrarHoja = true;
                    if (mostrarHoja)
                    {
                        nombreHoja = lstNombresHojas != null && lstNombresHojas.Count > 0 && indiceHoja < lstNombresHojas.Count ? lstNombresHojas[indiceHoja] : "Reporte" + (indiceHoja + 1).ToString();
                        worksheetPart = excel.WorkbookPart.AddNewPart<WorksheetPart>();
                        archivoExcel.GenerarContenidoSpreadsheetPrinterSettingsPart_Optimizado(worksheetPart);
                        sheet = new Sheet() { Id = excel.WorkbookPart.GetIdOfPart(worksheetPart), SheetId = new UInt32Value(uint.Parse((indiceHoja + 1).ToString())), Name = nombreHoja };
                        workBook.Sheets.Append(sheet);
                        using (OpenXmlWriter writer = OpenXmlWriter.Create(worksheetPart))
                        {
                            ObtenerConfiguracionColumnas();

                            writer.WriteStartElement(new Worksheet());
                            writer.WriteStartElement(new Columns());
                            GenerarColumnas(writer);
                            writer.WriteEndElement();
                            writer.WriteStartElement(new SheetData());

                            GenerarRenglonEncabezadoTabla(writer);


                            VaciarInformacionReporteSinConfiguracion(writer);

                            writer.WriteEndElement();

                            AgregarFiltros(writer);


                            writer.WriteEndElement();
                            writer.Close();
                        }

                        if (indiceHoja == 0)
                        {
                            sheetIndex = workBook.Descendants<Sheet>().ToList().IndexOf(sheet);
                            workBookView = workBook.Descendants<WorkbookView>().First();
                            workBookView.ActiveTab = Convert.ToUInt32(sheetIndex);
                        }
                    }

                    workBook.CalculationProperties.ForceFullCalculation = true;
                    workBook.CalculationProperties.FullCalculationOnLoad = true;
                }
                return archivo;
            }
            finally
            {
                if (dtsInfoConfiguracion != null)
                {
                    dtsInfoConfiguracion.Dispose();
                    dtsInfoConfiguracion = null;
                }
                if (this.dtsInfoConfiguracion != null)
                {
                    this.dtsInfoConfiguracion.Dispose();
                    this.dtsInfoConfiguracion = null;
                }
                if (dataReaderReporte != null)
                {
                    this.dataReaderReporte.Close();
                    dataReaderReporte.Dispose();
                    dataReaderReporte = null;
                }
                workBook = null;
                Finalizar();
            }
        }

        private void ObtenerConfiguracionReporte()
        {
            string cadenaTemp = null;
            try
            {
                renglonTitulo = 1;
                columnaTitulo = "A";
                renglonEncabezadoTabla = 3;
                renglonTabla = 4;
                colorEncabezado = "FF38579D";
                colorRow = "FFC0C0C0";
                colorFuenteEncabezado = "FFFFFFFF";


                if (dtsInfoConfiguracion.Tables[0].Rows.Count > 0)
                {
                    cadenaTemp = "[";
                    foreach (DataRow rowTemp in dtsInfoConfiguracion.Tables[0].Rows)
                    {
                        cadenaTemp += ((char)int.Parse(rowTemp["CaracterInvalido"].ToString()));
                    }
                    cadenaTemp += "]?";
                    regexTemp = new Regex(cadenaTemp);
                }
            }
            finally
            {
                cadenaTemp = null;
            }
        }

        private void GenerarEstilos()
        {
            Stylesheet stylesheet = null;
            CellFormats lstCellFormats = null;
            CellFormat cellFormat = null;
            Alignment alignment = null;
            NumberingFormats lstNumberingFormats = null;
            NumberingFormat numberingFormat = null;
            Fonts lstFonts = null;
            Fills lstFills = null;
            Colors lstColors = null;
            Font font = null;
            Color color = null;
            Fill fill = null;
            PatternFill patternFill = null;
            StylesheetExtensionList stylesheetExtensionList = null;
            UInt32 indiceNumero = 163;
            UInt32 indiceNumeroColor = 64;
            ForegroundColor foregroundColor = null;
            BackgroundColor backgroundColor = null;
            MruColors mruColors = null;
            string stringVacio = string.Empty;
            UInt32 fillIdEncabezado = 2U;
            UInt32 fillIdRenglonTabla = 2U;
            UInt32 fontIdEncabezado = 1U;
            UInt32 fontIdTotalizado = 1U;
            UInt32 fillIdRenglonTotalizado = 2U;
            string[] stringPuntoComa = null;
            List<string> lstColoresEncabezados = null;
            int encabezadoTemp = 1;
            try
            {
                lstEstiloCelda = new List<EstiloCelda>();

                if (dtsInfoConfiguracion.Tables.Count > 0 && dtsInfoConfiguracion.Tables[1].Rows.Count > 0)
                {
                    stylesheet = workBook.WorkbookPart.WorkbookStylesPart.Stylesheet;
                    lstFonts = stylesheet.GetFirstChild<Fonts>();
                    lstFills = stylesheet.GetFirstChild<Fills>();
                    lstCellFormats = stylesheet.GetFirstChild<CellFormats>();
                    stylesheetExtensionList = stylesheet.GetFirstChild<StylesheetExtensionList>();
                    lstNumberingFormats = new NumberingFormats() { Count = (UInt32)0 };

                    #region Estilo encabezado tabla

                    font = new Font();
                    color = new Color() { Rgb = colorFuenteEncabezado };
                    font.Append(color);
                    lstFonts.Append(font);
                    fontIdEncabezado = lstFonts.Count;
                    lstFonts.Count = lstFonts.Count + 1;

                    if (renglonTotalizado != uint.Parse("0"))
                    {
                        font = new Font();
                        color = new Color() { Rgb = colorFuenteTotalizado };
                        font.Append(color);
                        lstFonts.Append(font);
                        fontIdTotalizado = lstFonts.Count;
                        lstFonts.Count = lstFonts.Count + 1;
                    }


                    fill = new Fill();
                    patternFill = new PatternFill() { PatternType = PatternValues.Solid };
                    foregroundColor = new ForegroundColor() { Rgb = colorEncabezado };
                    backgroundColor = new BackgroundColor() { Indexed = indiceNumeroColor };
                    patternFill.Append(foregroundColor);
                    patternFill.Append(backgroundColor);
                    fill.Append(patternFill);
                    lstFills.Append(fill);
                    fillIdEncabezado = lstFills.Count;
                    lstFills.Count = lstFills.Count + 1;

                    lstEncabezadoEspecial = new List<EstiloEncabezadoTabla>();
                    lstEncabezadoEspecial.Add(new EstiloEncabezadoTabla() { IndiceFills = int.Parse(fillIdEncabezado.ToString()), IndiceEstilo = encabezadoTemp, ColorEncabezado = string.Empty });

                    fill = new Fill();
                    patternFill = new PatternFill() { PatternType = PatternValues.Solid };
                    foregroundColor = new ForegroundColor() { Rgb = colorRow };
                    indiceNumeroColor++;
                    backgroundColor = new BackgroundColor() { Indexed = indiceNumeroColor };
                    patternFill.Append(foregroundColor);
                    patternFill.Append(backgroundColor);
                    fill.Append(patternFill);
                    lstFills.Append(fill);
                    fillIdRenglonTabla = lstFills.Count;
                    lstFills.Count = lstFills.Count + 1;

                    if (renglonTotalizado != uint.Parse("0"))
                    {
                        fill = new Fill();
                        patternFill = new PatternFill() { PatternType = PatternValues.Solid };
                        foregroundColor = new ForegroundColor() { Rgb = colorTotalizado };
                        indiceNumeroColor++;
                        backgroundColor = new BackgroundColor() { Indexed = indiceNumeroColor };
                        patternFill.Append(foregroundColor);
                        patternFill.Append(backgroundColor);
                        fill.Append(patternFill);
                        lstFills.Append(fill);
                        fillIdRenglonTotalizado = lstFills.Count;
                        lstFills.Count = lstFills.Count + 1;
                    }

                    lstColors = new Colors();
                    mruColors = new MruColors();
                    color = new Color() { Rgb = colorEncabezado };
                    mruColors.Append(color);
                    color = new Color() { Rgb = colorFuenteEncabezado };
                    mruColors.Append(color);
                    color = new Color() { Rgb = colorRow };
                    mruColors.Append(color);
                    color = new Color() { Rgb = colorTotalizado };
                    mruColors.Append(color);
                    color = new Color() { Rgb = colorFuenteTotalizado };
                    mruColors.Append(color);
                    lstColors.Append(mruColors);
                    stylesheet.InsertBefore(lstColors, stylesheetExtensionList);

                    #endregion

                    //Estilo encabezado tabla especial configuración
                    if (lstEncabezadoEspecial != null && lstEncabezadoEspecial.Count > 0)
                    {
                        foreach (EstiloEncabezadoTabla estiloEncabezadoTabla in lstEncabezadoEspecial)
                        {
                            cellFormat = new CellFormat() { NumberFormatId = (UInt32)0U, FontId = fontIdEncabezado, FillId = uint.Parse(estiloEncabezadoTabla.IndiceFills.ToString()), BorderId = (UInt32)1U, FormatId = (UInt32)0U, ApplyAlignment = true, ApplyFont = true, ApplyFill = true, ApplyBorder = true };
                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Center, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                            cellFormat.Append(alignment);
                            lstCellFormats.Append(cellFormat);
                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = -1, Index = lstEstiloCelda.Count + 1, CuantosDecimales = 0 });
                        }
                    }

                    //Estilo totalizado
                    if (renglonTotalizado != uint.Parse("0"))
                    {
                        cellFormat = new CellFormat() { NumberFormatId = (UInt32)0U, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyAlignment = true, ApplyFont = true, ApplyFill = true, ApplyBorder = true };
                        alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Left, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                        cellFormat.Append(alignment);
                        lstCellFormats.Append(cellFormat);
                        lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = -2, Index = lstEstiloCelda.Count + 1, CuantosDecimales = 0, Totalizado = true });
                    }

                    //Estilo texto titulo
                    cellFormat = new CellFormat() { NumberFormatId = (UInt32)0U, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyAlignment = true };
                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Left, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                    cellFormat.Append(alignment);
                    lstCellFormats.Append(cellFormat);
                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = 0, Index = lstEstiloCelda.Count + 1, CuantosDecimales = 0 });

                    foreach (DataRow dtRow in dtsInfoConfiguracion.Tables[1].Rows)
                    {
                        if ((bool)dtRow["EsPorcentaje"]) //Porcentaje
                        {
                            indiceNumero++;
                            numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + dtRow["FormatCode"].ToString() + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                            lstNumberingFormats.Append(numberingFormat);
                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                            cellFormat.Append(alignment);
                            lstCellFormats.Append(cellFormat);
                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                            cellFormat.Append(alignment);
                            lstCellFormats.Append(cellFormat);
                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });

                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                            cellFormat.Append(alignment);
                            lstCellFormats.Append(cellFormat);
                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false, Totalizado = true });
                        }
                        else
                            if (!(bool)dtRow["EsNumero"] && !(bool)dtRow["EsFecha"]) //Texto
                            {
                                cellFormat = new CellFormat() { NumberFormatId = (UInt32)0U, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyAlignment = true };
                                alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Left, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                cellFormat.Append(alignment);
                                lstCellFormats.Append(cellFormat);
                                lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                cellFormat = new CellFormat() { NumberFormatId = (UInt32)0U, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyAlignment = true, ApplyFill = true };
                                alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Left, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                cellFormat.Append(alignment);
                                lstCellFormats.Append(cellFormat);
                                lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });
                            }
                            else
                                if (!(bool)dtRow["EsNumero"] && (bool)dtRow["EsFecha"] && dtRow["Nombre"].ToString() != "FechaSinHora") //Fecha
                                {
                                    indiceNumero++;
                                    numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + dtRow["FormatCode"].ToString() + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                                    lstNumberingFormats.Append(numberingFormat);
                                    cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                    cellFormat.Append(alignment);
                                    lstCellFormats.Append(cellFormat);
                                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                    cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                    cellFormat.Append(alignment);
                                    lstCellFormats.Append(cellFormat);
                                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });
                                }
                                else
                                    if (!(bool)dtRow["SeparacionMiles"] && (int)dtRow["CuantosDecimales"] == 0) //Entero sin separación miles
                                    {
                                        indiceNumero++;
                                        numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + dtRow["FormatCode"].ToString() + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                                        lstNumberingFormats.Append(numberingFormat);
                                        cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                                        alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                        cellFormat.Append(alignment);
                                        lstCellFormats.Append(cellFormat);
                                        lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                        cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                        alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                        cellFormat.Append(alignment);
                                        lstCellFormats.Append(cellFormat);
                                        lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });

                                        cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                        alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                        cellFormat.Append(alignment);
                                        lstCellFormats.Append(cellFormat);
                                        lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false, Totalizado = true });
                                    }
                                    else
                                        if ((bool)dtRow["SeparacionMiles"] && (int)dtRow["CuantosDecimales"] == 0) //Entero con separación miles
                                        {
                                            indiceNumero++;
                                            numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + dtRow["FormatCode"].ToString() + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                                            lstNumberingFormats.Append(numberingFormat);
                                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                            cellFormat.Append(alignment);
                                            lstCellFormats.Append(cellFormat);
                                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                            cellFormat.Append(alignment);
                                            lstCellFormats.Append(cellFormat);
                                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });

                                            cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                            alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                            cellFormat.Append(alignment);
                                            lstCellFormats.Append(cellFormat);
                                            lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false, Totalizado = true });
                                        }
                                        else
                                            if (!(bool)dtRow["SeparacionMiles"] && (int)dtRow["CuantosDecimales"] != 0) //Decimal sin separación miles
                                            {
                                                indiceNumero++;
                                                stringPuntoComa = dtRow["FormatCode"].ToString().Split(';');
                                                numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + stringPuntoComa[0] + stringVacio.PadLeft((int)dtRow["CuantosDecimales"], '0') + dtRow["FormatCodeDespues"].ToString() + ";" + dtRow["FormatCodeAntes"].ToString() + stringPuntoComa[(stringPuntoComa.Length > 1 ? 1 : 0)] + stringVacio.PadLeft((int)dtRow["CuantosDecimales"], '0') + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                                                lstNumberingFormats.Append(numberingFormat);
                                                cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                                                alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                cellFormat.Append(alignment);
                                                lstCellFormats.Append(cellFormat);
                                                lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                                cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                                alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                cellFormat.Append(alignment);
                                                lstCellFormats.Append(cellFormat);
                                                lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });

                                                cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                                alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                cellFormat.Append(alignment);
                                                lstCellFormats.Append(cellFormat);
                                                lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false, Totalizado = true });
                                            }
                                            else
                                                if ((bool)dtRow["SeparacionMiles"] && (int)dtRow["CuantosDecimales"] != 0) //Decimal con separación miles
                                                {
                                                    indiceNumero++;
                                                    stringPuntoComa = dtRow["FormatCode"].ToString().Split(';');
                                                    numberingFormat = new NumberingFormat() { NumberFormatId = indiceNumero, FormatCode = dtRow["FormatCodeAntes"].ToString() + stringPuntoComa[0] + stringVacio.PadLeft((int)dtRow["CuantosDecimales"], '0') + dtRow["FormatCodeDespues"].ToString() + ";" + dtRow["FormatCodeAntes"].ToString() + stringPuntoComa[(stringPuntoComa.Length > 1 ? 1 : 0)] + stringVacio.PadLeft((int)dtRow["CuantosDecimales"], '0') + dtRow["FormatCodeDespues"].ToString() + dtRow["FormatCodeFinal"].ToString() };
                                                    lstNumberingFormats.Append(numberingFormat);
                                                    cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = (UInt32)0U, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true };
                                                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                    cellFormat.Append(alignment);
                                                    lstCellFormats.Append(cellFormat);
                                                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = true });

                                                    cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = (UInt32)0U, FillId = fillIdRenglonTabla, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                    cellFormat.Append(alignment);
                                                    lstCellFormats.Append(cellFormat);
                                                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false });

                                                    cellFormat = new CellFormat() { NumberFormatId = numberingFormat.NumberFormatId, FontId = fontIdTotalizado, FillId = fillIdRenglonTotalizado, BorderId = (UInt32)0U, FormatId = (UInt32)0U, ApplyNumberFormat = true, ApplyAlignment = true, ApplyFill = true };
                                                    alignment = new Alignment() { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center, WrapText = true };
                                                    cellFormat.Append(alignment);
                                                    lstCellFormats.Append(cellFormat);
                                                    lstEstiloCelda.Add(new EstiloCelda() { IdTipoCelda = (int)(dtRow["Id"]), Index = lstEstiloCelda.Count + 1, CuantosDecimales = (int)(dtRow["CuantosDecimales"]), Par = false, Totalizado = true });
                                                }
                    }
                    stylesheet.InsertBefore(lstNumberingFormats, lstFonts);
                }
            }
            finally
            {
                stylesheet = null;
                lstCellFormats = null;
                cellFormat = null;
                alignment = null;
                lstNumberingFormats = null;
                numberingFormat = null;
                lstFonts = null;
                lstFills = null;
                lstColors = null;
                font = null;
                color = null;
                fill = null;
                patternFill = null;
                stylesheetExtensionList = null;
                foregroundColor = null;
                backgroundColor = null;
                mruColors = null;
                stringVacio = null;
                lstColoresEncabezados = null;
            }
        }

        private void ObtenerConfiguracionColumnas()
        {
            List<int> lstRenglones = null;
            List<uint> lst = null;
            string colActual = null;
            string colNueva = null;
            int idTipoCelda = 0;
            int indiceHojaTemp = 0;
            int indexColuma = -1;
            try
            {
                // Limpiar listas
                lst = new List<uint>();
                lstCeldas = new List<ConfCelda>();
                this.columnaInicial = null;
                this.columnaFinal = null;

                indiceHojaTemp = indiceHoja;


                lstRenglones = new List<int>();


                colActual = "A";
                foreach (DataRow dtColumn in dataReaderReporte.GetSchemaTable().Rows)
                {
                    indexColuma++;
                    colNueva = archivoExcel.ObtenerProximaColumna(colActual, indexColuma);
                    if (dataReaderReporte.GetSchemaTable().Columns.Contains("NativeDataType")) // Sybase
                    {
                        idTipoCelda = dtColumn["DataType"] == typeof(DateTime) && dtColumn["NativeDataType"].ToString() != "time" ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'DateTime'")[0]["IdTipoCelda"].ToString()) :           //Fecha
                                            dtColumn["DataType"] == typeof(DateTime) && dtColumn["NativeDataType"].ToString() == "time" ? 14 :    //Hora
                                            dtColumn["DataType"] == typeof(Int16) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int16'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Int32) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int32'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Int64) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int64'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Decimal) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Decimal'")[0]["IdTipoCelda"].ToString()) :                                                   //Decimal separación miles 2 decimales
                                            dtColumn["DataType"] == typeof(double) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Double'")[0]["IdTipoCelda"].ToString()) :                                                    //Decimal separación miles 2 decimales
                                            1;                                                                                              //Cadena carácteres
                    }
                    else // SQL
                        if (dataReaderReporte.GetSchemaTable().Columns.Contains("DataTypeName")) // SQL
                        {
                            idTipoCelda = dtColumn["DataType"] == typeof(DateTime) && dtColumn["DataTypeName"].ToString() != "time" ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'DateTime'")[0]["IdTipoCelda"].ToString()) :           //Fecha
                                            dtColumn["DataType"] == typeof(DateTime) && dtColumn["DataTypeName"].ToString() == "time" ? 14 :    //Hora
                                            dtColumn["DataType"] == typeof(Int16) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int16'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Int32) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int32'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Int64) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int64'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                            dtColumn["DataType"] == typeof(Decimal) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Decimal'")[0]["IdTipoCelda"].ToString()) :                                                   //Decimal separación miles 2 decimales
                                            dtColumn["DataType"] == typeof(double) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Double'")[0]["IdTipoCelda"].ToString()) :                                                    //Decimal separación miles 2 decimales
                                            1;
                        }
                        else // MySQL
                            if (dataReaderReporte.GetSchemaTable().Columns.Contains("DataType")) // MySQL
                            {
                                idTipoCelda = dtColumn["DataType"] == typeof(DateTime) && dtColumn["DataType"].ToString() != "time" ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'DateTime'")[0]["IdTipoCelda"].ToString()) :           //Fecha
                                                dtColumn["DataType"] == typeof(DateTime) && dtColumn["DataType"].ToString() == "time" ? 14 :    //Hora
                                                dtColumn["DataType"] == typeof(Int16) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int16'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                dtColumn["DataType"] == typeof(Int32) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int32'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                dtColumn["DataType"] == typeof(Int64) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int64'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                dtColumn["DataType"] == typeof(Decimal) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Decimal'")[0]["IdTipoCelda"].ToString()) :                                                   //Decimal separación miles 2 decimales
                                                dtColumn["DataType"] == typeof(double) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Double'")[0]["IdTipoCelda"].ToString()) :                                                    //Decimal separación miles 2 decimales
                                                1;
                            }
                            else
                            {
                                idTipoCelda = dtColumn["DataType"] == typeof(DateTime) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'DateTime'")[0]["IdTipoCelda"].ToString()) :
                                                    dtColumn["DataType"] == typeof(Int16) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int16'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                    dtColumn["DataType"] == typeof(Int32) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int32'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                    dtColumn["DataType"] == typeof(Int64) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Int64'")[0]["IdTipoCelda"].ToString()) :                                                     //Entero sin separación miles
                                                    dtColumn["DataType"] == typeof(Decimal) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Decimal'")[0]["IdTipoCelda"].ToString()) :                                                   //Decimal separación miles 2 decimales
                                                    dtColumn["DataType"] == typeof(double) ? int.Parse(dtsInfoConfiguracion.Tables[2].Select("DataType = 'Double'")[0]["IdTipoCelda"].ToString()) :                                                    //Decimal separación miles 2 decimales
                                                    1;
                            }

                    lstCeldas.Add(new ConfCelda()
                    {
                        NombreCampo = dtColumn["ColumnName"].ToString(),
                        NombreColumna = dtColumn["ColumnName"].ToString().Replace("_", " "),
                        Celda = colNueva,
                        CaracteresCelda = 29,
                        IdTipoCelda = idTipoCelda,
                        CuantosDecimales = 2,
                        EsFecha = dtColumn["DataType"] == typeof(DateTime),
                        EsNumero = dtColumn["DataType"] == typeof(Int16) || dtColumn["DataType"] == typeof(Int32) || dtColumn["DataType"] == typeof(Int64) || dtColumn["DataType"] == typeof(Decimal) || dtColumn["DataType"] == typeof(double),
                        EsPorcentaje = false
                    });
                }
                alturaComun = row != null && row.Height != null && row.Height.HasValue ? row.Height : new DocumentFormat.OpenXml.DoubleValue(15.9);

                // Obtiene columna inicial y final de tabla
                this.columnaInicial = lstCeldas[0].Celda;
                this.columnaFinal = lstCeldas[lstCeldas.Count - 1].Celda;

            }
            finally
            {
                lstRenglones = null;
                lst = null;
                colActual = null;
                colNueva = null;
            }
        }

        private void GenerarColumnas(OpenXmlWriter writer)
        {
            Column columna = null;
            UInt32Value numeroColumna = 1;
            try
            {
                if (lstCeldas != null && lstCeldas.Count > 0)
                {
                    foreach (ConfCelda confCelda in lstCeldas)
                    {
                        columna = new Column() { Min = numeroColumna, Max = numeroColumna, Width = new DocumentFormat.OpenXml.DoubleValue(double.Parse("34")), CustomWidth = true };
                        writer.WriteElement(columna);
                        numeroColumna++;
                    }
                }
            }
            finally
            {
                columna = null;
            }
        }

        private void GenerarRenglonEncabezadoTabla(OpenXmlWriter writer)
        {
            List<int> lstRenglones = null;
            try
            {
                #region  Generar renglon titulo


                lstRenglones = new List<int>();
                row = new Row() { RowIndex = renglonTitulo };
                row.CustomHeight = true;
                if (CuantosSaltosDeLinea(titulo, lstCeldas.Find(x => x.Celda.Equals("A")).CaracteresCelda) > 1)
                {
                    row.Height = (double)(15.9 * CuantosSaltosDeLinea(titulo, lstCeldas.Find(x => x.Celda.Equals("A")).CaracteresCelda));
                }
                writer.WriteStartElement(row);
                cell = new Cell() { CellReference = "A" + row.RowIndex.ToString() };
                cell.DataType = CellValues.String;
                cell.CellValue = new CellValue(titulo);
                cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(0) && !x.Totalizado).Index;
                writer.WriteElement(cell);
                writer.WriteEndElement();

                #endregion

                #region Set configuración encabezado de tabla

                if (lstCeldas != null && lstCeldas.Count > 0)
                {
                    row = new Row() { RowIndex = renglonEncabezadoTabla };
                    writer.WriteStartElement(row);
                    lstRenglones = new List<int>();
                    foreach (ConfCelda confCelda in lstCeldas)
                    {
                        cell = new Cell() { CellReference = confCelda.Celda + row.RowIndex.ToString() };
                        cell.DataType = CellValues.String;
                        cell.CellValue = new CellValue(confCelda.NombreColumna);
                        cell.StyleIndex = (uint)lstEncabezadoEspecial.Find(x => x.ColorEncabezado.Equals(string.Empty)).IndiceEstilo;
                        lstRenglones.Add(CuantosSaltosDeLinea(cell.CellValue.Text, confCelda.CaracteresCelda));
                        writer.WriteElement(cell);
                    }
                    if (lstRenglones.Count > 0 && lstRenglones.Max() > 1)
                    {
                        row.Height = (double)(15.9 * lstRenglones.Max());
                    }
                    writer.WriteEndElement();   //end of row
                }

                #endregion
            }
            finally
            {
                lstRenglones = null;
            }
        }

        private bool VaciarInformacionReporteSinConfiguracion(OpenXmlWriter writer)
        {
            bool esPar = true;
            string temporal = "0";
            string[] arrTemporal;
            DateTime date = DateTime.Now;
            int i = 0;
            object dato = null;
            int registrosExportados = 0;
            try
            {
                renglon = renglonTabla;
                renglonesDesplazar = 0;
                while (dataReaderReporte.Read())
                {
                    renglonesDesplazar++;
                    esPar = i % 2 == 0;
                    row = new Row() { RowIndex = renglon };
                    row.CustomHeight = true;
                    writer.WriteStartElement(row);
                    foreach (ConfCelda celda in lstCeldas)
                    {
                        cell = new Cell() { CellReference = celda.Celda + row.RowIndex.ToString() };
                        dato = dataReaderReporte[celda.NombreCampo];
                        if (dato != DBNull.Value && !string.IsNullOrEmpty(dato.ToString()) && !string.IsNullOrEmpty(dato.ToString().Trim()))
                        {
                            if (celda.EsFecha) //Fecha
                            {
                                if (DateTime.TryParse(dato.ToString(), out date))
                                {
                                    cell.DataType = null;
                                    cell.CellValue = new CellValue(date.ToOADate().ToString());
                                }
                                cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                            }
                            else
                                if (dato.ToString().Contains("/") && dato.ToString().Split('/').Length > 2 && DateTime.TryParse(dato.ToString(), out date)) //Fecha
                                {
                                    cell.DataType = null;
                                    cell.CellValue = new CellValue(date.ToOADate().ToString());
                                    cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(2) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                                }
                                else
                                    if (!celda.EsFecha && !celda.EsNumero && !celda.EsPorcentaje) //Texto
                                    {
                                        cell.DataType = CellValues.String;
                                        cell.CellValue = new CellValue(regexTemp.Replace(dato.ToString().Trim(), ""));
                                        cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                                    }
                                    else
                                    {
                                        string[] partsFromString = new string[] { NumberFormatInfo.CurrentInfo.NumberDecimalSeparator };

                                        arrTemporal = Decimal.Parse(dato.ToString(), System.Globalization.NumberStyles.Float).ToString().Split(partsFromString, StringSplitOptions.None);
                                        if (celda.EsPorcentaje) //Porcentaje
                                        {
                                            // Hay error en openxml con número de decimales mayores a 13
                                            if (arrTemporal.Length == 1)
                                            {
                                                temporal = arrTemporal[0];
                                            }
                                            else
                                            {
                                                temporal = arrTemporal[0] + "." + (arrTemporal[1].Length <= 13 ? arrTemporal[1] : arrTemporal[1].Substring(0, 12));
                                            }
                                            cell.DataType = CellValues.Number;
                                            cell.CellValue = new CellValue(temporal);
                                            cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                                        }
                                        else //Númerico
                                            if (celda.CuantosDecimales <= 13)
                                            {
                                                // Hay error en openxml con número de decimales mayores a 13
                                                if (arrTemporal.Length == 1)
                                                {
                                                    temporal = arrTemporal[0];
                                                }
                                                else
                                                {
                                                    temporal = arrTemporal[0] + "." + (arrTemporal[1].Length <= 13 ? arrTemporal[1] : arrTemporal[1].Substring(0, 12));
                                                }
                                                cell.DataType = CellValues.Number;
                                                cell.CellValue = new CellValue(temporal);
                                                cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                                            }
                                            else
                                            {
                                                // Hay error en openxml con número de decimales mayores a 13
                                                if (arrTemporal.Length == 1)
                                                {
                                                    temporal = arrTemporal[0];
                                                }
                                                else
                                                {
                                                    temporal = arrTemporal[0] + "." + (arrTemporal[1].Length <= 13 ? arrTemporal[1] : arrTemporal[1].Substring(0, 12));
                                                }
                                                cell.DataType = CellValues.Number;
                                                cell.CellValue = new CellValue(temporal);
                                                cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                                            }
                                    }
                        }
                        else
                        {
                            cell.StyleIndex = (uint)lstEstiloCelda.Find(x => x.IdTipoCelda.Equals(celda.IdTipoCelda) && x.Par.Equals(esPar) && !x.Totalizado).Index;
                        }
                        writer.WriteElement(cell);
                    }
                    writer.WriteEndElement();
                    renglon++;
                    i++;
                    registrosExportados++;
                    if (registrosExportados >= renglonesMaxArchivoExcel)
                    {
                        return true;
                    }
                }
                return false;
            }
            finally
            {
                temporal = null;
                dato = null;
            }
        }

        private void AgregarFiltros(OpenXmlWriter writer)
        {
            AutoFilter autoFilter = null;
            try
            {
                autoFilter = new AutoFilter() { Reference = columnaInicial + renglonEncabezadoTabla.ToString() + ":" + columnaFinal + (renglonTabla + (renglonesDesplazar > 1 ? renglonesDesplazar - 1 : 0)).ToString() };
                writer.WriteElement(autoFilter);
            }
            finally
            {
            }
        }

        private int CuantosSaltosDeLinea(string texto, int maxCaracteresPorLinea)
        {
            int maxSaltos = 0;
            try
            {
                string[] arregloTexto = texto.Split('\n');
                if (arregloTexto.Length > 1)
                {
                    for (int i = 0; i < arregloTexto.Length; i++)
                    {
                        maxSaltos += CuantosSaldosDeLinea2(arregloTexto[i], maxCaracteresPorLinea);
                    }
                }
                else
                {
                    maxSaltos += CuantosSaldosDeLinea2(arregloTexto[0], maxCaracteresPorLinea);
                }
                return maxSaltos;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
        }

        private int CuantosSaldosDeLinea2(string texto, int maxCaracteresPorLinea)
        {
            int maxSaltos = 0;
            try
            {
                maxCaracteresPorLinea = maxCaracteresPorLinea != 0 ? maxCaracteresPorLinea : 1;
                if (texto.Length > 0)
                {
                    maxSaltos = (texto.Length / maxCaracteresPorLinea) + (texto.Length % maxCaracteresPorLinea != 0 ? 1 : 0);
                }
                else
                {
                    maxSaltos = 0;
                }
                return maxSaltos;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
        }
    }
}