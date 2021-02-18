using ALM.Empresa.Datos;
using ALM.Empresa.Utilerias;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ALM.Empresa.Negocio
{
    public class NReportes
    {
        /*
        public string ObtenerReporteSabana(int? pIdCartera, int? pIdUsuario, int? pIdSegmento, int idEmpresa, int idTipoEstatus, int pActivo, string rutaArchivo)
        {
            string nombreArchivo = null;
            DataSet dtsInfoConfiguracion=null; 
            DReportes dReportes= null;
            IDataReader dataReaderReporte = null;
            try
            {
                dReportes = new DReportes();
                dtsInfoConfiguracion = dReportes.ObtenerConfiguracionReportes();
                dataReaderReporte = dReportes.ObtenerReporteSabana(pIdCartera, pIdUsuario, pIdSegmento, idEmpresa, idTipoEstatus, pActivo);

                rutaArchivo = rutaArchivo + idEmpresa.ToString() + @"\Reportes\";

                if (!Directory.Exists(rutaArchivo))
                {
                    System.IO.Directory.CreateDirectory(rutaArchivo);
                }


                nombreArchivo = new GenerarReporteExcelDataReader().GenerarReporteExcel("Reporte Sabana Deudores", rutaArchivo, "ReporteSabanaDeudores", DateTime.Now, dataReaderReporte, dtsInfoConfiguracion);

                return nombreArchivo;
            }
            finally
            {
                nombreArchivo = null;
            }
        }

        public string ObtenerReporteResumen(int? pIdCartera, int? pIdUsuario, int? pIdSegmento, int idEmpresa, int idTipoEstatus, int pActivo, string rutaArchivo)
        {
            string nombreArchivo = null;
            DataSet dtsInfoConfiguracion = null;
            DReportes dReportes = null;
            IDataReader dataReaderReporte = null;
            try
            {
                dReportes = new DReportes();
                dtsInfoConfiguracion = dReportes.ObtenerConfiguracionReportes();
                dataReaderReporte = dReportes.ObtenerReporteResumen(pIdCartera, pIdUsuario, pIdSegmento, idEmpresa, idTipoEstatus, pActivo);

                rutaArchivo = rutaArchivo + idEmpresa.ToString() + @"\Reportes\";

                if (!Directory.Exists(rutaArchivo))
                {
                    System.IO.Directory.CreateDirectory(rutaArchivo);
                }


                nombreArchivo = new GenerarReporteExcelDataReader().GenerarReporteExcel("Reporte Resumen Deudores", rutaArchivo, "ReporteResumenDeudores", DateTime.Now, dataReaderReporte, dtsInfoConfiguracion);

                return nombreArchivo;
            }
            finally
            {
                nombreArchivo = null;
            }
        }
        */
    }
}
