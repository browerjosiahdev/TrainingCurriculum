USE training_curriculum

DECLARE @activeId int;
DECLARE @adminId int;
DECLARE @facilitatorId int;
DECLARE @completeId int;
DECLARE @incompleteId int;

SELECT @activeId      = id FROM [dbo].[status] WHERE name='ACTIVE'
SELECT @adminId       = id FROM [dbo].[role]   WHERE name='ADMINISTRATOR'
SELECT @facilitatorId = id FROM [dbo].[role]   WHERE name='FACILITATOR'
SELECT @completeId    = id FROM [dbo].[status] WHERE name='COMPLETE'
SELECT @incompleteId  = id FROM [dbo].[status] WHERE name='INCOMPLETE'

/*
 * Insert a new user into the [dbo].[users] table with a defined
 * role and status selected from the [dbo].[role] and [dbo].[status]
 * tables. 08/24/2015 0343 PM - josiahb
 */
DECLARE @roleId int;

SELECT @roleId = id FROM role WHERE name='ADMINISTRATOR'
INSERT INTO [dbo].[users] (email, 
                   password, 
				   first_name, 
				   last_name, 
				   role_id, 
				   status_id) 
           VALUES ('josiahb@allencomm.com', 
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Josiah',
				   'Brower',
				   @roleId,
				   @activeId)
INSERT INTO [dbo].[users] (email, 
                   password, 
				   first_name, 
				   last_name, 
				   role_id, 
				   status_id) 
           VALUES ('toddm@allencomm.com', 
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Todd',
				   'Miller',
				   @roleId,
				   @activeId)

SELECT @roleId = id FROM role WHERE name='FACILITATOR'
INSERT INTO [dbo].[users] (email,
                   password,
				   first_name,
				   last_name,
				   role_id,
				   status_id)
		   VALUES ('scottz@allencomm.com',
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Scott',
				   'Zackrison',
				   @roleId,
				   @activeId)
INSERT INTO [dbo].[users] (email,
                   password,
				   first_name,
				   last_name,
				   role_id,
				   status_id)
		   VALUES ('seanm@allencomm.com',
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Sean',
				   'McKee',
				   @roleId,
				   @activeId)
INSERT INTO [dbo].[users] (email,
                   password,
				   first_name,
				   last_name,
				   role_id,
				   status_id)
		   VALUES ('jasonb@allencomm.com',
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Jason',
				   'Brower',
				   @roleId,
				   @activeId)
INSERT INTO [dbo].[users] (email,
                   password,
				   first_name,
				   last_name,
				   role_id,
				   status_id)
		   VALUES ('erice@allencomm.com',
		           'wdOuC7mf5lKRcRqH+04Rdw==                                                                                                                                                                                                                                        ',
				   'Eric',
				   'Evans',
				   @roleId,
				   @activeId)
/**/
/*
 * Insert the default [group] values into the [dbo].[group] table.
 * 08/24/2015 0356 PM - josiahb
 */
INSERT INTO [dbo].[group] (name, description) VALUES ('AC_All', 'This group encompasses all Allen Comm employees')
	INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (1, 'AC_Full-Time', 'This group encompasses all Allen Comm full-time employees')
	INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (1, 'AC_Part-Time', 'This group encompasses all Allen Comm part-time employees')

	INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (1, 'CW_All', 'This group encompasses all Allen Comm courseware employees')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (4, 'CW_Full-Time', 'This group encompasses all Allen Comm courseware full-time employees')
			INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (5, 'CW_PMs', 'This group encompasses all Allen Comm courseware project managers')
			INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (5, 'CW_Developers', 'This group encompasses all Allen Comm courseware developers')
			INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (5, 'CW_Designers', 'This group encompasses all Allen Comm courseware designers')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (4, 'CW_Part-Time', 'This group encompasses all Allen Comm courseware part-time employees')

	INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (1, 'Sales_All', 'This group encompasses all Allen Comm sales employees')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (10, 'Sales_Full-Time', 'This group encompasses all Allen Comm sales full-time employees')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (10, 'Sales_Part-Time', 'This group encompasses all Allen Comm sales part-time employees')

	INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (1, 'Portal_All', 'This group encompasses all Allen Comm portal employees')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (13, 'Portal_Full-Time', 'This group encompasses all Allen Comm portal full-time employees')
		INSERT INTO [dbo].[group] (parent_id, name, description) VALUES (13, 'Portal_Part-Time', 'This group encompasses all Allen Comm portal part-time employees')
/**/
/*
 * Insert each user into their associated group within the [dbo].[users_group] table.
 *08/24/2015 0445 PM - josiahb
 */
DECLARE @userId int;
DECLARE @groupId int;

SELECT @groupId = id FROM [dbo].[group] WHERE name='CW_Developers'

SELECT @userId  = id FROM [dbo].[users] WHERE email='josiahb@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)

SELECT @userId  = id FROM [dbo].[users] WHERE email='toddm@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)

SELECT @userId  = id FROM [dbo].[users] WHERE email='scottz@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)

SELECT @userId  = id FROM [dbo].[users] WHERE email='seanm@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)

SELECT @userId  = id FROM [dbo].[users] WHERE email='jasonb@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)

SELECT @userId  = id FROM [dbo].[users] WHERE email='erice@allencomm.com'
INSERT INTO [dbo].[users_group] (user_id, group_id) VALUES (@userId, @groupId)
/**/
/*
 * Insert the different [training phases] into the [dbo].[phase] table.
 * 08/24/2015 0425 PM - josiahb
 */
DECLARE @phaseStatusId int;

SELECT @phaseStatusId = id FROM [dbo].[status] WHERE name='ACTIVE'

