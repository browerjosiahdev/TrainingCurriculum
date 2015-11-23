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
        public IHttpActionResult GetScheduledTrainings()
        {
            TrainingEntities db = new TrainingEntities();

            var trainings = db.trainings.AsEnumerable()
                                        .Where(training => training.status.name == "ACTIVE")
                                        .Join(db.training_schedule,
                                              training => training.id,
                                              schedule => schedule.training_id,
                                              (training, schedule) =>
                                              new
                                              {
                                                  Schedule = schedule
                                              })
                                        .Join(db.users_training,
                                              schedule => schedule.Schedule.id,
                                              userTraining => userTraining.training_schedule_id,
                                              (schedule, userTraining) =>
                                              new
                                              {
                                                  UserTraining = userTraining
                                              })
                                        .Join(db.users,
                                              userTraining => userTraining.UserTraining.user_id,
                                              user => user.id,
                                              (userTraining, user) =>
                                              new
                                              {
                                                  User = user
                                              });

            if (trainings.Count() == 0)
            {
                return NotFound();
            }

            return Ok(trainings);
        }
    }
}
