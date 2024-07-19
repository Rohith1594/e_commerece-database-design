create database e_commerce_db;
use e_commerce_db;

--Product Category Table
CREATE TABLE Category (
CategoryId INT IDENTITY(1,1),
CategoryName NVARCHAR(50) NOT NULL,
--Add other category-related fields as needed
CONSTRAINT PK_Category_CategoryId PRIMARY KEY (CategoryId)
);

-- Product Table
CREATE TABLE Product (
ProductId INT IDENTITY(1,1), --Add other product-related fields as needed
ProductName NVARCHAR(100) NOT NULL,
Price DECIMAL(10, 2) NOT NULL,
Quantity INT NOT NULL,
CategoryId INT,
CONSTRAINT PK_Product_ProductId PRIMARY KEY (ProductId),
CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryId) REFERENCES Category (CategoryId)
);

--Address Table (Combining Shipping and Billing Addresses
CREATE TABLE Address (
AddressId INT IDENTITY(1,1),
UserId INT,
Street NVARCHAR(255) NOT NULL,
City NVARCHAR(50) NOT NULL,
State NVARCHAR(50) NOT NULL,
ZipCode NVARCHAR (20) NOT NULL,
IsShippingAddress BIT NOT NULL,-- Indicates whether it's a shipping address
-- Add other address-related fields as needed
CONSTRAINT PK_Address_AddressId PRIMARY KEY (AddressId),
CONSTRAINT FK_Address_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId));

--Orders Table
CREATE TABLE Orders (
OrderId INT IDENTITY(1,1),
UserId INT,
OrderDate DATETIME NOT NULL,
TotalAmount DECIMAL (10, 2) NOT NULL,--Add other order-related fields as needed
CONSTRAINT PK_Orders_OrderId PRIMARY KEY (OrderId),
CONSTRAINT FK_Orders_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId)
);

--OrderItem Table (to represent items in an order)
CREATE TABLE OrderItem (
OrderItemId INT IDENTITY(1,1),
OrderId INT,
ProductId INT,
Quantity INT NOT NULL,
Price DECIMAL (10, 2) NOT NULL,
TotalCost DECIMAL (10, 2) NOT NULL,-- Added Totalcost column
--Add other order item-related fields as needed
CONSTRAINT PK_OrderItem_OrderItemId PRIMARY KEY (OrderItemId),
CONSTRAINT FK_OrderItem_Orders FOREIGN KEY (OrderId) REFERENCES Orders (OrderId),

CONSTRAINT FK_OrderItem_Product FOREIGN KEY (ProductId) REFERENCES Product (ProductId));



--Payment Information Table

CREATE TABLE PaymentInformation (
PaymentId INT IDENTITY(1,1),
OrderId INT,
Payment_Amount DECIMAL (10, 2) NOT NULL,
PaymentDate DATETIME NOT NULL,
PaymentMethod NVARCHAR(50),-- Store the payment method (e.g., "Credit Card", "PayPal", etc.)

--Add other payment-related fields as needed
CONSTRAINT PK_Payment_Information_PaymentId PRIMARY KEY (PaymentId),
CONSTRAINT FK_PaymentInformation_Orders FOREIGN KEY (OrderId) REFERENCES Orders (OrderId)
);



--OrderStatus Table
CREATE TABLE OrderStatus (
StatusId INT IDENTITY(1,1),
OrderId INT,
StatusName NVARCHAR(50) NOT NULL,
--Add other status-related fields as needed
CONSTRAINT PK_OrderStatus_StatusId PRIMARY KEY (StatusId),
CONSTRAINT FK_OrderStatus_Orders FOREIGN KEY (OrderId) REFERENCES Orders (OrderId));

--ProductReview Table
CREATE TABLE ProductReview (
ReviewId INT IDENTITY(1,1),
ProductId INT,
UserId INT,
Rating INT CHECK (Rating >= 1 AND Rating <= 5) NOT NULL,
ReviewText NVARCHAR(MAX),
ReviewDate DATETIME NOT NULL,
---Add other review-related fields as needed
CONSTRAINT PK_ProductReview_ReviewId PRIMARY KEY (ReviewId),
CONSTRAINT FK_ProductReview_Product FOREIGN KEY (ProductId) REFERENCES Product (ProductId),
CONSTRAINT FK_ProductReview_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId));

--ProductImage Table
CREATE TABLE ProductImage (
ImageId INT IDENTITY(1,1),
ProductId INT,
ImageUrl NVARCHAR (255) NOT NULL,
--Add other image-related fields as needed
CONSTRAINT PK_ProductImage_ImageId PRIMARY KEY (ImageId),
CONSTRAINT FK_ProductImage_Product FOREIGN KEY (ProductId) REFERENCES Product (ProductId)
);

