using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace TrainingCurriculum.Controllers
{
    public class TrainingsController : ApiController
    {
        /// <summary>
        /// Web API method called to get a list of all trainings associated with the current user.
        /// </summary>
        /// <returns>Object containing the scheduled, required, and complete trainings.</returns>
        [Route("all")]
        public dynamic GetAllTrainings()
        {
            return new
            {
                scheduled = GetScheduledTrainings()
            };
        }

        /// <summary>
        /// Web API method called to get a list of the scheduled trainings.
        /// </summary>
        /// <returns>Enumerable list of the scheduled trainings.</returns>
        [Route("scheduled")]
        public IEnumerable<dynamic> GetScheduledTrainings()
        {
            TrainingEntities entitites = new TrainingEntities();

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
                                                              data.schedule.users_training.Any(userTraining => userTraining.user_id == 1))
                                               .Select(data => new
                                               {
                                                   data.training.id,
                                                   data.training.topic,
                                                   data.training.description,
                                                   data.training.duration,
                                                   data.training.status.name
                                               });

            return trainings.ToList();
        }
    }
}
