USE [master]
GO
/****** Object:  Database [StockDev]    Script Date: 17/7/2023 16:40:30 ******/
CREATE DATABASE [StockDev]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StockDev', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\StockDev.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'StockDev_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\StockDev_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [StockDev] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StockDev].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StockDev] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StockDev] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StockDev] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StockDev] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StockDev] SET ARITHABORT OFF 
GO
ALTER DATABASE [StockDev] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StockDev] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StockDev] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StockDev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StockDev] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StockDev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StockDev] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StockDev] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StockDev] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StockDev] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StockDev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StockDev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StockDev] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StockDev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StockDev] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StockDev] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StockDev] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StockDev] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [StockDev] SET  MULTI_USER 
GO
ALTER DATABASE [StockDev] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StockDev] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StockDev] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StockDev] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [StockDev] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [StockDev] SET QUERY_STORE = OFF
GO
USE [StockDev]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [StockDev]
GO
/****** Object:  Table [dbo].[Vouchers]    Script Date: 17/7/2023 16:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vouchers](
	[Id] [uniqueidentifier] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[InsertDate] [smalldatetime] NOT NULL,
	[InsertUser] [nvarchar](128) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateUser] [nvarchar](128) NULL,
	[VouDate] [smalldatetime] NOT NULL,
	[BusinessEntityId] [uniqueidentifier] NOT NULL,
	[Number] [nvarchar](50) NULL,
	[Description] [nvarchar](128) NULL,
	[Amount] [numeric](18, 4) NOT NULL,
	[Active] [bit] NOT NULL,
	[CostCenterId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Vouchers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vTotalAmount]    Script Date: 17/7/2023 16:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vTotalAmount]
AS
SELECT BusinessEntityId AS Id, SUM(Amount) AS Total
	FROM dbo.Vouchers
	WHERE (Active = 1)
	GROUP BY BusinessEntityId
GO
/****** Object:  Table [dbo].[BusinessEntities]    Script Date: 17/7/2023 16:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessEntities](
	[Id] [uniqueidentifier] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[InsertDate] [smalldatetime] NOT NULL,
	[InsertUser] [nvarchar](128) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateUser] [nvarchar](128) NULL,
	[BEType] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CUIT] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[Phone] [nvarchar](50) NULL,
	[Email] [nvarchar](128) NULL,
	[Active] [bit] NOT NULL,
	[Address] [nvarchar](128) NULL,
 CONSTRAINT [PK_BusinessEntities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vEntryExit]    Script Date: 17/7/2023 16:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vEntryExit]
AS
	SELECT CAST(v.VouDate AS DATE) as VouDate, sum(v.Amount) as Subtotal
		FROM dbo.Vouchers v (nolock)
			join dbo.BusinessEntities be (nolock) on (be.id = v.BusinessEntityId)
		WHERE (v.Active = 1) 
			and ((v.Amount > 0 and be.BEType = 3) or (v.Amount < 0 and be.BEType = 2))
		GROUP BY CAST(v.VouDate AS DATE)
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 17/7/2023 16:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[State] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CostCenters]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CostCenters](
	[Id] [uniqueidentifier] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[InsertDate] [smalldatetime] NOT NULL,
	[InsertUser] [nvarchar](128) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateUser] [nvarchar](128) NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CostCenters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movements]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movements](
	[Id] [uniqueidentifier] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[InsertDate] [smalldatetime] NOT NULL,
	[InsertUser] [nvarchar](128) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateUser] [nvarchar](128) NULL,
	[ProductId] [uniqueidentifier] NOT NULL,
	[Quantity] [numeric](18, 4) NOT NULL,
	[Description] [nvarchar](128) NULL,
	[MovDate] [smalldatetime] NOT NULL,
	[Active] [bit] NOT NULL,
	[BusinessEntityId] [uniqueidentifier] NOT NULL,
	[VoucherId] [uniqueidentifier] NULL,
	[Price] [numeric](18, 4) NULL,
 CONSTRAINT [PK_Movements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [uniqueidentifier] NOT NULL,
	[Timestamp] [timestamp] NOT NULL,
	[InsertDate] [smalldatetime] NOT NULL,
	[InsertUser] [nvarchar](128) NOT NULL,
	[UpdateDate] [smalldatetime] NULL,
	[UpdateUser] [nvarchar](128) NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Stock] [numeric](18, 4) NOT NULL,
	[Code] [int] NOT NULL,
	[Price] [numeric](18, 4) NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Movements] ADD  CONSTRAINT [DF_Movements_MovDate]  DEFAULT (getdate()) FOR [MovDate]
GO
ALTER TABLE [dbo].[Movements] ADD  CONSTRAINT [DF_Movements_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Movements]  WITH CHECK ADD  CONSTRAINT [FK_Movements_BusinessEntities] FOREIGN KEY([BusinessEntityId])
REFERENCES [dbo].[BusinessEntities] ([Id])
GO
ALTER TABLE [dbo].[Movements] CHECK CONSTRAINT [FK_Movements_BusinessEntities]
GO
ALTER TABLE [dbo].[Movements]  WITH CHECK ADD  CONSTRAINT [FK_Movements_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[Movements] CHECK CONSTRAINT [FK_Movements_Products]
GO
ALTER TABLE [dbo].[Movements]  WITH CHECK ADD  CONSTRAINT [FK_Movements_Vouchers] FOREIGN KEY([VoucherId])
REFERENCES [dbo].[Vouchers] ([Id])
GO
ALTER TABLE [dbo].[Movements] CHECK CONSTRAINT [FK_Movements_Vouchers]
GO
ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_BusinessEntities] FOREIGN KEY([BusinessEntityId])
REFERENCES [dbo].[BusinessEntities] ([Id])
GO
ALTER TABLE [dbo].[Vouchers] CHECK CONSTRAINT [FK_Vouchers_BusinessEntities]
GO
ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_CostCenters] FOREIGN KEY([CostCenterId])
REFERENCES [dbo].[CostCenters] ([Id])
GO
ALTER TABLE [dbo].[Vouchers] CHECK CONSTRAINT [FK_Vouchers_CostCenters]
GO
/****** Object:  StoredProcedure [dbo].[sp_MovDelivery]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian Angaroni
-- Create date: 11/11/2018
-- Description:	Movemientos del Repartidor
-- Test: [dbo].[sp_MovDelivery] '2018-12-01 00:00:00','2018-12-01 23:59:59'
-- =============================================
CREATE PROCEDURE [dbo].[sp_MovDelivery]
	@DateFrom datetime,
	@DateTo datetime
AS
BEGIN
	SET NOCOUNT ON;

	declare @tDelivery table( ProductId uniqueidentifier, SubTotal [numeric](18, 4) NOT NULL)
	insert into @tDelivery 
		SELECT TOP 200 m.ProductId, SUM(m.Quantity)
			FROM dbo.Movements as m (nolock)
				join dbo.Products as p (nolock) on p.Id = m.ProductId
			WHERE m.Active = 1
				and m.BusinessEntityId = 'BA98B0DC-6DD6-4653-AF9D-208F2C9C2B05'
				and m.MovDate between @DateFrom and @DateTo
		GROUP BY  m.ProductId

	declare @tSale table( ProductId uniqueidentifier, SubTotal [numeric](18, 4) NOT NULL)
	insert into @tSale 
		SELECT TOP 200 m.ProductId, SUM(m.Quantity)
			FROM dbo.Movements as m (nolock)
				join dbo.Products as p (nolock) on p.Id = m.ProductId
			WHERE m.Active = 1
				and m.Quantity < 0
				and m.MovDate between @DateFrom and @DateTo
		GROUP BY  m.ProductId

	SELECT p.Id as 'ProductId'
		,p.Description
		,d.SubTotal as 'SubTotalEntry'
		,ISNULL(s.SubTotal,0) as 'SubTotalExit'
		,ISNULL(d.SubTotal + s.SubTotal,0)  as 'SubTotal'
		FROM dbo.Products as p (nolock)
			join @tDelivery as d on p.Id = d.ProductId
			left join @tSale as s on p.Id = s.ProductId

END
GO
/****** Object:  StoredProcedure [dbo].[sp_MovStateInf]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian
-- Create date: 24/01/2016
-- Description:	
---- Test: [dbo].[sp_MovStateInf] '2019-01-01 00:00:00', '2020-12-22 23:59:59', 0
-- =============================================
CREATE PROCEDURE [dbo].[sp_MovStateInf]
	@DateFrom datetime,
	@DateTo datetime,
	@IsEntry bit
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 500 p.Id, p.Description, p.Code
			,CONVERT(DATE,m.MovDate) MovDate
			,SUM(m.Quantity) SubTotal
		FROM dbo.Movements as m (nolock)
			join dbo.Products as p (nolock)
				on p.Id = m.ProductId
		WHERE m.Active = 1 
			and ((@IsEntry = 1 and m.Quantity > 0) or (@IsEntry = 0 and m.Quantity < 0))
			and MovDate between @DateFrom and @DateTo
		GROUP BY p.Id, p.Description, p.Code, CONVERT(DATE,m.MovDate)
		ORDER BY CONVERT(DATE,m.MovDate)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Stock]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian Angaroni
-- Create date: 16/12/2018
-- Description:	muestra el stock de los productos
-- =============================================
CREATE PROCEDURE [dbo].[sp_Stock]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Id]
		  ,[Timestamp]
		  ,[InsertDate]
		  ,[InsertUser]
		  ,[UpdateDate]
		  ,[UpdateUser]
		  ,[Description]
		  ,[Stock]
		  ,[Code]
		  ,[Price]
	  FROM [dbo].[Products]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VouAllGenerate]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian Angaroni
-- Create date: 18/02/2019
-- Description:	Listado de los comprobantes a genrear
-- Test: [dbo].[sp_VouAllGenerate]
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouAllGenerate]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT be.Id, be.BEType, be.Name, be.Phone, be.Description, SUM(m.Quantity * m.Price) as [Total]
	  FROM [dbo].[Movements] m (nolock)
	  join [dbo].[BusinessEntities] be (nolock) ON be.id = m.BusinessEntityId
	  WHERE m.Active = 1 
			and m.VoucherId is null 
			and m.BusinessEntityId != 'BA98B0DC-6DD6-4653-AF9D-208F2C9C2B05'
			and be.BEType = 3
	  GROUP BY be.Id, be.BEType, be.Name, be.Phone, be.Description
	  HAVING SUM(m.Quantity * m.Price) <> 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VouDebt]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian Angaroni
-- Create date: 11/12/2018
-- Description:	total de deuda de todas las entidades 1-Ambos 2-Proveedor 3-Cliente
-- Test: [dbo].[sp_VouDebt]
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouDebt]
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT be.Id, be.BEType, be.Name, be.Phone, be.Description, isnull(v.Total, 0) as [Total]
	FROM [dbo].[BusinessEntities] be (nolock)
		left join [dbo].[vTotalAmount] v on v.Id = be.Id
	WHERE v.Total is not null and v.Total <> 0
	ORDER BY be.Name
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VouEntry]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Damián Angaroni
-- Create date: 03/10/2019
-- Description:	muestra los comprobantes del dinero que ingresa
-- Test: [dbo].[sp_VouEntry] '2018-12-01 00:00:00','2019-12-01 23:59:59', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000'
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouEntry]
	@DateFrom datetime,
	@DateTo datetime,
	@BusinessEntityId uniqueidentifier,
	@CostCenterId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 200 v.Id
			,v.Timestamp
			,v.InsertDate
			,v.InsertUser
			,v.UpdateDate
			,v.UpdateUser
			,v.VouDate
			,v.BusinessEntityId
			,v.Number
			,v.Description
			,v.Amount
			,v.Active
			,v.CostCenterId
			,be.Name AS 'BusinessEntity'
			,cc.Name AS 'CostCenter'
		FROM [dbo].[Vouchers] v (nolock)
			join [dbo].[BusinessEntities] be (nolock) on (be.id = v.BusinessEntityId)
			join [dbo].[CostCenters] cc (nolock) on (cc.id = v.CostCenterId)
		WHERE v.Active = 1
			and v.VouDate between @DateFrom and @DateTo 
			and v.Amount > 0
			and (be.BEType = 1 or be.BEType = 3)
			and (@BusinessEntityId = '00000000-0000-0000-0000-000000000000' or v.BusinessEntityId = @BusinessEntityId)
			and (@CostCenterId = '00000000-0000-0000-0000-000000000000' or v.CostCenterId = @CostCenterId)
	ORDER BY v.VouDate 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_VouEntryExit]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damián Angaroni
-- Create date: 09/12/2018
-- Description:	muestra todo los ingresos y egresos filtrados por fecha
-- Test: [dbo].[sp_VouEntryExit] '2019-01-01 00:00:00', '2019-01-05 23:59:59'
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouEntryExit]
	@DateFrom datetime,
	@DateTo datetime
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 200 v.Id
		,v.BusinessEntityId
		,v.VouDate
		,be.Name AS 'BusinessEntity'
		,cc.Name AS 'CostCenter'
		,v.Number
		,v.InsertUser
		,v.Amount
	FROM [dbo].[Vouchers] v (nolock)
		join [dbo].[BusinessEntities] be (nolock) on (be.id = v.BusinessEntityId)
		join [dbo].[CostCenters] cc (nolock) on (cc.id = v.CostCenterId)
	WHERE (v.Active = 1) 
		and ((v.Amount > 0 and be.BEType = 3) or (v.Amount < 0 and be.BEType = 2))
		and v.VouDate between @DateFrom and @DateTo
	ORDER BY [VouDate]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VouEntryExitTotal]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damian Angaroni
-- Create date: 19/08/2019
-- Description:	devuelve el total acumulado de la entrada y salida de dinero
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouEntryExitTotal]
	@DateTo datetime
AS
BEGIN
	SET NOCOUNT ON;
	SELECT ISNULL(SUM(v.SubTotal),0) as Total FROM dbo.vEntryExit v WHERE v.VouDate < @DateTo
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VouExit]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Damián Angaroni
-- Create date: 03/10/2019
-- Description:	muestra los comprobantes del dinero que sale
-- Test: [dbo].[sp_VouExit] '2018-12-01 00:00:00','2019-12-01 23:59:59', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000'
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouExit]
	@DateFrom datetime,
	@DateTo datetime,
	@BusinessEntityId uniqueidentifier,
	@CostCenterId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 200 v.Id
			,v.Timestamp
			,v.InsertDate
			,v.InsertUser
			,v.UpdateDate
			,v.UpdateUser
			,v.VouDate
			,v.BusinessEntityId
			,v.Number
			,v.Description
			,v.Amount
			,v.Active
			,v.CostCenterId
			,be.Name AS 'BusinessEntity'
			,cc.Name AS 'CostCenter'
		FROM [dbo].[Vouchers] v (nolock)
			join [dbo].[BusinessEntities] be (nolock) on (be.id = v.BusinessEntityId)
			join [dbo].[CostCenters] cc (nolock) on (cc.id = v.CostCenterId)
		WHERE (v.Active = 1) 
			and v.VouDate between @DateFrom and @DateTo 
			and v.Amount < 0
			and (be.BEType = 1 or be.BEType = 2)
			and (@BusinessEntityId = '00000000-0000-0000-0000-000000000000' or v.BusinessEntityId = @BusinessEntityId)
			and (@CostCenterId = '00000000-0000-0000-0000-000000000000' or v.CostCenterId = @CostCenterId)
	ORDER BY v.VouDate 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_VouTotalAmount]    Script Date: 17/7/2023 16:40:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Damián Angaroni
-- Create date: 17/10/2018
-- Description:	muestra los ultimos 50 movimientos
-- Test: [dbo].[sp_VouTotalAmount] '18A0BF23-998E-4582-BCF9-7EAA882BD712'
-- =============================================
CREATE PROCEDURE [dbo].[sp_VouTotalAmount]
	@Id uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 50 v.Id
		  ,v.VouDate
		  ,cc.Name as CostCenterName
		  ,v.Number
		  ,v.Description
		  ,v.InsertDate
		  ,v.InsertUser
		  ,v.Amount
		  ,vv.Total
		FROM [dbo].[Vouchers] v (nolock)
			left join [dbo].[vTotalAmount] vv on vv.Id = v.BusinessEntityId
			left join [dbo].[CostCenters] cc (nolock) on cc.Id = v.CostCenterId
		WHERE (v.Active = 1) 
			and (v.BusinessEntityId = @Id)
	ORDER BY [VouDate] DESC
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'controlamos la baja logica del registro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Movements', @level2type=N'COLUMN',@level2name=N'Active'
GO
USE [master]
GO
ALTER DATABASE [StockDev] SET  READ_WRITE 
GO
