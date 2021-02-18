namespace ALM.ServicioAdminEmpresas.Encriptador
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.lblClave = new System.Windows.Forms.Label();
            this.lblCadena = new System.Windows.Forms.Label();
            this.txtClave = new System.Windows.Forms.TextBox();
            this.txtCadena = new System.Windows.Forms.TextBox();
            this.txtResultado = new System.Windows.Forms.TextBox();
            this.lblResultado = new System.Windows.Forms.Label();
            this.btnDesencriptar = new System.Windows.Forms.Button();
            this.btnEncriptar = new System.Windows.Forms.Button();
            this.txtConfirmarClave = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lblMensaje = new System.Windows.Forms.Label();
            this.chkMVC = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // lblClave
            // 
            this.lblClave.AutoSize = true;
            this.lblClave.Location = new System.Drawing.Point(22, 11);
            this.lblClave.Name = "lblClave";
            this.lblClave.Size = new System.Drawing.Size(34, 13);
            this.lblClave.TabIndex = 1;
            this.lblClave.Text = "Clave";
            // 
            // lblCadena
            // 
            this.lblCadena.AutoSize = true;
            this.lblCadena.Location = new System.Drawing.Point(20, 95);
            this.lblCadena.Name = "lblCadena";
            this.lblCadena.Size = new System.Drawing.Size(44, 13);
            this.lblCadena.TabIndex = 2;
            this.lblCadena.Text = "Cadena";
            // 
            // txtClave
            // 
            this.txtClave.Location = new System.Drawing.Point(107, 11);
            this.txtClave.Name = "txtClave";
            this.txtClave.Size = new System.Drawing.Size(198, 20);
            this.txtClave.TabIndex = 1;
            this.txtClave.UseSystemPasswordChar = true;
            // 
            // txtCadena
            // 
            this.txtCadena.Location = new System.Drawing.Point(106, 62);
            this.txtCadena.Multiline = true;
            this.txtCadena.Name = "txtCadena";
            this.txtCadena.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtCadena.Size = new System.Drawing.Size(650, 82);
            this.txtCadena.TabIndex = 3;
            // 
            // txtResultado
            // 
            this.txtResultado.Location = new System.Drawing.Point(103, 244);
            this.txtResultado.Multiline = true;
            this.txtResultado.Name = "txtResultado";
            this.txtResultado.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtResultado.Size = new System.Drawing.Size(650, 95);
            this.txtResultado.TabIndex = 6;
            // 
            // lblResultado
            // 
            this.lblResultado.AutoSize = true;
            this.lblResultado.Location = new System.Drawing.Point(15, 278);
            this.lblResultado.Name = "lblResultado";
            this.lblResultado.Size = new System.Drawing.Size(55, 13);
            this.lblResultado.TabIndex = 8;
            this.lblResultado.Text = "Resultado";
            // 
            // btnDesencriptar
            // 
            this.btnDesencriptar.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDesencriptar.Image = global::ALM.ServicioAdminEmpresas.Encriptador.Properties.Resources.descifrado_icono_6874_48;
            this.btnDesencriptar.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.btnDesencriptar.Location = new System.Drawing.Point(425, 154);
            this.btnDesencriptar.Name = "btnDesencriptar";
            this.btnDesencriptar.Size = new System.Drawing.Size(329, 77);
            this.btnDesencriptar.TabIndex = 5;
            this.btnDesencriptar.Text = "DESCIFRAR";
            this.btnDesencriptar.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnDesencriptar.UseVisualStyleBackColor = true;
            this.btnDesencriptar.Click += new System.EventHandler(this.btnDesencriptar_Click);
            // 
            // btnEncriptar
            // 
            this.btnEncriptar.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnEncriptar.Image = global::ALM.ServicioAdminEmpresas.Encriptador.Properties.Resources.cifrado_icono_4320_48;
            this.btnEncriptar.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.btnEncriptar.Location = new System.Drawing.Point(103, 153);
            this.btnEncriptar.Name = "btnEncriptar";
            this.btnEncriptar.Size = new System.Drawing.Size(310, 77);
            this.btnEncriptar.TabIndex = 4;
            this.btnEncriptar.Text = "CIFRAR";
            this.btnEncriptar.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnEncriptar.UseVisualStyleBackColor = true;
            this.btnEncriptar.Click += new System.EventHandler(this.btnEncriptar_Click);
            // 
            // txtConfirmarClave
            // 
            this.txtConfirmarClave.Location = new System.Drawing.Point(106, 38);
            this.txtConfirmarClave.Name = "txtConfirmarClave";
            this.txtConfirmarClave.Size = new System.Drawing.Size(198, 20);
            this.txtConfirmarClave.TabIndex = 2;
            this.txtConfirmarClave.UseSystemPasswordChar = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(20, 38);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(81, 13);
            this.label1.TabIndex = 10;
            this.label1.Text = "Confirmar Clave";
            // 
            // lblMensaje
            // 
            this.lblMensaje.AutoSize = true;
            this.lblMensaje.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMensaje.ForeColor = System.Drawing.Color.Maroon;
            this.lblMensaje.Location = new System.Drawing.Point(295, 45);
            this.lblMensaje.Name = "lblMensaje";
            this.lblMensaje.Size = new System.Drawing.Size(0, 15);
            this.lblMensaje.TabIndex = 11;
            // 
            // chkMVC
            // 
            this.chkMVC.AutoSize = true;
            this.chkMVC.Location = new System.Drawing.Point(425, 13);
            this.chkMVC.Name = "chkMVC";
            this.chkMVC.Size = new System.Drawing.Size(179, 17);
            this.chkMVC.TabIndex = 12;
            this.chkMVC.Text = "Remplazar caracteres para MVC";
            this.chkMVC.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(797, 366);
            this.Controls.Add(this.chkMVC);
            this.Controls.Add(this.lblMensaje);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtConfirmarClave);
            this.Controls.Add(this.lblResultado);
            this.Controls.Add(this.txtResultado);
            this.Controls.Add(this.btnDesencriptar);
            this.Controls.Add(this.btnEncriptar);
            this.Controls.Add(this.txtCadena);
            this.Controls.Add(this.txtClave);
            this.Controls.Add(this.lblCadena);
            this.Controls.Add(this.lblClave);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.Text = "Herramienta de Cifrado ";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblClave;
        private System.Windows.Forms.Label lblCadena;
        private System.Windows.Forms.TextBox txtClave;
        private System.Windows.Forms.TextBox txtCadena;
        private System.Windows.Forms.Button btnEncriptar;
        private System.Windows.Forms.Button btnDesencriptar;
        private System.Windows.Forms.TextBox txtResultado;
        private System.Windows.Forms.Label lblResultado;
        private System.Windows.Forms.TextBox txtConfirmarClave;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblMensaje;
        private System.Windows.Forms.CheckBox chkMVC;
    }
}

