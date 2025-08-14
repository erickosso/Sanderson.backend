using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using System.Net;
using System.IO;
using sanderson.backend.Utils;
using sanderson.backend.DAL;

namespace sanderson.backend.Reports
{
    public partial class xrCorteCaja : DevExpress.XtraReports.UI.XtraReport
    {
        public xrCorteCaja()
        {
            InitializeComponent();
        }


        private void xrPictureBox1_BeforePrint(object sender, System.Drawing.Printing.PrintEventArgs e)
        {
            var xrPB = sender as XRPictureBox;
            string imageUrl = string.Empty;
            if (xrPB == null) return;

            using (EscuelasSandersonSatoriEntities db = new EscuelasSandersonSatoriEntities())
            {
                var IdColegio = db.CortesCaja.Find
                    ((Guid)IdCorte.Value).escuela_id;



                if (Guid.Parse("2E36A70F-7C3C-4BEB-A5C2-1A20B41ABC91") == IdColegio)
                {
                    imageUrl = $"{AppUtils.BaseUrl}/public/Satori.png";
                }
                else
                {
                    imageUrl = $"{AppUtils.BaseUrl}/public/Raccons.png";

                }
                using (WebClient wc = new WebClient())
                {
                    byte[] imgBytes = wc.DownloadData(imageUrl);
                    using (MemoryStream ms = new MemoryStream(imgBytes))
                    {
                        xrPB.Image = Image.FromStream(ms);
                    }
                }
            }
        }
    }
}
