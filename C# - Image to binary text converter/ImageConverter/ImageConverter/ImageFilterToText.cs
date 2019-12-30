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
    public partial class ImageFilterToText : Form
    {
        private string imageFile = String.Empty;
        private string image_textFile = String.Empty;
        private string filter_textFile = String.Empty;
        private List<string> image_textList;
        private List<string> filter_textList;
        private int channels = 1;
        private int filterDim = 3;//16;
        private Form1 caller_form;
        private int[,] r_filter_region = new int[3, 3] { { 1, 0, -1 }, { 0, 0, 0 }, { -1, 0, 1} };

        private int[,] g_filter_region = new int[3, 3] { { 1, 0, -1 }, { 0, 0, 0 }, { -1, 0, 1 } };


        private int[,] b_filter_region = new int[3, 3] { { 1, 0, -1 }, { 0, 0, 0 }, { -1, 0, 1 } };
        public ImageFilterToText(Form1 caller_form)
        {
            this.caller_form = caller_form;
            InitializeComponent();
            for(int x = 0; x<filterDim; x++)
            {
                for (int y = 0; y < filterDim; y++)
                {
                    Console.WriteLine("x: " + x + " y: " + y + " value: " + r_filter_region[y, x]);
                }
            }
        }


        //Image File
        private void Button2_Click(object sender, EventArgs e)
        {
            DialogResult result = openFileDialog1.ShowDialog();
            if (result == DialogResult.OK)
            {
                imageFile = openFileDialog1.InitialDirectory + openFileDialog1.FileName;
                textBox1.Text = imageFile;
            }
        }

        //Text File
        private void Button3_Click(object sender, EventArgs e)
        {
            using (folderBrowserDialog1)
            {
                DialogResult result = folderBrowserDialog1.ShowDialog();

                if (result == DialogResult.OK && !string.IsNullOrWhiteSpace(folderBrowserDialog1.SelectedPath))
                {
                    image_textFile = Path.Combine(folderBrowserDialog1.SelectedPath, "image_file.txt");
                    textBox2.Text = image_textFile;
                    //File.CreateText(textFile);
                }
            }
        }

        //Filter File
        private void Button4_Click(object sender, EventArgs e)
        {
            using (folderBrowserDialog1)
            {
                DialogResult result = folderBrowserDialog1.ShowDialog();

                if (result == DialogResult.OK && !string.IsNullOrWhiteSpace(folderBrowserDialog1.SelectedPath))
                {
                    filter_textFile = Path.Combine(folderBrowserDialog1.SelectedPath, "filter_file.txt");
                    textBox3.Text = filter_textFile;
                    //File.CreateText(textFile);
                }
            }
        }

        //Convert
        private void Button1_Click(object sender, EventArgs e)
        {
            channels = int.Parse(textBox4.Text);
            image_textList = new List<string>();
            filter_textList = new List<string>();
            Bitmap img = new Bitmap(imageFile);
            string line = String.Empty;
            int counter = 0;
            for (int r = 0; r < channels; r++)
            {

                for (int i = 0; i < img.Width; i++)
                {
                    for (int j = 0; j < img.Height; j++)
                    {
                        Color pixel = img.GetPixel(i, j);
                        if (r == 0)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = "00000000" + Convert.ToString(pixel.R, 2).PadLeft(8, '0');
                                counter++;
                            }
                            else
                            {
                                line = "00000000" + Convert.ToString(pixel.R, 2).PadLeft(8, '0') + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    image_textList.Add(line);
                                }
                            }
                        }
                        else if (r == 1)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = "00000000" + Convert.ToString(pixel.G, 2).PadLeft(8, '0');
                                counter++;
                            }
                            else
                            {
                                line = "00000000" + Convert.ToString(pixel.G, 2).PadLeft(8, '0') + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    image_textList.Add(line);
                                }

                            }
                        }
                        else if (r == 2)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = "00000000" + Convert.ToString(pixel.B, 2).PadLeft(8, '0');
                                counter++;
                            }
                            else
                            {
                                line = "00000000" + Convert.ToString(pixel.B, 2).PadLeft(8, '0') + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    image_textList.Add(line);
                                }

                            }
                        }

                    }
                }
            }
            using (TextWriter tw = new StreamWriter(image_textFile))
            {
                foreach (String s in image_textList)
                    tw.WriteLine(s);
            }

            counter = 0;
            for (int r = 0; r < channels; r++)
            {
                for (int x = 0; x < filterDim; x++)
                {
                    for (int y = 0; y < filterDim; y++)
                    {
                        if (r == 0)
                        {
                            if(counter == 0)
                            {
                                line = String.Empty;
                                line = IntToBinary(r_filter_region[y, x]);
                                counter++;
                            }
                            else
                            {
                                line = IntToBinary(r_filter_region[y, x]) + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    filter_textList.Add(line);
                                }
                            }
                        }
                        else if (r == 1)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = IntToBinary(g_filter_region[y, x]);
                                counter++;
                            }
                            else
                            {
                                line = IntToBinary(g_filter_region[y, x]) + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    filter_textList.Add(line);
                                }
                            }
                        }
                        else if (r == 2)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = IntToBinary(b_filter_region[y, x]);
                                counter++;
                            }
                            else
                            {
                                line = IntToBinary(b_filter_region[y, x]) + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    filter_textList.Add(line);
                                }
                            }
                        }
                        /*else if (r == 3)
                        {
                            if (counter == 0)
                            {
                                line = String.Empty;
                                line = IntToBinary(f_filter_region[y, x]);
                                counter++;
                            }
                            else
                            {
                                line = IntToBinary(f_filter_region[y, x]) + line;
                                counter++;
                                if (counter == 4)
                                {
                                    counter = 0;
                                    filter_textList.Add(line);
                                }
                            }
                        }*/
                    }
                }
            }
            while (counter < 4)
            {
                line = "0000000000000000" + line;
                counter++;
            }
            filter_textList.Add(line);
            using (TextWriter tw = new StreamWriter(filter_textFile))
            {
                foreach (String s in filter_textList)
                    tw.WriteLine(s);
            }
        }

        public float convertToRange(float f)
        {
            float r;
            if(f != 0)
            {
                r = 256 + f;
            }
            else
            {
                r = 256;
            }
            return r / 512;
        }

        private string IntToBinary(int f)
        {
            string x;
            if (checkBox1.Checked)
            {
                if (f < 0)
                {
                    f = f * -1;
                    x = "11111111";
                }
                else
                {
                    x = "00000000";
                }
                x = x + Convert.ToString(f, 2).PadLeft(8, '0');
            }
            else
            {
                if (f < 0)
                {
                    f = f * -1;
                    x = "1";
                }
                else
                {
                    x = "0";
                }
                x = x + Convert.ToString(f, 2).PadLeft(15, '0');
            }
            
            return x;
        }

        private void ImageFilterToText_FormClosing(object sender, FormClosingEventArgs e)
        {
            caller_form.Show();
        }
    }
}