--Coupon Table
CREATE TABLE Coupon (
CouponId INT IDENTITY(1,1),
CouponCode NVARCHAR (20) NOT NULL,
DiscountAmount DECIMAL (10, 2) NOT NULL,
ExpiryDate DATETIME NOT NULL,
ProductId INT,
--Nullable, to indicate product-specific coupon
CategoryId INT, --Nullable, to indicate category-specific coupon

--Add other coupon-related fields as needed
CONSTRAINT PK_Coupon_CouponId PRIMARY KEY (CouponId),
CONSTRAINT FK_Coupon_Product FOREIGN KEY (ProductId) REFERENCES Product (ProductId));


--User Profile Table
CREATE TABLE UserProfile (
UserId INT IDENTITY(1,1),
DisplayName NVARCHAR(100) NOT NULL CONSTRAINT DF_UserProfile_DisplayName DEFAULT 'Guest',
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Email NVARCHAR(100) NOT NULL,
AdObjId NVARCHAR(128) NOT NULL,
--Add other user-related fields as needed
CONSTRAINT PK_UserProfile_UserId PRIMARY KEY (UserId)
);
--Roles
CREATE TABLE Roles (
RoleId INT IDENTITY(1,1),
RoleName NVARCHAR(50) NOT NULL, --Admin, ReadOnly, Support, etc
CONSTRAINT PK_Roles_RoleId PRIMARY KEY (RoleId)
);

--UserRole Table
CREATE TABLE UserRole (
UserRoleId INT IDENTITY(1,1),
RoleId INT,
UserId INT,
CONSTRAINT PK_UserRole_UserRoleId PRIMARY KEY (UserRoleId),
CONSTRAINT FK_UserRole_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId),
CONSTRAINT FK_UserRole_Roles FOREIGN KEY (RoleId) REFERENCES Roles (RoleId));

--OrderCoupon Table
CREATE TABLE Order_Coupon (
Order_CouponId INT IDENTITY(1,1),
OrderId INT,
CouponId INT,
--Add other fields as needed, such as DiscountAmount
CONSTRAINT PK_OrderCoupon_OrderCouponId PRIMARY KEY (Order_CouponId),
CONSTRAINT FK_OrderCoupon_Orders FOREIGN KEY (OrderId) REFERENCES Orders (OrderId),
CONSTRAINT FK_OrderCoupon_Coupon FOREIGN KEY (CouponId) REFERENCES Coupon (CouponId));

--UserActivityLog Table
CREATE TABLE UserActivityLog (
LogId INT IDENTITY(1,1),
UserId INT,
ActivityType NVARCHAR(50) NOT NULL, ActivityDescription NVARCHAR(MAX),
LogDate DATETIME NOT NULL,
--Add other log-related fields as needed
CONSTRAINT PK_UserActivityLog_LogId PRIMARY KEY (LogId),
CONSTRAINT FK_UserActivityLog_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

--Cart Table
CREATE TABLE Cart (
CartId INT IDENTITY(1,1),
UserId INT,
ProductId INT,
Quantity INT NOT NULL,
--Add other cart-related fields as needed
CONSTRAINT PK_Cart_CartId PRIMARY KEY (CartId),
CONSTRAINT FK_Cart_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId),
CONSTRAINT FK_Cart_Product FOREIGN KEY (ProductId) REFERENCES Product (ProductId)
);

--Wishlist Table
CREATE TABLE Wishlist (
WishlistId INT IDENTITY(1,1),
UserId INT,
ProductId INT,
--Add other wishlist-related fields as needed
CONSTRAINT PK_Wishlist_WishlistId PRIMARY KEY (WishlistId),
CONSTRAINT FK_Wishlist_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile (UserId),
);

SELECT        
FROM            ProductImage INNER JOIN
                         Coupon INNER JOIN
                         Category ON Coupon.CategoryId = Category.CategoryId INNER JOIN
                         Order_Coupon ON Coupon.CouponId = Order_Coupon.CouponId INNER JOIN
                         Orders ON Order_Coupon.OrderId = Orders.OrderId INNER JOIN
                         OrderItem ON Orders.OrderId = OrderItem.OrderId INNER JOIN
                         OrderStatus ON Orders.OrderId = OrderStatus.OrderId INNER JOIN
                         PaymentInformation ON Orders.OrderId = PaymentInformation.OrderId INNER JOIN
                         Product ON Coupon.ProductId = Product.ProductId AND Category.CategoryId = Product.CategoryId AND OrderItem.ProductId = Product.ProductId INNER JOIN
                         Cart ON Product.ProductId = Cart.ProductId ON ProductImage.ProductId = Product.ProductId INNER JOIN
                         ProductReview ON Product.ProductId = ProductReview.ProductId INNER JOIN
                         UserProfile ON Orders.UserId = UserProfile.UserId AND Cart.UserId = UserProfile.UserId AND ProductReview.UserId = UserProfile.UserId INNER JOIN
                         Address ON UserProfile.UserId = Address.UserId INNER JOIN
                         UserActivityLog ON UserProfile.UserId = UserActivityLog.UserId INNER JOIN
                         UserRole ON UserProfile.UserId = UserRole.UserId INNER JOIN
                         Roles ON UserRole.RoleId = Roles.RoleId INNER JOIN
                         Wishlist ON UserProfile.UserId = Wishlist.UserId




