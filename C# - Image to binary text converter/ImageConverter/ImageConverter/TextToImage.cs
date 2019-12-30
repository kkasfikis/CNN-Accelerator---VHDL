using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ImageConverter
{
    public partial class TextToImage : Form
    {
        private string resultFile;
        private string resultImage;
        private List<string> resultList;
        private int offset = 0;//17688;
        private int resultHeight = 129; //132;
        private int resultWidth = 131;
        private Form1 caller_form;
        public TextToImage( Form1 caller_form )
        {
            InitializeComponent();
            this.caller_form = caller_form;
        }

        //Browse Result File
        private void Button2_Click(object sender, EventArgs e)
        {
            DialogResult result = openFileDialog1.ShowDialog();
            if (result == DialogResult.OK)
            {
                resultFile = openFileDialog1.InitialDirectory + openFileDialog1.FileName;
                textBox1.Text = resultFile;
            }
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            using (folderBrowserDialog1)
            {
                DialogResult result = folderBrowserDialog1.ShowDialog();

                if (result == DialogResult.OK && !string.IsNullOrWhiteSpace(folderBrowserDialog1.SelectedPath))
                {
                    resultImage = Path.Combine(folderBrowserDialog1.SelectedPath, "resultImage.jpg");
                    textBox2.Text = resultImage;
                }
            }
        }

        //Convert Result File
        private void Button1_Click(object sender, EventArgs e)
        {
            resultWidth = int.Parse(textBox3.Text);
            resultHeight = int.Parse(textBox4.Text);
            offset = int.Parse(textBox5.Text);
            Bitmap newImage = new Bitmap(resultWidth, resultHeight, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            resultList = new List<string>();
            resultList = File.ReadAllLines(resultFile).ToList();
            List<string> t_resultList = new List<string>();
            foreach (string s in resultList)
            {
                if(s.Length == 32)
                {
                    t_resultList.Add(s.Substring(24, 8));
                    t_resultList.Add(s.Substring(16, 8));
                    t_resultList.Add(s.Substring(8, 8));
                    t_resultList.Add(s.Substring(0, 8));
                }
                else
                {
                    t_resultList.Add(s.Substring(56, 8));
                    t_resultList.Add(s.Substring(40, 8));
                    t_resultList.Add(s.Substring(24, 8));
                    t_resultList.Add(s.Substring(8, 8));
                }
                
                
            }
            for (int x = 0; x < resultWidth; x++)
            {
                for (int y = 0; y < resultHeight; y++)
                {
                    newImage.SetPixel(x, y, Color.FromArgb(255, Convert.ToInt32(t_resultList[((x * resultHeight) + y)], 2), Convert.ToInt32(t_resultList[offset + ((x * resultHeight) + y)], 2), Convert.ToInt32(t_resultList[2*offset + ((x * resultHeight) + y)], 2)));
                }
            }
            pictureBox1.Image = newImage;
            if (File.Exists(resultImage)) { File.Delete(resultImage); }
            newImage.Save(resultImage);
        }

        private void TextToImage_FormClosing(object sender, FormClosingEventArgs e)
        {
            caller_form.Show();
        }
    }
}
