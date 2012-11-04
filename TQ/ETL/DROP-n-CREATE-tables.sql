if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblEseaCore]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblEseaCore]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTQAss]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTQAss]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTQStaff]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTQStaff]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblWMAS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblWMAS]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTeacherQualificationsAlpha]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTeacherQualificationsAlpha]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTeacherQualifications]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTeacherQualifications]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTQAssBeta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTQAssBeta]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTeacherQualificationsBeta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTeacherQualificationsBeta]

CREATE TABLE [dbo].[tblEseaCore] (
	[DPICode] [varchar] (2) NULL ,
	[DPIName] [varchar] (40) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[tblTQAss] (
	[StaffKey] [varchar] (6) NULL ,
	[Year] [varchar] (4) NULL ,
	[WorkAgencyKey] [varchar] (5) NULL ,
	[HireAgencyKey] [varchar] (5) NULL ,
	[AssignmentType] [varchar] (2) NULL ,
	[PositionCode] [varchar] (2) NULL ,
	[AssignmentCode] [varchar] (4) NULL ,
	[WMASCode] [varchar] (2) NULL ,
	[ESAECoreCategory] [varchar] (2) NULL ,
	[WiscLicenseStatus] [varchar] (1) NULL ,
	[ESEAHighlyQualified] [varchar] (1) NULL ,
	[FTE] [decimal](12, 6) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[tblTQStaff] (
	[StaffKey] [varchar] (6) NULL ,
	[Year] [varchar] (4) NULL ,
	[Race] [varchar] (1) NULL ,
	[Gender] [varchar] (1) NULL ,
	[LocalExperience] [decimal](12, 6) NULL ,
	[TotalExperience] [decimal](12, 6) NULL ,
	[HighestDegreeEarned] [varchar] (1) NULL ,
	[Birthdate] [datetime] NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[tblWMAS] (
	[WMASCode] [int] NULL ,
	[WMASCodeTQAss] [varchar] (2) NULL ,
	[Description] [varchar] (40) NULL
) ON [PRIMARY]

GRANT  SELECT  ON [dbo].[tblEseaCore]  TO [public]

GRANT  SELECT  ON [dbo].[tblEseaCore]  TO [netwisco]

GRANT  SELECT  ON [dbo].[tblTQAss]  TO [public]

GRANT  SELECT  ON [dbo].[tblTQAss]  TO [netwisco]

GRANT  SELECT  ON [dbo].[tblTQStaff]  TO [public]

GRANT  SELECT  ON [dbo].[tblTQStaff]  TO [netwisco]

GRANT  SELECT  ON [dbo].[tblWMAS]  TO [public]

GRANT  SELECT  ON [dbo].[tblWMAS]  TO [netwisco]

