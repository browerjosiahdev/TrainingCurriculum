USE training_curriculum;

GO
WITH ParentGroups (id, parent_id)
AS
(
	SELECT g.id, 
		   g.parent_id
	FROM [dbo].[group] AS g
	WHERE g.id = 7

	UNION ALL

	SELECT g.id, 
		   g.parent_id
	FROM [dbo].[group] AS g
	INNER JOIN ParentGroups AS pg 
							ON g.id = pg.parent_id
), 
UnscheduledTrainings (id, description, topic, duration, group_id)
AS
(
	SELECT t.id, 
	       t.description, 
		   t.topic, 
		   t.duration, 
		   tg.group_id AS group_id 
	FROM training AS t
	INNER JOIN training_group AS tg 
	                          ON tg.training_id = t.id
	WHERE NOT EXISTS(SELECT t.id 
	                 FROM training AS t
					 INNER JOIN training_schedule AS ts 
					                              ON t.id = ts.training_id
					 INNER JOIN users_training AS ut 
					                           ON ts.id = ut.training_schedule_id
					 INNER JOIN users AS u 
					                  ON ut.user_id = u.id
					 WHERE
						 u.id = 1 AND
						 t.status_id = 4 AND
						 ts.status_id = 1)
)

SELECT DISTINCT ut.id, ut.description, ut.topic, ut.duration FROM ParentGroups AS pg
         INNER JOIN UnscheduledTrainings AS ut ON pg.id = ut.group_id;



