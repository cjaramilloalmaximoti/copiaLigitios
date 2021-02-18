using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Linq;
using Ap = DocumentFormat.OpenXml.ExtendedProperties;
using Vt = DocumentFormat.OpenXml.VariantTypes;
using X14 = DocumentFormat.OpenXml.Office2010.Excel;
using X15 = DocumentFormat.OpenXml.Office2013.Excel;

namespace ALM.Empresa.Utilerias
{
    public class ArchivoExcel
    {
        public ArchivoExcel()
        {

        }

        #region Crear Workbook desde cero para no utilizar plantilla
        
        public void InicializarWorkbook_Optimizado(SpreadsheetDocument excel, string creator)
        {
            WorkbookPart workbookPart = null;
            WorkbookStylesPart workbookStylesPart = null;
            ExtendedFilePropertiesPart extendedFilePropertiesPart = null;
            SharedStringTablePart sharedStringTablePart = null;
            try
            {
                // Add a ExtendedFilePropertiesPart to the excel.
                extendedFilePropertiesPart = excel.AddNewPart<ExtendedFilePropertiesPart>("rId3");
                GenerarContenidoExtendedFilePropertiesPart(extendedFilePropertiesPart);

                // Add a WorkbookPart to the excel.
                workbookPart = excel.AddWorkbookPart();
                GenerarContenidoWorkbookPart_Optimizado(workbookPart);

                // Add a WorkbookStylesPart to the WorkbookPart.
                workbookStylesPart = workbookPart.AddNewPart<WorkbookStylesPart>("rId3");
                GenerarContenidoWorkbookStylesPart(workbookStylesPart);

                // Add a SharedStringTablePart to the WorkbookPart.
                sharedStringTablePart = workbookPart.AddNewPart<SharedStringTablePart>("rId4");
                GenerarContenidoSharedStringTablePart(sharedStringTablePart);

                SetPackageProperties(excel, creator);
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                workbookPart = null;
                workbookStylesPart = null;
                extendedFilePropertiesPart = null;
                sharedStringTablePart = null;
            }
        }

        private void GenerarContenidoExtendedFilePropertiesPart(ExtendedFilePropertiesPart extendedFilePropertiesPart)
        {
            Ap.Properties properties = null;
            Ap.Application application = null;
            Ap.DocumentSecurity documentSecurity = null;
            Ap.ScaleCrop scaleCrop = null;
            Ap.HeadingPairs headingPairs = null;
            Vt.VTVector vTVector = null;
            Vt.Variant variant = null;
            Vt.VTLPSTR vTLPSTR = null;
            Vt.VTInt32 vTInt321 = null;
            Ap.TitlesOfParts titlesOfParts = null;
            Ap.Company company = null;
            Ap.LinksUpToDate linksUpToDate = null;
            Ap.SharedDocument sharedDocument1 = null;
            Ap.HyperlinksChanged hyperlinksChanged = null;
            Ap.ApplicationVersion applicationVersion = null;
            try
            {
                properties = new Ap.Properties();
                properties.AddNamespaceDeclaration("vt", "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes");
                application = new Ap.Application();
                application.Text = "Microsoft Excel";
                documentSecurity = new Ap.DocumentSecurity();
                documentSecurity.Text = "0";
                scaleCrop = new Ap.ScaleCrop();
                scaleCrop.Text = "false";

                headingPairs = new Ap.HeadingPairs();

                vTVector = new Vt.VTVector() { BaseType = Vt.VectorBaseValues.Variant, Size = (UInt32Value)2U };

                variant = new Vt.Variant();
                vTLPSTR = new Vt.VTLPSTR();
                vTLPSTR.Text = "Hojas de cálculo";

                variant.Append(vTLPSTR);
                vTVector.Append(variant);

                variant = new Vt.Variant();
                vTInt321 = new Vt.VTInt32();
                vTInt321.Text = "1";

                variant.Append(vTInt321);
                vTVector.Append(variant);

                headingPairs.Append(vTVector);

                titlesOfParts = new Ap.TitlesOfParts();

                vTVector = new Vt.VTVector() { BaseType = Vt.VectorBaseValues.Lpstr, Size = (UInt32Value)1U };
                vTLPSTR = new Vt.VTLPSTR();
                vTLPSTR.Text = "Reporte";

                vTVector.Append(vTLPSTR);

                titlesOfParts.Append(vTVector);
                company = new Ap.Company();
                company.Text = "";
                linksUpToDate = new Ap.LinksUpToDate();
                linksUpToDate.Text = "false";
                sharedDocument1 = new Ap.SharedDocument();
                sharedDocument1.Text = "false";
                hyperlinksChanged = new Ap.HyperlinksChanged();
                hyperlinksChanged.Text = "false";
                applicationVersion = new Ap.ApplicationVersion();
                applicationVersion.Text = "15.0300";

                properties.Append(application);
                properties.Append(documentSecurity);
                properties.Append(scaleCrop);
                properties.Append(headingPairs);
                properties.Append(titlesOfParts);
                properties.Append(company);
                properties.Append(linksUpToDate);
                properties.Append(sharedDocument1);
                properties.Append(hyperlinksChanged);
                properties.Append(applicationVersion);

                extendedFilePropertiesPart.Properties = properties;
            }
            finally
            {
                properties = null;
                application = null;
                documentSecurity = null;
                scaleCrop = null;
                headingPairs = null;
                vTVector = null;
                variant = null;
                vTLPSTR = null;
                vTInt321 = null;
                titlesOfParts = null;
                company = null;
                linksUpToDate = null;
                sharedDocument1 = null;
                hyperlinksChanged = null;
                applicationVersion = null;
            }
        }
        
