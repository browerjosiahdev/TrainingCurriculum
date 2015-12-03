USE training_curriculum
/*
 * [id]          - Auto generated integer value.
 * [name]        - Descriptive name for the status. **Unique**
 * [description] - Description of what the status is.
 * 08/26/2015 0923 AM - josiahb
 */
CREATE TABLE [dbo].[status]
(
	[id] SMALLINT IDENTITY(1, 1) PRIMARY KEY, 
    [name] VARCHAR(50) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL,
	CONSTRAINT [u_status_name] UNIQUE ([name])
)
/*
 * [id]          - Auto generated integer value.
 * [name]        - Descriptive name for the role. **Unique**
 * [description] - Description of what the role is.
 * 08/26/2015 0923 AM - josiahb
 */
CREATE TABLE [dbo].[role]
(
	[id] SMALLINT IDENTITY(1, 1) PRIMARY KEY, 
    [name] VARCHAR(50) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL,
	CONSTRAINT [u_role_name] UNIQUE ([name])
)
/*
 * [id]          - Auto generated integer value.
 * [parent_id]   - ID of the parent group (if exists).
 * [name]        - Descriptive name for the group. **Unique**
 * [description] - Description of what the group is.
 * 11/20/2015 1205 PM - josiahb
 */
CREATE TABLE [dbo].[group]
(
	[id] SMALLINT IDENTITY(1, 1) PRIMARY KEY, 
	[parent_id] SMALLINT,
    [name] VARCHAR(50) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL,
	CONSTRAINT [u_group_name] UNIQUE ([name]),
	CONSTRAINT [fk_group_parent] FOREIGN KEY ([parent_id]) REFERENCES [group]([id])
)
/*
 * [id]          - Auto generated integer value.
 * [name]        - Descriptive name for the phase. **Unique**
 * [start]       - Integer value of how many days after an employees start date this phase begins.
 * [end]         - Integer value of how many days after an employees start date this phase ends.
 * [objectives]  - The objectives associated with this phase.
 * [description] - Description of what all this phase entails.
 * [status_id]   - Integer value associated with the current status of the phase. **[dbo].[status].[id]**
                     - ACTIVE, INACTIVE
 * 08/26/2015 0903 AM - josiahb
 */
CREATE TABLE [dbo].[phase]
(
	[id] SMALLINT IDENTITY(1, 1) PRIMARY KEY,
    [name] VARCHAR(200) NOT NULL, 
    [start] SMALLINT NOT NULL DEFAULT 0, 
    [end] SMALLINT NOT NULL DEFAULT 0, 
    [objectives] VARCHAR(2000) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_phase_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id]),
	CONSTRAINT [u_phase_name] UNIQUE ([name])
)
/*
 * [id]          - Auto generated integer value.
 * [name]        - Descriptive name for the recurrence type. **Unique**
 * [description] - Description of what the recurrence type is.
 * 08/26/2015 0926 AM - josiahb
 */
CREATE TABLE [dbo].[recurrence_type]
(
	[id] TINYINT IDENTITY(1, 1) PRIMARY KEY, 
    [name] VARCHAR(50) NOT NULL, 
    [description] VARCHAR(500) NOT NULL,
	CONSTRAINT [u_recurrencetype_name] UNIQUE ([name])
)
/*
 * [id]          - Auto generated integer value.
 * [topic]       - Topic for the given training.
 * [description] - Description of the given training.
 * [duration]    - Average duration for the training given in minutes.
 * [status_id]   - Integer value associated with the current status of the training. **[dbo].[status].[id]**
                     - ACTIVE, INACTIVE
 * 08/26/2015 0929 AM - josiahb
 */
