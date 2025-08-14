using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace sanderson.backend.Utils
{
    public class AppUtils
    {
        public static string ObtenerSHA256(string input)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(input);
                byte[] hash = sha256.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }
        public static string FolderArchivos
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["FolderArchivos"];
            }
        }  public static string BaseUrl
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["BaseUrl"];
            }
        }
    }
}