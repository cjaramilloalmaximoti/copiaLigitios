using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

namespace ALM.Empresa.Interfaz
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Estilo/Bootstrap3_3_7/css/bootstrap.css",
                      "~/Estilo/Bootstrap3_3_7/css/bootstrap.min.css",
                      "~/Estilo/Bootstrap3_3_7/css/bootstrap-combined.min.css",
                      "~/Estilo/sweetalert.css")
                      );
        }
    }
}