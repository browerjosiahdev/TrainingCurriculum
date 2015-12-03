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
            var trainings = entitites.phases.AsEnumerable()
                                            .Where(phase => phase.trainings.Any(training => training.status.name == "ACTIVE" &&
                                                                                            training.training_schedule.Any(schedule => schedule.status.name == "ACTIVE" &&
                                                                                                                                       schedule.users_training.Any(userTraining => userTraining.user_id == Id))))
                                            .Select(phase => new
                                            {
                                                name = phase.name,
                                                trainings = phase.trainings.AsEnumerable()
                                                                           .Where(training => training.status.name == "ACTIVE" && 
                                                                                              training.training_schedule.Any(schedule => schedule.status.name == "ACTIVE" && 
                                                                                                                                         schedule.users_training.Any(userTraining => userTraining.user_id == Id)))
                                                                           .Select(training => new
                                                                            {
                                                                                topic = training.topic,
                                                                                description = training.description,
                                                                                duration = training.duration
                                                                            })
                                            });

            return trainings.ToList();
        }
    }
}
