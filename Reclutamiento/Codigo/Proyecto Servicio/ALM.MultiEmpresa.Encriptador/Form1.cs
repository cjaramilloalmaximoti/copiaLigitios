using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Security.Cryptography;
using ALM.ServicioAdminEmpresas.Entidades;
using ALM.ServicioAdminEmpresas.Negocio;

namespace ALM.ServicioAdminEmpresas.Encriptador
{
    public partial class Form1 : Form
    {
        private List<EReemplazarMVC> lstReemplazarMVC = null;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                NClaseEstatica.EstablecerLstReemplazarMVC();
            }
            catch { }
        }

        private void btnSalir_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnEncriptar_Click(object sender, EventArgs e)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                if (txtClave.Text == txtConfirmarClave.Text)
                {
                    utileria = new Utilerias.Utilerias();

                    lblMensaje.Text = string.Empty;
                    utileria.Clave = txtClave.Text;
                    utileria.ReemplazarMVC = chkMVC.Checked;
                    txtResultado.Text = utileria.Cifrar(txtCadena.Text);
                }
                else
                {
                    lblMensaje.Text = "Claves no coinciden";
                    txtResultado.Text = string.Empty;
                    txtCadena.Text = string.Empty;
                }
            }
            finally
            {
                utileria = null;
            }

        }

        private void btnDesencriptar_Click(object sender, EventArgs e)
        {
            Utilerias.Utilerias utileria = null;
            try
            {
                if (txtClave.Text == txtConfirmarClave.Text)
                {
                    utileria = new Utilerias.Utilerias();

                    lblMensaje.Text = string.Empty;
                    utileria.Clave = txtClave.Text;
                    utileria.ReemplazarMVC = chkMVC.Checked;
                    txtResultado.Text = utileria.Descifrar(txtCadena.Text);

                }
                else
                {
                    lblMensaje.Text = "Claves no coinciden";
                    txtResultado.Text = string.Empty;
                    txtCadena.Text = string.Empty;
                }
            }
            finally
            {
                utileria = null;
            }
        }
    }
}