INSERT INTO [dbo].[phase] (name, 
						   [end], 
						   objectives, 
						   description, 
						   status_id) 
				   VALUES ('Readiness: 1st Week',
						   7,
						   'Company Vision and Values\nCareer Goals\nEvaluation\nCommitment',
						   'Your Allen Story: Interview people, take pictures, video. The Allen Story will be shared in the weekly PC meeting.',
						   @phaseStatusId)
INSERT INTO [dbo].[phase] (name,
                           start, 
						   [end], 
						   objectives, 
						   description, 
						   status_id) 
				   VALUES ('Training: 2nd - 5th Week',
				           7,
						   35,
						   'Acquire knowledge and skills\nPractice\Assess',
						   'Process Presentation: Attend and observe at least 3 brainstorms, 2 pitches, and review 3 DSDs. —explain the creative process and share your observations with the VP.',
						   @phaseStatusId)
INSERT INTO [dbo].[phase] (name,
                           start, 
						   [end], 
						   objectives, 
						   description, 
						   status_id) 
				   VALUES ('Apprenticeship: (Monthly) 6th week on',
				           35,
						   42,
						   'Apply to job context\nApprenticeship\nReceive feedback and reapply',
						   'Process Presentation: Attend and observe at least 3 brainstorms, 2 pitches, and review 3 DSDs. —explain the creative process and share your observations with the VP.',
						   @phaseStatusId)
/**/
/*
 * Insert placeholder trainings into the [dbo].[training] table.
 * 08/24/2015 0452 PM - josiahb
 */
DECLARE @trainingGroupId int;
DECLARE @trainingFacilitatorId int;
DECLARE @trainingRecurId int;
DECLARE @trainingUserId int;

SELECT @trainingGroupId = id FROM [dbo].[group] WHERE name='AC_All'
INSERT INTO [dbo].[training] (topic,
                              description,
							  duration,
							  status_id) 
					  VALUES ('Benefits and New Hire Paperwork',
					          '• Employee Orientation, HR Forms, Benefits, Company Policies and Procedures\n• Drug Test\n• Background Check\n• Business cards\n• Corporate AMEX\n• Name Plate\n• Mail Cabinet\n• Direct Deposit\n• Photo\n• Tour and Introductions',
							  60,
							  @activeId)
INSERT INTO [dbo].[training_phase] (training_id, phase_id) VALUES (1, 1)
INSERT INTO [dbo].[training_group] (training_id, group_id) VALUES (1, @trainingGroupId)

SELECT @trainingFacilitatorId = id FROM [dbo].[users] WHERE email='josiahb@allencomm.com' AND (role_id=@facilitatorId OR role_id=@adminId)
INSERT INTO [dbo].[training_facilitator] (training_id, user_id) VALUES (1, @trainingFacilitatorId)

SELECT @trainingFacilitatorId = id FROM [dbo].[users] WHERE email='scottz@allencomm.com' AND (role_id=@facilitatorId OR role_id=@adminId)
INSERT INTO [dbo].[training_facilitator] (training_id, user_id) VALUES (1, @trainingFacilitatorId)

SELECT @trainingRecurId = id FROM [dbo].[recurrence_type] WHERE name='MONTHLY'
INSERT INTO [dbo].[training_schedule] (training_id, 
                                       start_date, 
									   recurrence, 
									   recurrence_type_id, 
									   status_id) 
							   VALUES (1,
							           CONVERT(DATETIME, '08/24/2015 16:00', 0),
									   5,
									   @trainingRecurId,
									   @activeId)

SELECT @trainingUserId = id FROM [dbo].[users] WHERE email='erice@allencomm.com'
INSERT INTO [dbo].[users_training] (user_id, 
									training_schedule_id, 
									recurrence, 
									status_id) 
						    VALUES (@trainingUserId,
									1,
									2,
									@incompleteId)


SELECT @trainingGroupId = id FROM [dbo].[group] WHERE name='CW_Developers'
INSERT INTO [dbo].[training] (topic,
                              description,
							  duration,
							  status_id) 
					  VALUES ('Third Party Tools\nLectora/Storyline/Captivate',
					          'Tools Overview\n• Why do we use these tools?\n• How do we use these tools?',
							  60,
							  @activeId)
INSERT INTO [dbo].[training_phase] (training_id, phase_id) VALUES (1, 2)
INSERT INTO [dbo].[training_group] (training_id, group_id) VALUES (1, @trainingGroupId)

SELECT @trainingFacilitatorId = id FROM [dbo].[users] WHERE email='toddm@allencomm.com' AND (role_id=@facilitatorId OR role_id=@adminId)
INSERT INTO [dbo].[training_facilitator] (training_id, user_id) VALUES (1, @trainingFacilitatorId)

SELECT @trainingRecurId = id FROM [dbo].[recurrence_type] WHERE name='MONTHLY'
INSERT INTO [dbo].[training_schedule] (training_id, 
                                       start_date, 
									   recurrence, 
									   recurrence_type_id, 
									   status_id) 
							   VALUES (1,
							           CONVERT(DATETIME, '08/28/2015 10:00', 0),
									   5,
									   @trainingRecurId,
									   @activeId)

SELECT @trainingUserId = id FROM [dbo].[users] WHERE email='josiahb@allencomm.com'
INSERT INTO [dbo].[users_training] (user_id, 
									training_schedule_id, 
									recurrence, 
									status_id) 
						    VALUES (@trainingUserId,
									2,
									4,
									@completeId)
INSERT INTO [dbo].[training_material] (training_id,
                                       link,
									   description,
									   status_id) 
							   VALUES (2,
							           'http://cw.yourlearningportal.com',
									   'Link to the courseware learning portal where courses using these technologies are being hosted.',
									   @activeId)
/**/