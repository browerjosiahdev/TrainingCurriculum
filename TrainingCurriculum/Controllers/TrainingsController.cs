using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Diagnostics;
using TrainingCurriculum.Models;

namespace TrainingCurriculum.Controllers
{
    public class TrainingsController : ApiController
    {
        /// <summary>
        /// Web API method called to get a list of all trainings associated with the current user.
        /// </summary>
        /// <param name="Id">ID of the user to get the training list for.</param>
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
                scheduled = GetScheduledTrainings(Id),
                completed = GetCompletedTrainings(Id),
                required = GetRequiredTrainings(Id)
            };
        }

        /// <summary>
        /// Web API method called to get the list of the scheduled trainings.
        /// </summary>
        /// <param name="Id">ID of the user to get the training list for.</param>
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
                                                                                                                                       schedule.users_training.Any(userTraining => userTraining.user_id == Id && 
                                                                                                                                                                                   userTraining.status.name == "INCOMPLETE"))))
                                            .Select(phase => new
                                            {
                                                name = phase.name,
                                                trainings = phase.trainings.AsEnumerable()
                                                                           .Where(training => training.status.name == "ACTIVE" && 
                                                                                              training.training_schedule.Any(schedule => schedule.status.name == "ACTIVE" && 
                                                                                                                                         schedule.users_training.Any(userTraining => userTraining.user_id == Id &&
                                                                                                                                                                                     userTraining.status.name == "INCOMPLETE")))
                                                                           .Select(training => new
                                                                            {
                                                                                topic = training.topic,
                                                                                description = training.description,
                                                                                duration = training.duration
                                                                            })
                                            });

            return trainings.ToList();
        }

        /// <summary>
        /// Web API method called to get the list of completed user trainings.
        /// </summary>
        /// <param name="Id">ID of the user to get the training list for.</param>
        /// <returns>Enumerable list of completed user trainings.</returns>
        [ActionName("complete")]
        public IEnumerable<dynamic> GetCompletedTrainings(int Id = 0)
        {
            if (Id == 0)
            {
                Id = SessionModel.UserID;
            }

            TrainingEntities entities = new TrainingEntities();
            var trainings = entities.phases.AsEnumerable()
                                           .Where(phase => phase.trainings.Any(training => training.training_schedule.Any(schedule => schedule.users_training.Any(userTraining => userTraining.user_id == Id && 
                                                                                                                                                                                    userTraining.status.name == "COMPLETE"))))
                                           .Select(phase => new
                                           {
                                               name = phase.name,
                                               trainings = phase.trainings.AsEnumerable()
                                                                          .Where(training => training.training_schedule.Any(schedule => schedule.users_training.Any(userTraining => userTraining.user_id == Id &&
                                                                                                                                                                                    userTraining.status.name == "COMPLETE")))
                                                                          .Select(training => new
                                                                          {
                                                                              topic = training.topic,
                                                                              description = training.description,
                                                                              duration = training.duration
                                                                          })
                                           });

            return trainings.ToList();
        }

        /// <summary>
        /// Web API method to get the list of required user trainings that haven't been scheduled.
        /// </summary>
        /// <param name="Id">ID of the user to get the training list for.</param>
        /// <returns>Enumerable list of required user trainings.</returns>
        [ActionName("required")]
        public IEnumerable<dynamic> GetRequiredTrainings(int Id = 0)
        {
            if (Id == 0)
            {
                Id = SessionModel.UserID;
            }

            TrainingEntities entities = new TrainingEntities();

            IEnumerable<group> userGroups = UserModel.GetGroups(Id);
            var trainings = entities.phases.AsEnumerable()
                                           .Where(phase => phase.trainings.Any(training => training.groups.Intersect(userGroups).Count() > 0))
                                           .Select(phase => new
                                           {
                                               name = phase.name,
                                               trainings = phase.trainings.AsEnumerable()
                                                                          .Where(training => training.groups.Intersect(userGroups).Count() > 0)
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