        private void GenerarContenidoWorkbookPart_Optimizado(WorkbookPart workbookPart)
        {
            Workbook workbook = null;
            FileVersion fileVersion = null;
            WorkbookProperties workbookProperties = null;
            BookViews bookViews = null;
            WorkbookView workbookView = null;
            Sheets sheets = null;
            CalculationProperties calculationProperties = null;
            try
            {
                workbook = new Workbook() { MCAttributes = new MarkupCompatibilityAttributes() { Ignorable = "x15" } };
                workbook.AddNamespaceDeclaration("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
                workbook.AddNamespaceDeclaration("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006");
                workbook.AddNamespaceDeclaration("x15", "http://schemas.microsoft.com/office/spreadsheetml/2010/11/main");
                fileVersion = new FileVersion() { ApplicationName = "xl", LastEdited = "6", LowestEdited = "4", BuildVersion = "14420" };
                workbookProperties = new WorkbookProperties() { FilterPrivacy = true, DefaultThemeVersion = (UInt32Value)124226U };

                bookViews = new BookViews();
                workbookView = new WorkbookView() { XWindow = 240, YWindow = 105, WindowWidth = (UInt32Value)14805U, WindowHeight = (UInt32Value)8010U };

                bookViews.Append(workbookView);

                sheets = new Sheets();

                calculationProperties = new CalculationProperties() { CalculationId = (UInt32Value)122211U };

                workbook.Append(fileVersion);
                workbook.Append(workbookProperties);
                workbook.Append(bookViews);
                workbook.Append(sheets);
                workbook.Append(calculationProperties);

                workbookPart.Workbook = workbook;
            }
            finally
            {
                workbook = null;
                fileVersion = null;
                workbookProperties = null;
                bookViews = null;
                workbookView = null;
                sheets = null;
                calculationProperties = null;
            }
        }

        private void GenerarContenidoWorkbookStylesPart(WorkbookStylesPart workbookStylesPart)
        {
            Stylesheet stylesheet = null;
            Fonts fonts = null;
            Font font = null;
            FontSize fontSize1 = null;
            Color color = null;
            FontName fontName = null;
            FontFamilyNumbering fontFamilyNumbering = null;
            FontScheme fontScheme = null;
            Fills fills = null;
            Fill fill = null;
            PatternFill patternFill = null;
            Borders borders = null;
            Border border = null;
            LeftBorder leftBorder = null;
            RightBorder rightBorder = null;
            TopBorder topBorder = null;
            BottomBorder bottomBorder = null;
            DiagonalBorder diagonalBorder = null;
            CellStyleFormats cellStyleFormats = null;
            CellFormat cellFormat = null;
            CellFormats cellFormats = null;
            CellStyles cellStyles = null;
            CellStyle cellStyle = null;
            DifferentialFormats differentialFormats = null;
            TableStyles tableStyles = null;
            StylesheetExtensionList stylesheetExtensionList = null;
            StylesheetExtension stylesheetExtension = null;
            X14.SlicerStyles slicerStyles = null;
            X15.TimelineStyles timelineStyles = null;
            try
            {
                stylesheet = new Stylesheet() { MCAttributes = new MarkupCompatibilityAttributes() { Ignorable = "x14ac" } };
                stylesheet.AddNamespaceDeclaration("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006");
                stylesheet.AddNamespaceDeclaration("x14ac", "http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac");

                fonts = new Fonts() { Count = (UInt32Value)1U, KnownFonts = true };
                font = new Font();
                fontSize1 = new FontSize() { Val = 11D };
                color = new Color() { Theme = (UInt32Value)1U };
                fontName = new FontName() { Val = "Calibri" };
                fontFamilyNumbering = new FontFamilyNumbering() { Val = 2 };
                fontScheme = new FontScheme() { Val = FontSchemeValues.Minor };

                font.Append(fontSize1);
                font.Append(color);
                font.Append(fontName);
                font.Append(fontFamilyNumbering);
                font.Append(fontScheme);

                fonts.Append(font);

                fills = new Fills() { Count = (UInt32Value)2U };

                fill = new Fill();
                patternFill = new PatternFill() { PatternType = PatternValues.None };
                fill.Append(patternFill);
                fills.Append(fill);

                fill = new Fill();
                patternFill = new PatternFill() { PatternType = PatternValues.Gray125 };
                fill.Append(patternFill);
                fills.Append(fill);

                borders = new Borders() { Count = (UInt32Value)2U };

                border = new Border();
                leftBorder = new LeftBorder();
                rightBorder = new RightBorder();
                topBorder = new TopBorder();
                bottomBorder = new BottomBorder();
                diagonalBorder = new DiagonalBorder();

                border.Append(leftBorder);
                border.Append(rightBorder);
                border.Append(topBorder);
                border.Append(bottomBorder);
                border.Append(diagonalBorder);

                borders.Append(border);


                border = new Border();
                leftBorder = new LeftBorder() { Style = BorderStyleValues.Thin };
                color = new Color() { Auto = true };
                leftBorder.Append(color);
                rightBorder = new RightBorder() { Style = BorderStyleValues.Thin };
                color = new Color() { Auto = true };
                rightBorder.Append(color);
                topBorder = new TopBorder() { Style = BorderStyleValues.Thin };
                color = new Color() { Auto = true };
                topBorder.Append(color);
                bottomBorder = new BottomBorder() { Style = BorderStyleValues.Thin };
                color = new Color() { Auto = true };
                bottomBorder.Append(color);
                diagonalBorder = new DiagonalBorder();
                border.Append(leftBorder);
                border.Append(rightBorder);
                border.Append(topBorder);
                border.Append(bottomBorder);
                border.Append(diagonalBorder);
                borders.Append(border);


                cellStyleFormats = new CellStyleFormats() { Count = (UInt32Value)1U };
                cellFormat = new CellFormat() { NumberFormatId = (UInt32Value)0U, FontId = (UInt32Value)0U, FillId = (UInt32Value)0U, BorderId = (UInt32Value)0U };

                cellStyleFormats.Append(cellFormat);

                cellFormats = new CellFormats() { Count = (UInt32Value)1U };
                cellFormat = new CellFormat() { NumberFormatId = (UInt32Value)0U, FontId = (UInt32Value)0U, FillId = (UInt32Value)0U, BorderId = (UInt32Value)0U, FormatId = (UInt32Value)0U };

                cellFormats.Append(cellFormat);

                cellStyles = new CellStyles() { Count = (UInt32Value)1U };
                cellStyle = new CellStyle() { Name = "Normal", FormatId = (UInt32Value)0U, BuiltinId = (UInt32Value)0U };

                cellStyles.Append(cellStyle);
                differentialFormats = new DifferentialFormats() { Count = (UInt32Value)0U };
                tableStyles = new TableStyles() { Count = (UInt32Value)0U, DefaultTableStyle = "TableStyleMedium2", DefaultPivotStyle = "PivotStyleMedium9" };

                stylesheetExtensionList = new StylesheetExtensionList();

                stylesheetExtension = new StylesheetExtension() { Uri = "{EB79DEF2-80B8-43e5-95BD-54CBDDF9020C}" };
                stylesheetExtension.AddNamespaceDeclaration("x14", "http://schemas.microsoft.com/office/spreadsheetml/2009/9/main");
                slicerStyles = new X14.SlicerStyles() { DefaultSlicerStyle = "SlicerStyleLight1" };

                stylesheetExtension.Append(slicerStyles);
                stylesheetExtensionList.Append(stylesheetExtension);

                stylesheetExtension = new StylesheetExtension() { Uri = "{9260A510-F301-46a8-8635-F512D64BE5F5}" };
                stylesheetExtension.AddNamespaceDeclaration("x15", "http://schemas.microsoft.com/office/spreadsheetml/2010/11/main");
                timelineStyles = new X15.TimelineStyles() { DefaultTimelineStyle = "TimeSlicerStyleLight1" };

                stylesheetExtension.Append(timelineStyles);

                stylesheetExtensionList.Append(stylesheetExtension);

                stylesheet.Append(fonts);
                stylesheet.Append(fills);
                stylesheet.Append(borders);
                stylesheet.Append(cellStyleFormats);
                stylesheet.Append(cellFormats);
                stylesheet.Append(cellStyles);
                stylesheet.Append(differentialFormats);
                stylesheet.Append(tableStyles);
                stylesheet.Append(stylesheetExtensionList);

                workbookStylesPart.Stylesheet = stylesheet;
            }
            finally
            {
                stylesheet = null;
                fonts = null;
                font = null;
                fontSize1 = null;
                color = null;
                fontName = null;
                fontFamilyNumbering = null;
                fontScheme = null;
                fills = null;
                fill = null;
                patternFill = null;
                borders = null;
                border = null;
                leftBorder = null;
                rightBorder = null;
                topBorder = null;
                bottomBorder = null;
                diagonalBorder = null;
                cellStyleFormats = null;
                cellFormat = null;
                cellFormats = null;
                cellStyles = null;
                cellStyle = null;
                differentialFormats = null;
                tableStyles = null;
                stylesheetExtensionList = null;
                stylesheetExtension = null;
                slicerStyles = null;
                timelineStyles = null;
            }
        }
        
        public void GenerarContenidoSpreadsheetPrinterSettingsPart_Optimizado(WorksheetPart worksheetPart)
        {
            SpreadsheetPrinterSettingsPart spreadsheetPrinterSettingsPart;
            try
            {
                // Add a SpreadsheetPrinterSettingsPart to the WorksheetPart.
                spreadsheetPrinterSettingsPart = worksheetPart.AddNewPart<SpreadsheetPrinterSettingsPart>("rId1");
                System.IO.Stream data = ObtenerMemoryStreamData(spreadsheetPrinterSettingsPartData);
                spreadsheetPrinterSettingsPart.FeedData(data);
                data.Close();
            }
            finally
            {
                spreadsheetPrinterSettingsPart = null;
            }
        }

        private string spreadsheetPrinterSettingsPartData = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEEAwbcAAAAA68AAAEACQDqCm8IZAABAA8AWAICAAEAWAIDAAAATABlAHQAdABlAHIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAgAAAAEAAAD/////R0lTNAAAAAAAAAAAAAAAAA==";

        private System.IO.Stream ObtenerMemoryStreamData(string base64String)
        {
            return new System.IO.MemoryStream(System.Convert.FromBase64String(base64String));
        }

        private void GenerarContenidoSharedStringTablePart(SharedStringTablePart sharedStringTablePart)
        {
            SharedStringTable sharedStringTable = null;
            SharedStringItem sharedStringItem = null;
            Text text = null;
            try
            {
                sharedStringTable = new SharedStringTable() { Count = (UInt32Value)2U, UniqueCount = (UInt32Value)1U };

                sharedStringItem = new SharedStringItem();
                text = new Text() { Space = SpaceProcessingModeValues.Preserve };
                text.Text = " ";

                sharedStringItem.Append(text);
                sharedStringTable.Append(sharedStringItem);
                sharedStringTablePart.SharedStringTable = sharedStringTable;
            }
            finally
            {
                sharedStringTable = null;
                sharedStringItem = null;
                text = null;
            }
        }

        private void SetPackageProperties(SpreadsheetDocument excel, string creator)
        {
            DateTime fecha = DateTime.Now;
            excel.PackageProperties.Creator = creator;
            excel.PackageProperties.Created = System.Xml.XmlConvert.ToDateTime(fecha.ToString("yyyy-MM-ddThh:mm:ssZ"), System.Xml.XmlDateTimeSerializationMode.RoundtripKind);
            excel.PackageProperties.Modified = System.Xml.XmlConvert.ToDateTime(fecha.ToString("yyyy-MM-ddThh:mm:ssZ"), System.Xml.XmlDateTimeSerializationMode.RoundtripKind);
            excel.PackageProperties.LastModifiedBy = "";
        }

        #endregion
        
        public Workbook EncontrarWorkBook(SpreadsheetDocument excel)
        {
            Workbook workBook;
            try
            {
                if (excel != null)
                    workBook = (Workbook)excel.WorkbookPart.Workbook;
                else
                    workBook = new Workbook();
                return workBook;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                workBook = null;
            }
        }

        public Sheet EncontrarPrimeraHojaSheet(Workbook workbook)
        {
            try
            {
                if (workbook != null)
                    foreach (Sheet sheet in workbook.WorkbookPart.Workbook.Sheets)
                    {
                        return sheet;
                    }
                return null;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
        }

        public Worksheet EncontrarWorksheet(SpreadsheetDocument excel, Sheet Sheet)
        {
            Worksheet temporal;
            try
            {
                if (excel != null && Sheet != null)
                    temporal = ((WorksheetPart)excel.WorkbookPart.GetPartById(Sheet.Id.Value)).Worksheet;
                else
                    temporal = new Worksheet();
                return temporal;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                temporal = null;
            }

        }

        public List<Row> ObtenerFilasMayorOIgual(Worksheet worksheet, uint rowIndex)
        {
            List<Row> listaRows;
            IEnumerable<Row> rows;
            try
            {
                listaRows = new List<Row>();
                rows = worksheet.GetFirstChild<SheetData>().Elements<Row>();
                foreach (Row row in rows)
                {
                    if (row.RowIndex >= rowIndex)
                    {
                        listaRows.Add(row);
                    }
                }
                if (listaRows != null && listaRows.Count > 0)
                {
                    listaRows.Sort(delegate(Row x, Row y) { return int.Parse(x.RowIndex.ToString()).CompareTo(int.Parse(y.RowIndex.ToString())); });
                    return listaRows;
                }
                return listaRows;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                listaRows = null;
                rows = null;
            }
        }

        public Row ObtenerFilaIgual(Worksheet worksheet, uint rowIndex)
        {
            IEnumerable<Row> rows;
            try
            {
                rows = worksheet.GetFirstChild<SheetData>().Elements<Row>();
                foreach (Row row in rows)
                {
                    if (row.RowIndex == rowIndex)
                    {
                        return row;
                    }
                }
                return null;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                rows = null;
            }
        }

        public Cell ObtenerCeldaAEditar(IEnumerable<Cell> cells, string columnName, uint rowIndex)
        {
            try
            {
                foreach (Cell cell in cells)
                {
                    if (cell.CellReference.Value == columnName + rowIndex)
                    {
                        return cell;
                    }
                }
                return null;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
            finally
            {
                cells = null;
            }
        }

        public object ObtenerValorCelda(SharedStringTablePart sharedStringTablePart, CellFormats cellFormats, NumberingFormats numberingFormats, Cell cellTemp)
        {
            object valor;
            double miOADate;
            DateTime fecha;
            CellFormat cellFormat = null;
            NumberingFormat numberingFormat = null;
            DateTime date = DateTime.Now;
            //string formatString = null;
            try
            {
                valor = null;
                if (cellTemp != null)
                {
                    valor = cellTemp.InnerText;
                    if (cellTemp.DataType != null)
                    {
                        switch (cellTemp.DataType.Value)
                        {
                            case CellValues.SharedString:
                                if (sharedStringTablePart != null)
                                {
                                    valor = sharedStringTablePart.SharedStringTable.ElementAt(int.Parse(valor.ToString())).InnerText;
                                    if (valor.ToString().Contains("/") && DateTime.TryParseExact(valor.ToString().Replace(".", string.Empty), "dd/MM/yyyy hh:mm:ss tt", System.Globalization.CultureInfo.GetCultureInfo("en-us"), System.Globalization.DateTimeStyles.None, out date)) //Fecha
                                    {
                                        valor = date;
                                    }
                                }
                                break;
                            case CellValues.Date:
                                miOADate = double.Parse(valor.ToString());
                                fecha = DateTime.FromOADate(miOADate);
                                valor = fecha.ToString();
                                break;
                            case CellValues.Boolean:
                                switch (valor.ToString())
                                {
                                    case "0":
                                        valor = true;
                                        break;
                                    default:
                                        valor = false;
                                        break;
                                }
                                break;
                        }
                    }

                    if (!string.IsNullOrEmpty(valor.ToString()) && cellTemp.StyleIndex != null && cellTemp.StyleIndex.HasValue)
                    {
                        cellFormat = (CellFormat)(cellFormats.ElementAt(int.Parse(cellTemp.StyleIndex.Value.ToString())));
                        if (cellFormat.NumberFormatId.HasValue)
                        {
                            if (numberingFormats != null)
                            {
                                numberingFormat = numberingFormats.Cast<NumberingFormat>().SingleOrDefault(f => f.NumberFormatId.Value == cellFormat.NumberFormatId.Value);
                            }
                            if (numberingFormat != null && (numberingFormat.FormatCode.Value.Contains("yy") || numberingFormat.FormatCode.Value.Contains("yyy") || numberingFormat.FormatCode.Value.Contains("yyyy") || numberingFormat.FormatCode.Value.Contains("yyy") || numberingFormat.FormatCode.Value.Contains("h:mm:ss")))
                            {
                                if (double.TryParse(valor.ToString(), out miOADate))
                                {
                                    valor = DateTime.FromOADate(miOADate);
                                }
                                else
                                {
                                    object tmp = valor;
                                    valor = null;
                                    throw new ArgumentException("El encabezado '"+ tmp.ToString() + "' No tiene el formato correcto. Verifique y actualice el registro.");
                                }
                            }
                            else
                            {
                                if (numberingFormat == null &&
                                    ((cellFormat.NumberFormatId >= 14 && cellFormat.NumberFormatId <= 22) ||
                                    (cellFormat.NumberFormatId >= 165 && cellFormat.NumberFormatId <= 180) ||
                                    cellFormat.NumberFormatId == 278 || cellFormat.NumberFormatId == 185 || cellFormat.NumberFormatId == 196 ||
                                    cellFormat.NumberFormatId == 217 || cellFormat.NumberFormatId == 326))// Dates
                                {
                                    if (valor.ToString().Contains("/") && DateTime.TryParseExact(valor.ToString().Replace(".", string.Empty), "dd/MM/yyyy hh:mm:ss tt", System.Globalization.CultureInfo.GetCultureInfo("en-us"), System.Globalization.DateTimeStyles.None, out date)) //Fecha
                                    {
                                        valor = date;
                                    }
                                    else
                                        if (double.TryParse(valor.ToString(), out miOADate))
                                        {
                                            try
                                            {
                                                valor = DateTime.FromOADate(miOADate);
                                            }
                                            catch
                                            {
                                                return valor;
                                            }
                                        }
                                }
                            }
                        }
                    }
                }

                return valor;
            }
            finally
            {
                valor = null;
                cellFormat = null;
                numberingFormat = null;
                //formatString = null;
            }
        }

        public string ObtenerProximaColumna(string columna, int columnasDesplazar)
        {
            string cadenaAgregar = "";
            try
            {
                if (columnasDesplazar == 0)
                {
                    return columna;
                }
                int ascci = 0;
                int numeroColumna = ObtenerNumeroColumna(columna);
                numeroColumna = numeroColumna + columnasDesplazar;
                int residuo = numeroColumna % 26;
                int cociente = numeroColumna / 26;
                if (residuo == 0 && cociente != 0)
                {
                    ascci = 90;
                    cadenaAgregar = (char)(ascci) + cadenaAgregar;
                    cociente = cociente - 1;
                    ObtenerColumna(out cociente, out cadenaAgregar, cociente, cadenaAgregar);
                }
                else
                {
                    if (residuo != 0)
                    {
                        residuo = residuo - 1;
                        ascci = 65 + residuo;
                        cadenaAgregar = (char)(ascci) + cadenaAgregar;
                    }
                    if (cociente > 0)
                    {
                        ObtenerColumna(out cociente, out cadenaAgregar, cociente, cadenaAgregar);
                    }
                }
                return cadenaAgregar;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int ObtenerNumeroColumna(string nombreColumna)
        {
            int numeroColumna = 0;
            int aux = 1;
            nombreColumna = Convert.ToString(nombreColumna);
            nombreColumna = nombreColumna.ToUpper();
            try
            {
                for (int i = nombreColumna.Length - 1; i >= 0; i--)
                {
                    numeroColumna += (nombreColumna[i] - 64) * aux;
                    aux *= 26;
                }
                return numeroColumna;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ObtenerColumna(out int cociente, out string cadena, int cocienteOriginal, string cadenaOriginal)
        {
            try
            {
                cadena = cadenaOriginal;
                cociente = cocienteOriginal;
                if (cocienteOriginal != 0)
                {
                    int ascci = 0;
                    int residuo = cocienteOriginal % 26;
                    cociente = cocienteOriginal / 26;
                    if (residuo == 0 && cociente != 0)
                    {
                        ascci = 90;
                        cadena = (char)(ascci) + cadena;
                        cociente = cociente - 1;
                        ObtenerColumna(out cociente, out cadena, cociente, cadena);
                    }
                    else
                    {
                        if (residuo != 0)
                        {
                            residuo = residuo - 1;
                            ascci = 65 + residuo;
                            cadena = (char)(ascci) + cadena;
                        }
                        if (cociente > 0)
                        {
                            ObtenerColumna(out cociente, out cadena, cociente, cadena);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
