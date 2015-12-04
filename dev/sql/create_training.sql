USE training_curriculum;



DECLARE @trainingGroupId int;
DECLARE @trainingFacilitatorId int;
DECLARE @trainingRecurId int;
DECLARE @trainingUserId int;
DECLARE @trainingId int;

SELECT @trainingGroupId = id FROM [dbo].[group] WHERE name='CW_Full-Time'
INSERT INTO [dbo].[training] (topic,
                              description,
							  duration,
							  status_id) 
					  VALUES ('Topic for CW Full-time only',
					          'Description for CW Full-time only.',
							  60,
							  1)

SELECT @trainingId = MAX(id) FROM training

INSERT INTO [dbo].[training_phase] (training_id, phase_id) VALUES (@trainingId, 1)
INSERT INTO [dbo].[training_group] (training_id, group_id) VALUES (@trainingId, @trainingGroupId)

SELECT @trainingFacilitatorId = id FROM [dbo].[users] WHERE email='josiahb@allencomm.com' AND (role_id=2 OR role_id=3)
INSERT INTO [dbo].[training_facilitator] (training_id, user_id) VALUES (@trainingId, @trainingFacilitatorId)

SELECT @trainingFacilitatorId = id FROM [dbo].[users] WHERE email='scottz@allencomm.com' AND (role_id=2 OR role_id=3)
INSERT INTO [dbo].[training_facilitator] (training_id, user_id) VALUES (@trainingId, @trainingFacilitatorId)

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
									   1)