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
        [ActionName("test-data")]
        public IEnumerable<TestData> GetTestData()
        {
            TestData[] data = new TestData[]
            {
                new TestData { ID = 1, FirstName = "Josiah", LastName = "Brower", Email = "josiahb@allencomm.com" },
                new TestData { ID = 2, FirstName = "Jason", LastName = "Brower", Email = "jasonb@allencomm.com" },
                new TestData { ID = 3, FirstName = "Scott", LastName = "Zackrison", Email = "scottz@allencomm.com" },
                new TestData { ID = 4, FirstName = "Eric", LastName = "Evans", Email = "erice@allencomm.com" }
            };

            return data;
        }

        [ActionName("scheduled")]
        public IEnumerable<training> GetScheduledTrainings()
        {
            TrainingEntities db = new TrainingEntities();

            return db.trainings.AsEnumerable()
                               .Where(training => training.duration == 60);

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
/*
            if (trainings.Count() == 0)
            {
                return NotFound();
            }

            return Ok(trainings);
*/
        }
    }
}
