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
        [ActionName("all")]
        public dynamic GetAllTrainings()
        {
            return new
            {
                scheduled = GetScheduledTrainings()
            };
        }

        [ActionName("scheduled")]
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
