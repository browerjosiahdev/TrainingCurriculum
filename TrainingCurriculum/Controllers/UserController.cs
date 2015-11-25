using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web;
using TrainingCurriculum.Models;

namespace TrainingCurriculum.Controllers
{
    public class UserController : ApiController
    {
        /// <summary>
        /// Web API method called to get the ID of the user currently logged in.
        /// </summary>
        /// <returns>ID of the user currently logged in if it exists, or 0 by default.</returns>
        public int GetId()
        {
            return SessionModel.UserID;
        }

        /// <summary>
        /// Web API method for logging a user in.
        /// </summary>
        /// <param name="credentials">Email and password credentials for the user to login.</param>
        [ActionName("login")]
        [HttpPost]
        public dynamic Login([FromBody]UserModel credentials)
        {
            TrainingEntities entities = new TrainingEntities();
            var user = entities.users.AsEnumerable()
                                     .First(curUser => curUser.email.Trim() == credentials.Email.Trim());

            if (user == null || user.password.Trim() != UserModel.Encrypt(credentials.Password).Trim())
            {
                return new
                {
                    id = 0
                };
            }

            SessionModel.UserID = user.id;

            return new
            {
                id = user.id,
                role = user.role.name,
                passwordReset = user.password_reset
            };
        }

        [ActionName("password")]
        [HttpPut]
        public dynamic UpdatePassword([FromBody]UserModel credentials)
        {
            TrainingEntities entities = new TrainingEntities();
            var user = entities.users.AsEnumerable()
                                     .First(curUser => curUser.id == SessionModel.UserID);

            if (user == null)
            {
                return new
                {
                    success = false
                };
            }

            user.password = UserModel.Encrypt(credentials.Password);

            entities.SaveChanges();

            return new
            {
                success = true
            };
        }
    }
}
