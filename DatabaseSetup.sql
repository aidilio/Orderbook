IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'OrderBook')
BEGIN
	EXEC('CREATE DATABASE OrderBook')
END
GO

USE OrderBook
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('OrderBook.dbo.Customer'))
BEGIN
	CREATE TABLE Customer
	(
		Id INT PRIMARY KEY IDENTITY(1, 1),
		Name NVARCHAR(100) NOT NULL,
		Address NVARCHAR(100) NOT NULL
	)
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID('OrderBook.dbo.OrderData'))
BEGIN
	CREATE TABLE OrderData
	(
		Id INT PRIMARY KEY IDENTITY(1, 1),
		Date DATETIME NOT NULL,
		Description NVARCHAR(100) NOT NULL,
		Amount INT NOT NULL
	)
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID('OrderBook.dbo.OrderCustomer'))
BEGIN
	CREATE TABLE OrderCustomer
	(
		OrderId INT FOREIGN KEY REFERENCES OrderData(Id),
		CustomerId INT FOREIGN KEY REFERENCES Customer(Id),
		CONSTRAINT PK_CustomerOrder PRIMARY KEY (OrderId)
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.CreateNewOrder'))
   exec('CREATE PROCEDURE [dbo].[CreateNewOrder] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE dbo.CreateNewOrder 
(
	@CustomerName NVARCHAR(100),
	@CustomerAddress NVARCHAR(100),
	@OrderDescription NVARCHAR(100),
	@OrderAmount INT
)
AS
BEGIN

	DECLARE @CustomerId AS INT
	DECLARE @OrderId AS INT
	DECLARE @InsertedOrderId AS TABLE ( OrderId INT )
	DECLARE @OrderCreationDate AS DATETIME

	-- Check if customer already exists
	-- If not, create new customer
	IF NOT EXISTS (SELECT 1 FROM Customer WHERE Name = @CustomerName AND Address = @CustomerAddress)
	BEGIN
		INSERT INTO Customer(Name, Address) VALUES (@CustomerName, @CustomerAddress)
	END
	
	SELECT @CustomerId = Id FROM Customer WHERE Name = @CustomerName AND Address = @CustomerAddress

	-- Insert new order
	SET @OrderCreationDate = GETDATE()
	INSERT INTO OrderData(Date, Description, Amount) 
	OUTPUT inserted.Id INTO @InsertedOrderId (OrderId)
	VALUES (@OrderCreationDate, @OrderDescription, @OrderAmount)

	SET @OrderId = (SELECT TOP 1 OrderId FROM @InsertedOrderId)

	-- Link new order with customer
	INSERT INTO OrderCustomer (OrderId, CustomerId)
	VALUES (@OrderId, @CustomerId)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.UpdateExistingOrder'))
   exec('CREATE PROCEDURE [dbo].[UpdateExistingOrder] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROCEDURE dbo.UpdateExistingOrder
(
	@OrderId INT,
	@NewCustomerName AS NVARCHAR(100),
	@NewCustomerAddress AS NVARCHAR(100),
	@NewOrderDescription AS NVARCHAR(100),
	@NewOrderAmount AS INT
)
AS
BEGIN
	DECLARE @CustomerId AS INT

	-- Check if customer already exists
	-- If not, create new customer
	IF NOT EXISTS (SELECT 1 FROM Customer WHERE Name = @NewCustomerName AND Address = @NewCustomerAddress)
	BEGIN
		INSERT INTO Customer(Name, Address) VALUES (@NewCustomerName, @NewCustomerAddress)
	END
	
	SELECT @CustomerId = Id FROM Customer WHERE Name = @NewCustomerName AND Address = @NewCustomerAddress

	UPDATE OrderData
	SET Description = @NewOrderDescription, Amount = @NewOrderAmount
	WHERE Id = @OrderId

	UPDATE Ordercustomer
	SET CustomerId = @CustomerId
	WHERE OrderId = @OrderId
END
GO
