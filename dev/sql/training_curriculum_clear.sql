USE training_curriculum;

ALTER TABLE [dbo].[phase] DROP CONSTRAINT [fk_phase_status];

ALTER TABLE [dbo].[training] DROP CONSTRAINT [fk_training_status];

ALTER TABLE [dbo].[training_schedule] DROP CONSTRAINT [fk_trainingschedule_training];
ALTER TABLE [dbo].[training_schedule] DROP CONSTRAINT [fk_trainingschedule_recurrencetype];
ALTER TABLE [dbo].[training_schedule] DROP CONSTRAINT [fk_trainingschedule_status];

ALTER TABLE [dbo].[training_group] DROP CONSTRAINT [pk_traininggroup];
ALTER TABLE [dbo].[training_group] DROP CONSTRAINT [fk_traininggroup_training];
ALTER TABLE [dbo].[training_group] DROP CONSTRAINT [fk_traininggroup_group];

ALTER TABLE [dbo].[training_material] DROP CONSTRAINT [fk_trainingmaterial_training];
ALTER TABLE [dbo].[training_material] DROP CONSTRAINT [fk_trainingmaterial_status];

ALTER TABLE [dbo].[training_phase] DROP CONSTRAINT [pk_trainingphase];
ALTER TABLE [dbo].[training_phase] DROP CONSTRAINT [fk_trainingphase_training];
ALTER TABLE [dbo].[training_phase] DROP CONSTRAINT [fk_trainingphase_phase];

ALTER TABLE [dbo].[users] DROP CONSTRAINT [fk_users_role];
ALTER TABLE [dbo].[users] DROP CONSTRAINT [fk_users_status];

ALTER TABLE [dbo].[users_group] DROP CONSTRAINT [pk_usersgroup];
ALTER TABLE [dbo].[users_group] DROP CONSTRAINT [fk_usersgroup_users];
ALTER TABLE [dbo].[users_group] DROP CONSTRAINT [fk_usersgroup_group];

ALTER TABLE [dbo].[users_training] DROP CONSTRAINT [fk_userstraining_users];
ALTER TABLE [dbo].[users_training] DROP CONSTRAINT [fk_userstraining_trainingschedule];
ALTER TABLE [dbo].[users_training] DROP CONSTRAINT [fk_userstraining_status];

ALTER TABLE [dbo].[training_facilitator] DROP CONSTRAINT [pk_trainingfacilitator];
ALTER TABLE [dbo].[training_facilitator] DROP CONSTRAINT [fk_trainingfacilitator_training];
ALTER TABLE [dbo].[training_facilitator] DROP CONSTRAINT [fk_trainingfacilitator_users];

DROP TABLE [dbo].[status];
DROP TABLE [dbo].[role];
DROP TABLE [dbo].[group];
DROP TABLE [dbo].[phase];
DROP TABLE [dbo].[recurrence_type];
DROP TABLE [dbo].[training];
DROP TABLE [dbo].[training_schedule];
DROP TABLE [dbo].[training_group];
DROP TABLE [dbo].[training_material];
DROP TABLE [dbo].[training_phase];
DROP TABLE [dbo].[users];
DROP TABLE [dbo].[users_group];
DROP TABLE [dbo].[users_training];
DROP TABLE [dbo].[training_facilitator];