CREATE TABLE [dbo].[training]
(
	[id] INT IDENTITY(1, 1) PRIMARY KEY, 
    [topic] VARCHAR(500) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL, 
    [duration] INT NOT NULL, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_training_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id])
)
/*
 * [id]                 - Auto generated integer value.
 * [training_id]        - Integer value associated with the ID of the linked training. **[dbo].[training].[id]**
 * [start_date]         - The first day for this training schedule to occur.
 * [recurrence]         - How many times with this training schedule recure
 * [recurrence_type_id] - Integer value associated with the ID of what type of recurrence this schedule should use. **[dbo].[recurrence_type].[id]**
 * [status_id]          - Integer value associated with the ID of the status for this training schedule. **[dbo].[status].[id]**
                            - ACTIVE, INACTIVE
 * 08/26/2015 0933 AM - josiahb
 */
CREATE TABLE [dbo].[training_schedule]
(
	[id] INT IDENTITY(1, 1) PRIMARY KEY, 
    [training_id] INT NOT NULL, 
    [start_date] DATETIME NOT NULL, 
    [recurrence] SMALLINT NOT NULL DEFAULT 0, 
    [recurrence_type_id] TINYINT NULL, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_trainingschedule_training] FOREIGN KEY ([training_id]) REFERENCES [training]([id]), 
    CONSTRAINT [fk_trainingschedule_recurrencetype] FOREIGN KEY ([recurrence_type_id]) REFERENCES [recurrence_type]([id]), 
    CONSTRAINT [fk_trainingschedule_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id])
)
/*
 * [id]          - Auto generated integer value.
 * [training_id] - Integer value associated with the ID of the linked training. **[dbo].[training].[id]**
 * [group_id]    - Integer value associated with the ID of the linked group. **[dbo].[group].[id]**
 * 08/26/2015 0934 AM - josiahb
 */
CREATE TABLE [dbo].[training_group]
(
    [training_id] INT NOT NULL, 
    [group_id] SMALLINT NOT NULL, 
	CONSTRAINT [pk_traininggroup] PRIMARY KEY ([training_id], [group_id]),
    CONSTRAINT [fk_traininggroup_training] FOREIGN KEY ([training_id]) REFERENCES [training]([id]), 
    CONSTRAINT [fk_traininggroup_group] FOREIGN KEY ([group_id]) REFERENCES [group]([id])
)
/*
 * [id]          - Auto generated integer value.
 * [training_id] - Integer value associated with the ID of the linked training. **[dbo].[training].[id]**
 * [link]        - Link to the associated material.
 * [description] - Description of what this material is used for.
 * [status_id]   - Integer value associated with the ID of the status for this training schedule. **[dbo].[status].[id]**
                     - ACTIVE, INACTIVE
 * 08/26/2015 0938 AM - josiahb
 */
CREATE TABLE [dbo].[training_material]
(
	[id] INT IDENTITY(1, 1) PRIMARY KEY, 
    [training_id] INT NOT NULL, 
    [link] VARCHAR(1000) NOT NULL, 
    [description] VARCHAR(2000) NOT NULL, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_trainingmaterial_training] FOREIGN KEY ([training_id]) REFERENCES [training]([id]), 
    CONSTRAINT [fk_trainingmaterial_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id])
)
/*
 * [id]          - Auto generated integer value.
 * [training_id] - Integer value associated with the ID of the linked training. **[dbo].[training].[id]**
 * [phase_id]    - Integer value assocaited with the ID of the phase for the defined training. **[dbo].[phase].[id]**
 * 08/26/2015 0939 AM - josiahb
 */
CREATE TABLE [dbo].[training_phase]
(
    [training_id] INT NOT NULL, 
    [phase_id] SMALLINT NOT NULL, 
	CONSTRAINT [pk_trainingphase] PRIMARY KEY ([training_id], [phase_id]),
    CONSTRAINT [fk_trainingphase_training] FOREIGN KEY ([training_id]) REFERENCES [training]([id]), 
    CONSTRAINT [fk_trainingphase_phase] FOREIGN KEY ([phase_id]) REFERENCES [phase]([id])
)
/*
 * [id]             - Auto generated integer value.
 * [email]          - Email address for the user (should be the @allencomm email). **Unique**
 * [password]       - Encrypted 256 bit password for the user to login.
 * [password_reset] - Boolean value of whether or not the user needs to reset their password.
                        - 0, 1
 * [first_name]     - First name of the user.
 * [last_name]      - Last name of the user.
 * [start_date]     - The date the user started working at Allen Comm.
 * [role_id]        - ID of the role the user is assigned to. **[dbo].[role].[id]**
 * [status_id]      - ID of the current user status. **[dbo].[status].[id]**
                        - ACTIVE, INACTIVE
 * 08/26/2015 0942 AM - josiahb
 */
