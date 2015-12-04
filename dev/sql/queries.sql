USE training_curriculum

DECLARE @usersId      int      = 1;
DECLARE @trainingDate datetime = CONVERT(DATETIME, '08/20/2015 04:00', 0);

/*
 * Query to log a user in. When this query is implemented the password being passed in will
 * be encrypted first. The email and password values will have been supplied by the user on
 * the login page. 08/25/2015 1211 PM - josiahb
 //////////////////////////////////////////////////////////////////////////////////////////
 * Switched from using JOIN statements for the status and role tables, and just implimented
 * them as aliased tables with WHERE statments. 08/26/2015 1147 AM - josiahb
 *
DECLARE @usersEmail varchar(100);
DECLARE @usersPassword char(256);

SELECT @usersEmail    = email FROM [dbo].[users]    WHERE id=1
SELECT @usersPassword = password FROM [dbo].[users] WHERE id=1

SELECT u.id, u.password_reset, r.name FROM [dbo].[users]  AS u, 
                                           [dbo].[status] AS s,
										   [dbo].[role]   AS r
									  WHERE u.email     = @usersEmail AND 
										    u.password  = @usersPassword AND 
											u.status_id = s.id AND 
											s.name      = 'ACTIVE' AND 
											r.id        = u.role_id
*/
/*
 * Query to find the list of trainings a user is scheduled to take. Switch the status to
 * 'COMPLETE' or 'INCOMPLETE' depending on whether or not you want see the trainings
 * completed or not yet completed. The user ID will be stored when the user logs in. 
 * 08/25/2015 0101 PM - josiahb
 ///////////////////////////////////////////////////////////////////////////////////////
 * Added check to make sure the training, and training schedule have an active status
 * so we don't query inactive trainings. 08/25/2015 0454 PM - josiahb
 */
 SELECT t.id, t.topic, t.description, t.duration FROM [dbo].[training]          AS t
                                                 JOIN [dbo].[training_schedule] AS ts ON t.id       = ts.training_id
												 JOIN [dbo].[users_training]    AS ut ON ts.id      = ut.training_schedule_id
												 JOIN [dbo].[users]             AS u  ON ut.user_id = u.id
												 JOIN [dbo].[status]            AS si ON si.name    = 'INCOMPLETE'
												 JOIN [dbo].[status]            AS sa ON sa.name    = 'ACTIVE'
												 WHERE u.id         = @usersId AND 
												       ut.status_id = si.id AND 
													   t.status_id  = sa.id AND 
													   ts.status_id = sa.id;

SELECT p.name, p.start, p.[end], p.objectives, p.description, t.id, t.topic, t.description, t.duration FROM [dbo].[phase] AS p
														   JOIN [dbo].[training_phase] AS tp ON tp.phase_id = p.id
														   JOIN [dbo].[training] AS t ON t.id = tp.training_id
														   WHERE t.id = (SELECT t.id FROM [dbo].[training]          AS t
																		     		 JOIN [dbo].[training_schedule] AS ts ON t.id       = ts.training_id
																				     JOIN [dbo].[users_training]    AS ut ON ts.id      = ut.training_schedule_id
																					 JOIN [dbo].[users]             AS u  ON ut.user_id = u.id
																					 JOIN [dbo].[status]            AS si ON si.name    = 'INCOMPLETE'
																					 JOIN [dbo].[status]            AS sa ON sa.name    = 'ACTIVE'
																					 WHERE u.id         = @usersId AND 
																						   ut.status_id = si.id AND 
																						   t.status_id  = sa.id AND 
																						   ts.status_id = sa.id);
/**/
/*
 * Query to select all activities required for the user that the user hasn't yet signed
 * up for. 08/25/2015 0308 PM - josiahb
 *
/*****NOTE: This query needs to be updated to only pull in the trainings associated with the user groups, or one of its parent groups. 08/26/2015 0938 AM - josiahb*****/
SELECT t.id, t.topic, t.description, t.duration FROM [dbo].[training] AS t WHERE NOT EXISTS (
                                                                               SELECT * FROM [dbo].[training]          AS t
																		                JOIN [dbo].[training_schedule] AS ts ON t.id    = ts.training_id
																						JOIN [dbo].[users_training]    AS ut ON ts.id   = ut.training_schedule_id
																						JOIN [dbo].[status]            AS sa ON sa.name = 'ACTIVE'
																						WHERE ut.user_id    = @usersId AND
																						      t.status_id   = sa.id AND 
																							  ts.status_id  = sa.id/* AND 
																						      @trainingDate < DATEADD(DAY, 7, GETDATE())*/
                                                                           )
*/
/*
 * Query to create a new training. The topic, description, and duration will be provided by the
 * user; but the status ID will need to be queried from the [dbo].[status] table.
 * 08/25/2015 0344 PM - josiahb
 *
DECLARE @trainingTopic varchar(500)        = 'This is a placeholder topic for a placeholder training.';
DECLARE @trainingDescription varchar(2000) = 'This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training. This is a placeholder description for a placeholder training.';
DECLARE @trainingDuration int              = 60;
DECLARE @trainingStatusId int;

SELECT @trainingStatusId = id FROM [dbo].[status] WHERE name = 'ACTIVE'
INSERT INTO [dbo].[training] (topic, description, duration, status_id) 
                      VALUES (@trainingTopic, @trainingDescription, @trainingDuration, @trainingStatusId)
*/
/*
 * Query to change the status of a training. The training ID will be provided by the application
 * based on which training the user is updating, and the status name will change between 'ACTIVE'
 * and 'INACTIVE' based on what status the user wants. 08/25/2015 0442 PM - josiahb
 ////////////////////////////////////////////////////////////////////////////////////////////////
 * Switched from using a JOIN statment for the status table to referencing it with an alias and
 * using a WHERE statment to get the right ID. 08/26/2015 1151 AM - josiahb
 *
DECLARE @trainingId int = 1;

UPDATE t SET t.status_id = s.id FROM [dbo].[training] AS t,
                                     [dbo].[status]   AS s
								WHERE t.id   = @trainingId AND 
								      s.name = 'ACTIVE'
*/