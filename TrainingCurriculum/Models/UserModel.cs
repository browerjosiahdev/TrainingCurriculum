using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.IO;

namespace TrainingCurriculum.Models
{
    public class UserModel
    {
        private static string EncryptionKey = "ALEK29ALEI10FKA";

        public string Email { get; set; }
        public string Password { get; set; }

        /// <summary>
        /// Used to encrypt user passwords.
        /// </summary>
        /// <param name="password">Password to be encrypted.</param>
        /// <returns>Encrypted password.</returns>
        public static string Encrypt( string password )
        {
            if (password == null || password.Length == 0)
            {
                return "";
            }

            byte[] clearBytes = Encoding.Unicode.GetBytes(password);

            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x65, 0x76 });

                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);

                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }

                    password = Convert.ToBase64String(ms.ToArray());
                }
            }

            return password;
        }
    }
}