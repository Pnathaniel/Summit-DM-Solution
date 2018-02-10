-- Originally Written:	February 1, 2018
-- Name:				Nathan Thompson
-- Phase II DM Build

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'SummitSalesDM')
	CREATE DATABASE SummitSalesDM
GO

USE SummitSalesDM

--
-- Delete existing tables
--

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactSales'
	)
	DROP TABLE FactSales

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEmployee'
	)
	DROP TABLE DimEmployee

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCustomer'
	)
	DROP TABLE DimCustomer

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProduct'
	)
	DROP TABLE DimProduct

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
	)
	DROP TABLE DimDate

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimTime'
	)
	DROP TABLE DimTime

--
-- Create tables
--

CREATE TABLE DimDate
	(Date_SK			INT						NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Date				DATE			UNIQUE	NOT NULL,
	Year				INT						NOT NULL,
	Month				INT						NOT NULL,
	Day_Of_Week			NVARCHAR(9)				NOT NULL,
	Holiday				NVARCHAR(50)			NOT NULL,
	);

CREATE TABLE DimTime
	(Time_SK			INT						NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Time				TIME			UNIQUE	NOT NULL,
	Hour				INT				UNIQUE	NOT NULL,
	Minute				INT						NOT NULL,
	);

CREATE TABLE DimProduct
	(Product_SK			INT				NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Product_AK			INT				NOT NULL,
	Product_Name		NVARCHAR(50)	NOT NULL,
	Product_Category	NVARCHAR(50)	NOT NULL,
	Vendor_Name			NVARCHAR(50)	NOT NULL,
	Product_Cost		MONEY			NOT NULL,
	Sale_Price			MONEY
	);

CREATE TABLE DimCustomer
	(Customer_SK		INT				NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Customer_AK			INT				NOT NULL,
	Zip_Code			NVARCHAR(5)		NOT NULL,
	Phone_Number		NVARCHAR(10)	NOT NULL
	);

CREATE TABLE DimEmployee
	(Employee_SK		INT				NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Employee_AK			INT				NOT NULL,
	Role				NVARCHAR(20)	NOT NULL,
	Last_Name			NVARCHAR(50)	NOT NULL,
	First_Name			NVARCHAR(50)	NOT NULL,
	);

--
CREATE TABLE FactSales
	(Customer_SK		INT				NOT NULL,
	Product_SK			INT				NOT NULL,
	Employee_SK			INT				NOT NULL,
	Sale_Date			DATE			NOT NULL,
	Sale_Time			TIME			NOT NULL,
	Sales				INT				NOT NULL,
	Quantity			INT				NOT NULL,
	Discount_Percent	DECIMAL(5,2)	NOT NULL,
	Revenue				MONEY			NOT NULL,
	Profit				MONEY			NOT NULL,
	CONSTRAINT	pk_FactSales			PRIMARY KEY (Customer_SK, Product_SK, Employee_SK, Sale_Date, Sale_Time),
	CONSTRAINT	fk_FactSales_DimDate	FOREIGN KEY (Sale_Date)		REFERENCES	DimDate(Date),
	CONSTRAINT	fk_Customer_DimCustomer FOREIGN KEY (Customer_SK)	REFERENCES	DimCustomer(Customer_SK),
	CONSTRAINT	fk_Product_DimProduct	FOREIGN KEY (Product_SK)	REFERENCES	DimProduct(Product_SK),
	CONSTRAINT	fk_Employee_DimEmployee	FOREIGN KEY (Employee_SK)	REFERENCES	DimEmployee(Employee_SK),
	CONSTRAINT	fk_FactSales_Sale_Time	FOREIGN KEY (Sale_Time)		REFERENCES	DimTime(Time)
	);
--
