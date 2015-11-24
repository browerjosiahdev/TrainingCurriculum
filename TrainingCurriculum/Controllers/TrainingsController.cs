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
        [ActionName("scheduled")]
        public IEnumerable<dynamic> GetScheduledTrainings()
        {
            TrainingEntities db = new TrainingEntities();

            var trainings = db.trainings.AsEnumerable()
                                        .Where(training => training.status.name == "ACTIVE")
                                        .Select(training => new
                                        {
                                            training.id,
                                            training.topic,
                                            training.description,
                                            training.duration,
                                            training.status.name
                                        })/*
                                        .Join(db.training_schedule,
                                              training => training.id,
                                              schedule => schedule.training_id,
                                              (training, schedule) =>
                                              new{ })
                                        .Join(db.users_training,
                                              schedule => schedule.id,
                                              userTraining => userTraining.training_schedule_id,
                                              (schedule, userTraining) =>
                                              new { })
                                        .Join(db.users,
                                              userTraining => userTraining.UserTraining.user_id,
                                              user => user.id,
                                              (userTraining, user) =>
                                              new { })*/;

            return trainings.ToList();
        }
    }
}
