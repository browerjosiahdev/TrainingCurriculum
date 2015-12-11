using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Diagnostics;

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

        /// <summary>
        /// Get an enumerable list of all groups associated with the given user.
        /// </summary>
        /// <param name="UserID">ID of the user to get the groups for.</param>
        /// <returns>Enumerable list of group object.</returns>
        public static IEnumerable<group> GetGroups( int UserID )
        {
            TrainingEntities entities = new TrainingEntities();
            var user = entities.users.AsEnumerable()
                                     .First(givenUser => givenUser.id == UserID);
            IEnumerable<group> userGroups = user.groups;

            foreach (group userGroup in user.groups)
            {
                userGroups = GetParentGroups(userGroup, true).Concat<group>(userGroups);
            }

            return userGroups;
        }

        /// <summary>
        /// Get the parent groups associated with the given group.
        /// </summary>
        /// <param name="childGroup">Group to get the parent groups for.</param>
        /// <param name="isRoot">True if the given child group shouldn't be included in the returned value.</param>
        /// <returns>Enumerable </returns>
        private static IEnumerable<group> GetParentGroups( group childGroup, bool isRoot )
        {
            IEnumerable<group> parentGroups = new[] { childGroup };

            if (childGroup.parent_id != null)
            {
                if (isRoot)
                {
                    parentGroups = GetParentGroups(childGroup.group2, false);
                }
                else
                {
                    parentGroups = GetParentGroups(childGroup.group2, false).Concat<group>(parentGroups);
                }
            }

            return parentGroups;
        }
    }
}