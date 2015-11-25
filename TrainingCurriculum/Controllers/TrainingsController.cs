using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using TrainingCurriculum.Models;

namespace TrainingCurriculum.Controllers
{
    public class TrainingsController : ApiController
    {
        /// <summary>
        /// Web API method called to get a list of all trainings associated with the current user.
        /// </summary>
        /// <returns>Object containing the scheduled, required, and complete trainings.</returns>
        [ActionName("all")]
        public dynamic GetAllTrainings(int Id = 0)
        {
            if (Id == 0)
            {
                Id = SessionModel.UserID;
            }

            return new
            {
                scheduled = GetScheduledTrainings(Id)
            };
        }

        /// <summary>
        /// Web API method called to get a list of the scheduled trainings.
        /// </summary>
        /// <returns>Enumerable list of the scheduled trainings.</returns>
        [ActionName("scheduled")]
        public IEnumerable<dynamic> GetScheduledTrainings(int Id = 0)
        {
            if (Id == 0)
            {
                Id = SessionModel.UserID;
            }

            TrainingEntities entitites = new TrainingEntities();
            /**/
            var trainings = entitites.trainings.AsEnumerable()
                                               .Join(entitites.training_schedule.AsEnumerable(),
                                                     training => training.id,
                                                     schedule => schedule.training_id,
                                                     (training, schedule) => new
                                                     {
                                                         training,
                                                         schedule
                                                     })
                                               .Where(data => data.training.status.name == "ACTIVE" &&
                                                              data.schedule.status.name == "ACTIVE" &&
                                                              data.schedule.users_training.Any(userTraining => userTraining.user_id == Id))
                                               .Select(data => new
                                               {
                                                   id = data.training.id,
                                                   topic = data.training.topic,
                                                   description = data.training.description,
                                                   duration = data.training.duration,
                                                   status = data.training.status.name
                                               });
            /**/
            return trainings.ToList();
        }
    }
}
