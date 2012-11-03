if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTQAss_suppl]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTQAss_suppl]

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTQStaff_suppl]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTQStaff_suppl]

CREATE TABLE [dbo].[tblTQAss_suppl] (
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

CREATE TABLE [dbo].[tblTQStaff_suppl] (
	[StaffKey] [varchar] (6) NULL ,
	[Year] [varchar] (4) NULL ,
	[Race] [varchar] (1) NULL ,
	[Gender] [varchar] (1) NULL ,
	[LocalExperience] [decimal](12, 6) NULL ,
	[TotalExperience] [decimal](12, 6) NULL ,
	[HighestDegreeEarned] [varchar] (1) NULL ,
	[Birthdate] [datetime] NULL
) ON [PRIMARY]


GRANT  SELECT  ON [dbo].[tblTQAss_suppl]  TO [public]

GRANT  SELECT  ON [dbo].[tblTQAss_suppl]  TO [netwisco]

GRANT  SELECT  ON [dbo].[tblTQStaff_suppl]  TO [public]

GRANT  SELECT  ON [dbo].[tblTQStaff_suppl]  TO [netwisco]

