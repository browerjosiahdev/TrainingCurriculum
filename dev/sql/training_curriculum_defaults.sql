USE training_curriculum

/*
 * Insert the default [status] values into the [dbo].[status] table.
 * 08/24/2015 0356 PM - josiahb
 */
INSERT INTO [dbo].[status] (name, description) VALUES ('ACTIVE', 'Status assigned to items that are currently active.')
INSERT INTO [dbo].[status] (name, description) VALUES ('INACTIVE', 'Status assigned to items that are no longer active.')
INSERT INTO [dbo].[status] (name, description) VALUES ('COMPLETE', 'Status assigned to items that are active and complete.')
INSERT INTO [dbo].[status] (name, description) VALUES ('INCOMPLETE', 'Status assigned to items that are active but incomplete.')

/*
 * Insert the default [role] values into the [dbo].[role] table.
 * 08/24/2015 0356 PM - josiahb
 */
INSERT INTO [dbo].[role] (name, description) VALUES ('EMPLOYEE', 'Role for employees who will only use the tool to schedule trainings they need to take.')
INSERT INTO [dbo].[role] (name, description) VALUES ('FACILITATOR', 'Role for employees who can also be assigned to facilitate training sessions.')
INSERT INTO [dbo].[role] (name, description) VALUES ('ADMINISTRATOR', 'Role for employees who will have full permissions for adding/removing/modifying content.')

/*
 * Insert the [schedule recurrence type] values into the [dbo].[recurrence_type] table.
 * 08/24/2015 0431 PM - josiahb
 */
INSERT INTO [dbo].[recurrence_type] (name, description) VALUES ('DAILY', 'This recurrence type will define a schedule that will recure daily from the first scheduled date.')
INSERT INTO [dbo].[recurrence_type] (name, description) VALUES ('WEEKLY', 'This recurrence type will define a schedule that will recure weekly from the first scheduled date, and will maintain the day of the week. Example: If the first scheduled date was Friday, the schedule would recure every Friday following that day.')
INSERT INTO [dbo].[recurrence_type] (name, description) VALUES ('MONTHLY', 'This recurrence type will define a schedule that will recure monthly from the first scheduled date, and will maintain the day of the month and week. Example: If the first scheduled date was the first Friday of the month, the schedule would recure every first Friday of the month following that day.')