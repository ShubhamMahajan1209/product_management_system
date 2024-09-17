SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema rdbmsproject
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `rdbmsproject` ;

-- -----------------------------------------------------
-- Schema rdbmsproject
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rdbmsproject` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `rdbmsproject` ;

-- -----------------------------------------------------
-- Table `rdbmsproject`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`user` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`user` (
  `User_ID` INT NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(40) NOT NULL,
  `Password` VARCHAR(15) NOT NULL,
  `Phone_Number` LONG NOT NULL,
  PRIMARY KEY (`User_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`address` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`address` (
  `Address_ID` INT NOT NULL,
  `Address_Line1` VARCHAR(45) NULL DEFAULT NULL,
  `Address_Line2` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(20) NULL DEFAULT NULL,
  `State` VARCHAR(20) NULL DEFAULT NULL,
  `Country` VARCHAR(20) NULL DEFAULT NULL,
  `PostalCode` INT NULL DEFAULT NULL,
  `user_User_ID` INT NOT NULL,
  PRIMARY KEY (`Address_ID`, `user_User_ID`),
  CONSTRAINT `fk_address_user1`
    FOREIGN KEY (`user_User_ID`)
    REFERENCES `rdbmsproject`.`user` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_address_user1_idx` ON `rdbmsproject`.`address` (`user_User_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`category` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`category` (
  `Category_ID` INT NOT NULL,
  `Category_Name` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`Category_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`orders` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`orders` (
  `Order_ID` INT NOT NULL,
  `Order_Date` DATE NULL DEFAULT NULL,
  `Total_Amount` INT NULL DEFAULT NULL,
  `user_User_ID` INT NOT NULL,
  PRIMARY KEY (`Order_ID`, `user_User_ID`),
  CONSTRAINT `fk_orders_user1`
    FOREIGN KEY (`user_User_ID`)
    REFERENCES `rdbmsproject`.`user` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_orders_user1_idx` ON `rdbmsproject`.`orders` (`user_User_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`product` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`product` (
  `Product_ID` INT NOT NULL,
  `Product_Name` VARCHAR(50) NULL DEFAULT NULL,
  `Description` VARCHAR(50) NULL DEFAULT NULL,
  `Price` INT NULL DEFAULT NULL,
  `Stock_Quantity` INT NULL DEFAULT NULL,
  `category_Category_ID` INT NOT NULL,
  PRIMARY KEY (`Product_ID`, `category_Category_ID`),
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`category_Category_ID`)
    REFERENCES `rdbmsproject`.`category` (`Category_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_product_category1_idx` ON `rdbmsproject`.`product` (`category_Category_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`orderitem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`orderitem` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`orderitem` (
  `OrderItem_ID` INT NOT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  `Subtotal` INT NULL DEFAULT NULL,
  `orders_Order_ID` INT NOT NULL,
  `orders_user_User_ID` INT NOT NULL,
  `product_Product_ID` INT NOT NULL,
  PRIMARY KEY (`OrderItem_ID`, `orders_Order_ID`, `orders_user_User_ID`, `product_Product_ID`),
  CONSTRAINT `fk_orderitem_orders1`
    FOREIGN KEY (`orders_Order_ID` , `orders_user_User_ID`)
    REFERENCES `rdbmsproject`.`orders` (`Order_ID` , `user_User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orderitem_product1`
    FOREIGN KEY (`product_Product_ID`)
    REFERENCES `rdbmsproject`.`product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_orderitem_orders1_idx` ON `rdbmsproject`.`orderitem` (`orders_Order_ID` ASC, `orders_user_User_ID` ASC) VISIBLE;

CREATE INDEX `fk_orderitem_product1_idx` ON `rdbmsproject`.`orderitem` (`product_Product_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`payment` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`payment` (
  `Payment_ID` INT NOT NULL,
  `Amount` INT NULL DEFAULT NULL,
  `Payment_Date` DATE NULL DEFAULT NULL,
  `Payment_Method` VARCHAR(20) NULL DEFAULT NULL,
  `user_User_ID` INT NOT NULL,
  `orders_Order_ID` INT NOT NULL,
  PRIMARY KEY (`Payment_ID`, `user_User_ID`, `orders_Order_ID`),
  CONSTRAINT `fk_payment_user1`
    FOREIGN KEY (`user_User_ID`)
    REFERENCES `rdbmsproject`.`user` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_orders1`
    FOREIGN KEY (`orders_Order_ID`)
    REFERENCES `rdbmsproject`.`orders` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_payment_user1_idx` ON `rdbmsproject`.`payment` (`user_User_ID` ASC) VISIBLE;

CREATE INDEX `fk_payment_orders1_idx` ON `rdbmsproject`.`payment` (`orders_Order_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `rdbmsproject`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rdbmsproject`.`review` ;

CREATE TABLE IF NOT EXISTS `rdbmsproject`.`review` (
  `Review_ID` INT NOT NULL,
  `Rating` INT NULL DEFAULT NULL,
  `Comment` VARCHAR(100) NULL DEFAULT NULL,
  `Review_Date` DATE NULL DEFAULT NULL,
  `user_User_ID` INT NOT NULL,
  `product_Product_ID` INT NOT NULL,
  PRIMARY KEY (`Review_ID`, `user_User_ID`, `product_Product_ID`),
  CONSTRAINT `fk_review_user1`
    FOREIGN KEY (`user_User_ID`)
    REFERENCES `rdbmsproject`.`user` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_product1`
    FOREIGN KEY (`product_Product_ID`)
    REFERENCES `rdbmsproject`.`product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_review_user1_idx` ON `rdbmsproject`.`review` (`user_User_ID` ASC) VISIBLE;

CREATE INDEX `fk_review_product1_idx` ON `rdbmsproject`.`review` (`product_Product_ID` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Create a trigger to update Subtotal when Quantity or Product_Price changes
DELIMITER $$
CREATE TRIGGER calculate_subtotal
BEFORE INSERT ON `rdbmsproject`.`orderitem`
FOR EACH ROW
BEGIN
    DECLARE product_price INT;
    -- Retrieve the price of the product
    SELECT Price INTO product_price
    FROM `rdbmsproject`.`product`
    WHERE Product_ID = NEW.product_Product_ID;

    -- Calculate the Subtotal based on Quantity and Product Price
    SET NEW.Subtotal = NEW.Quantity * product_price;
END$$
DELIMITER ;


INSERT INTO `rdbmsproject`.`user` (`User_ID`, `Username`, `Email`, `Password`, `Phone_Number`)
VALUES
(101, 'RahulKumar', 'rahulkumar@example.in', 'rahul123', 9123456780),
(102, 'PriyaSharma', 'priyasharma@example.in', 'priya456', 8123456789),
(103, 'AmitSingh', 'amitsingh@example.in', 'amit789', 7123456789),
(104, 'NehaPatel', 'nehapatel@example.in', 'neha123', 6123456789),
(105, 'RaviVerma', 'raviverma@example.in', 'ravi456', 5123456789),
(106, 'PoojaGupta', 'poojagupta@example.in', 'pooja789', 4123456789),
(107, 'AnkurJoshi', 'ankurjoshi@example.in', 'ankur123', 3123456789),
(108, 'SwatiShah', 'swatishah@example.in', 'swati456', 2123456789),
(109, 'VivekKhan', 'vivekkhan@example.in', 'vivek789', 1123456789),
(110, 'SnehaYadav', 'snehayadav@example.in', 'sneha123', 9123456780),
(111, 'AkashMishra', 'akashmishra@example.in', 'akash456', 8123456789),
(112, 'NishaSingh', 'nishasingh@example.in', 'nisha789', 7123456789),
(113, 'RajeshPatel', 'rajeshpatel@example.in', 'rajesh123', 6123456789),
(114, 'ShreyaVerma', 'shreyaverma@example.in', 'shreya456', 5123456789),
(115, 'AjayGupta', 'ajaygupta@example.in', 'ajay789', 4123456789),
(116, 'PreetiJain', 'preetijain@example.in', 'preeti123', 3123456789),
(117, 'RohanShah', 'rohanshah@example.in', 'rohan456', 2123456789),
(118, 'TanviKumar', 'tanvikumar@example.in', 'tanvi789', 1123456789),
(119, 'ManojYadav', 'manojyadav@example.in', 'manoj123', 9123456780),
(120, 'AnjaliMishra', 'anjali@example.in', 'anjali456', 8123456789);

INSERT INTO `rdbmsproject`.`address` (`Address_ID`, `Address_Line1`, `Address_Line2`, `City`, `State`, `Country`, `PostalCode`, `user_User_ID`)
VALUES
(1, '10, Main Street', 'Near City Park', 'Mumbai', 'Maharashtra', 'India', 400001, 101),
(2, '27, Green Avenue', 'Opposite Central Market', 'Delhi', 'Delhi', 'India', 110001, 102),
(3, '15, Lake View Road', 'Next to Metro Station', 'Bangalore', 'Karnataka', 'India', 560001, 103),
(4, '42, Park Street', 'Beside Shopping Mall', 'Kolkata', 'West Bengal', 'India', 700001, 104),
(5, '8, Beach Road', 'Near Marina Beach', 'Chennai', 'Tamil Nadu', 'India', 600001, 105),
(6, '20, Hill View Lane', 'Adjacent to City Park', 'Hyderabad', 'Telangana', 'India', 500001, 106),
(7, '35, Riverside Drive', 'Opposite City Center', 'Pune', 'Maharashtra', 'India', 411001, 107),
(8, '18, Sunset Avenue', 'Near Shopping Complex', 'Ahmedabad', 'Gujarat', 'India', 380001, 108),
(9, '5, Garden Road', 'Adjacent to Hospital', 'Surat', 'Gujarat', 'India', 395001, 109),
(10, '12, Mountain View Road', 'Next to Market', 'Jaipur', 'Rajasthan', 'India', 302001, 110),
(11, '30, Orchard Street', 'Opposite Plaza', 'Lucknow', 'Uttar Pradesh', 'India', 226001, 111),
(12, '22, Valley View Lane', 'Adjacent to Park', 'Kanpur', 'Uttar Pradesh', 'India', 208001, 112),
(13, '40, River Road', 'Near Shopping Mall', 'Nagpur', 'Maharashtra', 'India', 440001, 113),
(14, '9, Forest Lane', 'Beside Market', 'Indore', 'Madhya Pradesh', 'India', 452001, 114),
(15, '17, Ocean View Road', 'Adjacent to Garden', 'Thane', 'Maharashtra', 'India', 400601, 115),
(16, '25, Hillcrest Lane', 'Opposite Plaza', 'Bhopal', 'Madhya Pradesh', 'India', 462001, 116),
(17, '38, Lake Shore Road', 'Near Park', 'Visakhapatnam', 'Andhra Pradesh', 'India', 530001, 117),
(18, '11, Valley Road', 'Beside Mall', 'Patna', 'Bihar', 'India', 800001, 118),
(19, '7, Garden View Lane', 'Next to Market', 'Ludhiana', 'Punjab', 'India', 141001, 119),
(20, '14, River View Lane', 'Adjacent to Plaza', 'Agra', 'Uttar Pradesh', 'India', 282001, 120);

INSERT INTO `rdbmsproject`.`orders` (`Order_ID`, `Order_Date`, `Total_Amount`, `user_User_ID`)
VALUES
(1, '2024-04-01', 1000, 101),  -- First order for User 101
(2, '2024-04-02', 40, 103),  -- First order for User 103
(3, '2024-04-03', 25, 106),  -- First order for User 106
(4, '2024-04-04', 1500, 109),  -- First order for User 109
(5, '2024-04-05', 20, 102),  -- First order for User 102
(6, '2024-04-06', 1000, 110),  -- First order for User 110
(7, '2024-04-07', 1500, 107),  -- First order for User 107
(8, '2024-04-08', 1000, 111),  -- First order for User 111
(9, '2024-04-09', 40, 114),  -- First order for User 114
(10, '2024-04-10', 25, 105),  -- First order for User 105
(11, '2024-04-11', 1000, 107),  -- Second order for User 107
(12, '2024-04-12', 1500, 114),  -- Second order for User 114
(13, '2024-04-13', 1500, 111),  -- Second order for User 111
(14, '2024-04-14', 20, 105),  -- Second order for User 105
(15, '2024-04-15', 105, 110),  -- Second order for User 110
(16, '2024-04-16', 1500, 101),  -- Second order for User 101
(17, '2024-04-17', 20, 102),  -- Second order for User 102
(18, '2024-04-18', 2500, 111);  -- Third order for User 111

INSERT INTO `rdbmsproject`.`category` (`Category_ID`, `Category_Name`)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books'),
(4, 'Home Decor'),
(5, 'Sports');

INSERT INTO `rdbmsproject`.`product` (`Product_ID`, `Product_Name`, `Description`, `Price`, `Stock_Quantity`, `category_Category_ID`)
VALUES
(1001, 'Smartphone', 'Latest smartphone model', 1000, 50, 1), 
(1002, 'Laptop', 'High-performance laptop', 1500, 30, 1), 
(1003, 'Smart TV', 'Ultra HD smart television', 1200, 20, 1), 
(2001, 'T-shirt', 'Cotton t-shirt', 20, 100, 2), 
(2002, 'Jeans', 'Slim fit jeans', 30, 80, 2), 
(2003, 'Dress', 'Elegant evening dress', 50, 40, 2), 
(3001, 'Java Programming Book', 'Comprehensive guide to Java', 40, 60, 3), 
(3002, 'Cookbook', 'Collection of popular recipes', 25, 70, 3), 
(3003, 'Fiction Novel', 'Bestselling fiction novel', 30, 50, 3), 
(4001, 'Cushion Cover', 'Decorative cushion cover', 15, 90, 4), 
(4002, 'Wall Clock', 'Modern wall clock', 25, 70, 4), 
(4003, 'Table Lamp', 'Vintage-style table lamp', 20, 80, 4), 
(5001, 'Football', 'Professional football', 30, 40, 5), 
(5002, 'Tennis Racket', 'High-quality tennis racket', 50, 30, 5), 
(5003, 'Basketball', 'Official basketball', 40, 35, 5), 
(1004, 'Bluetooth Earphones', 'Wireless earphones', 25, 60, 1), 
(2004, 'Backpack', 'Durable backpack', 35, 50, 2), 
(1005, 'Gaming Mouse', 'High-performance gaming mouse', 40, 45, 1), 
(4004, 'Printed Mug', 'Custom printed mug', 10, 100, 4), 
(5004, 'Running Shoes', 'Comfortable running shoes', 60, 25, 5), 
(1006, 'Camera', 'Digital camera', 500, 15, 1), 
(4005, 'Desk Organizer', 'Desktop storage organizer', 15, 70, 4), 
(5005, 'Yoga Mat', 'Eco-friendly yoga mat', 20, 80, 5), 
(2005, 'Sunglasses', 'Polarized sunglasses', 30, 40, 2), 
(4006, 'Water Bottle', 'Insulated water bottle', 15, 90, 4);

INSERT INTO `rdbmsproject`.`payment` (`Payment_ID`, `Amount`, `Payment_Date`, `Payment_Method`, `user_User_ID`, `orders_Order_ID`)
VALUES
(1, 1000, '2024-04-20', 'Credit Card', 101, 1),
(2, 40, '2024-04-21', 'PayPal', 103, 2),
(3, 25, '2024-04-22', 'Credit Card', 106, 3),
(4, 1500, '2024-04-23', 'Credit Card', 109, 4),
(5, 20, '2024-04-24', 'PayPal', 102, 5),
(6, 1000, '2024-04-25', 'Cash on Delivery', 110, 6),
(7, 1500, '2024-04-26', 'Debit Card', 107, 7),
(8, 1000, '2024-04-27', 'PayPal', 111, 8),
(9, 40, '2024-04-28', 'Cash on Delivery', 114, 9),
(10, 25, '2024-04-29', 'Credit Card', 105, 10),
(11, 1000, '2024-04-30', 'PayPal', 107, 11),
(12, 1500, '2024-05-01', 'Credit Card', 114, 12),
(13, 1500, '2024-05-02', 'Credit Card', 111, 13),
(14, 30, '2024-05-03', 'Debit Card', 105, 14),
(15, 105, '2024-05-04', 'Credit Card', 110, 15),
(16, 1500, '2024-05-05', 'Cash on Delivery', 101, 16),
(17, 20, '2024-05-06', 'PayPal', 102, 17),
(18, 2500, '2024-05-07', 'Credit Card', 111, 18);

INSERT INTO `rdbmsproject`.`review` (`Review_ID`, `Rating`, `Comment`, `Review_Date`, `user_User_ID`, `product_Product_ID`)
VALUES
('1', 4, 'Great product, highly recommended!', '2024-04-25', 101, 1001),
('2', 5, 'Excellent book, very informative.', '2024-04-26', 103, 3001),
('3', 3, 'Average product, could be better.', '2024-04-27', 106, 3002),
('4', 5, 'Amazing quality, exceeded my expectations.', '2024-04-28', 109, 1002),
('5', 4, 'Good service, prompt delivery.', '2024-04-29', 102, 2001),
('6', 4, 'Satisfied with the purchase.', '2024-04-30', 110, 1001),
('7', 5, 'Fantastic product, worth the price!', '2024-05-01', 107, 1002),
('8', 3, 'Not as described, disappointed.', '2024-05-02', 111, 2002),
('9', 4, 'Impressed with the quality.', '2024-05-03', 114, 3001),
('10', 5, 'Highly recommended, will buy again!', '2024-05-04', 105, 3002),
('11', 5, 'Excellent service, quick response.', '2024-05-05', 107, 1001),
('12', 4, 'Good product, value for money.', '2024-05-06', 114, 2001),
('13', 3, 'Average book, could be better.', '2024-05-07', 111, 2002),
('14', 5, 'Very satisfied with the purchase.', '2024-05-08', 105, 3001),
('15', 4, 'Great quality, durable.', '2024-05-09', 110, 3002),
('16', 5, 'Wonderful experience, highly recommended!', '2024-05-10', 101, 1002),
('17', 4, 'Impressed with the service.', '2024-05-11', 102, 2001),
('18', 5, 'Excellent product, exceeded my expectations.', '2024-05-12', 111, 2002),
('19', 2, 'Poor quality, not worth the money.', '2024-05-13', 101, 1001),  -- Negative review
('20', 5, 'Great book, very helpful!', '2024-05-14', 101, 3001),
('21', 2, 'Disappointing book, not what I expected.', '2024-05-15', 103, 2001),  -- Negative review
('22', 2, 'Low quality, not satisfied.', '2024-05-16', 106, 3001);  -- Negative review

INSERT INTO `rdbmsproject`.`orderitem` (`OrderItem_ID`, `Quantity`, `Subtotal`, `orders_Order_ID`, `orders_user_User_ID`, `product_Product_ID`)
VALUES
(1, 1, 1000, 1, 101, 1001),  -- User 101's first order item (Smartphone)
(2, 1, 400, 2, 103, 3001),  -- User 103's first order item (Java Programming Book)
(3, 1, 25, 3, 106, 3002),  -- User 106's first order item (Cookbook)
(4, 1, 1500, 4, 109, 1002),  -- User 109's first order item (Laptop)
(5, 1, 20, 5, 102, 2001),  -- User 102's first order item (T-shirt)
(6, 1, 1000, 6, 110, 1001),  -- User 110's first order item (Smartphone)
(7, 1, 1500, 7, 107, 1002),  -- User 107's first order item (Laptop)
(8, 1, 1000, 8, 111, 1001),  -- User 111's first order item (Smartphone)
(9, 1, 40, 9, 114, 3001),  -- User 114's first order item (Java Programming Book)
(10, 1, 25, 10, 105, 3002),  -- User 105's first order item (Cookbook)
(11, 1, 1000, 11, 107, 1001),  -- User 107's second order item (Smartphone)
(12, 1, 1500, 12, 114, 1002),  -- User 114's second order item (Laptop)
(13, 1, 1500, 13, 111, 1002),  -- User 111's second order item (Laptop)
(14, 1, 30, 14, 105, 2001),  -- User 105's second order item (Jeans)
(15, 2, 80, 15, 110, 3001),  -- User 110's second order item (Java Programming Book)
(16, 1, 25, 15, 110, 3002),  -- User 110's second order item (Cookbook)
(17, 1, 1500, 16, 101, 1002),  -- User 101's second order item (Laptop)
(18, 1, 20, 17, 102, 2001),  -- User 102's second order item (T-shirt)
(19, 1, 1500, 18, 111, 1002),  -- User 111's third order item (Laptop)
(20, 1, 1500, 18, 111, 1001);  -- User 111's third order item (Laptop)