CREATE TABLE [dbo].[users]
(
	[id] INT IDENTITY(1, 1) PRIMARY KEY, 
    [email] VARCHAR(100) NOT NULL, 
    [password] CHAR(256) NOT NULL, 
    [password_reset] TINYINT NOT NULL DEFAULT 1, 
    [first_name] VARCHAR(40) NOT NULL, 
    [last_name] VARCHAR(40) NOT NULL, 
    [start_date] DATE NOT NULL DEFAULT CONVERT(date, GETDATE()), 
    [role_id] SMALLINT NOT NULL, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_users_role] FOREIGN KEY ([role_id]) REFERENCES [role]([id]), 
    CONSTRAINT [fk_users_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id]),
	CONSTRAINT [u_users_email] UNIQUE ([email])
)
/*
 * [id]       - Auto generated integer value.
 * [user_id]  - ID of the associated user. **[dbo].[users].[id]**
 * [group_id] - ID of the group associated with the user. **[dbo].[group].[id]**
 * 08/26/2015 0944 AM - josiahb
 */
CREATE TABLE [dbo].[users_group]
(
    [user_id] INT NOT NULL, 
    [group_id] SMALLINT NOT NULL, 
	CONSTRAINT [pk_usersgroup] PRIMARY KEY ([user_id], [group_id]),
    CONSTRAINT [fk_usersgroup_users] FOREIGN KEY ([user_id]) REFERENCES [users]([id]), 
    CONSTRAINT [fk_usersgroup_group] FOREIGN KEY ([group_id]) REFERENCES [group]([id])
)
/*
 * [id]                   - Auto generated integer value.
 * [user_id]              - ID of the associated user. **[dbo].[users].[id]**
 * [training_schedule_id] - ID of the training schedule the user is assigned to. **[dbo].[training_schedule].[id]**
 * [recurrence]           - Which recurrence of the training schedule is the user assigned to.
 * [status_id]            - ID of the status for this user training schedule. **[dbo].[status].[id]**
                              - INCOMPLETE, COMPLETE, INACTIVE
 * 08/26/2015 0947 AM - josiahb
 */
CREATE TABLE [dbo].[users_training]
(
	[id] INT IDENTITY(1, 1) PRIMARY KEY, 
    [user_id] INT NOT NULL, 
    [training_schedule_id] INT NOT NULL, 
    [recurrence] SMALLINT NOT NULL DEFAULT 0, 
    [status_id] SMALLINT NOT NULL, 
    CONSTRAINT [fk_userstraining_users] FOREIGN KEY ([user_id]) REFERENCES [users]([id]), 
    CONSTRAINT [fk_userstraining_trainingschedule] FOREIGN KEY ([training_schedule_id]) REFERENCES [training_schedule]([id]), 
    CONSTRAINT [fk_userstraining_status] FOREIGN KEY ([status_id]) REFERENCES [status]([id])
)
/*
 * [id] - Auto generated integer value.
 * [training_id] - ID of the associated training. **[dbo].[training].[id]**
 * [user_id]     - ID of the user who is a facilitator for this training. **[dbo].[users].[id]**
 * 08/26/2015 0948 AM - josiahb
 */
CREATE TABLE [dbo].[training_facilitator]
(
    [training_id] INT NOT NULL, 
    [user_id] INT NOT NULL, 
	CONSTRAINT [pk_trainingfacilitator] PRIMARY KEY ([training_id], [user_id]),
    CONSTRAINT [fk_trainingfacilitator_training] FOREIGN KEY ([training_id]) REFERENCES [training]([id]), 
    CONSTRAINT [fk_trainingfacilitator_users] FOREIGN KEY ([user_id]) REFERENCES [users]([id])
)