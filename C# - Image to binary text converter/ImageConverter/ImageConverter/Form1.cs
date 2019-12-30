using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ImageConverter
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            this.Hide();
            ImageFilterToText iftt = new ImageFilterToText(this);
            iftt.Show();
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            this.Hide();
            TextToImage tti = new TextToImage(this);
            tti.Show();
        }
    }
}
