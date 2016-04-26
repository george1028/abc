set foreign_key_checks=0;
create schema if not exists `project`;
use `project`;
#create parent tables first
create table if not exists project.tblIPRType(
`IPRTypeID` int not null auto_increment,
`IPRType` varchar(99),
primary key(`IPRTypeID`),
unique index `IPRTypeID_unique` (`IPRTypeID` asc)
)engine=InnoDB;
create table if not exists project.tblCountry(
`CountryCode` int not null,
`CountryAcronym` varchar(9),
`CountryName` varchar(199),
primary key(`CountryCode`),
unique index `CountryCode_unique` (`CountryCode` asc)
)engine=InnoDB;
create table if not exists project.tblDate(
`DateID` int(2) not null auto_increment,
`DateNumber` int(2),
primary key(`DateID`),
unique index `DateID_unique`(`DateID` asc)
)engine=InnoDB;
create table if not exists project.tblMonth(
`MonthID` int(2) not null auto_increment,
`MonthName` varchar(19),
primary key(`MonthID`),
unique index `MonthID_unique` (`MonthID` asc)
)engine=InnoDB;
create table if not exists tblYear(
`YearID` int not null auto_increment,
`YearNumber` int(4),
primary key(`YearID`),
unique index `YearID_unique`(`YearID` asc)
)engine=InnoDB;
create table if not exists project.tblGenre(
`GenreID` int not null auto_increment,
`GenreName` varchar(19),
`GenreDescription` text,
primary key(`GenreID`),
unique index `GenreID_unique`(`GenreID` asc)
)engine=InnoDB;
create table if not exists project.tblAgeGroup(
`AgeGroupID` int not null auto_increment,
`MinimumAge` int(2),
`MaximumAge` int(2),
`GroupDescription` varchar(99),
primary key(`AgeGroupID`),
unique index `AgeGroupID_unique`(`AgeGroupID` asc)
)engine=InnoDB;
create table if not exists project.tblGender(
`GenderID` int(1) not null auto_increment,
`GenderName` varchar(9),
primary key(`GenderID`),
unique index `GenderID_unique`(`GenderID` asc)
)engine=InnoDB;
create table if not exists project.tblStage(
`StageID` int not null auto_increment,
`StageName` varchar(19),
`StageDescription` varchar(99),
primary key(`StageID`),
unique index `StageID_unique`(`StageID` asc)
)engine=InnoDB;
create table if not exists project.tblMediaOutlet(
`MediaOutletID` int not null auto_increment,
`MediaType` varchar(19),
`MediaDescription` varchar(99),
primary key(`MediaOutletID`),
unique index `MediaOutletID_unique`(`MediaOutletID` asc)
)engine=InnoDB;
create table if not exists project.tblDepartment(
`DepartmentID` int not null auto_increment,
`DepartmentName` varchar(19),
`DepartmentDescription` varchar(99),
primary key(`DepartmentID`),
unique index `DepartmentID_unique`(`DepartmentID` asc)
)engine=InnoDB;
#create child tables from those with least connections to the parent tables
create table if not exists project.tblPosition(
`PositionID` int not null auto_increment,
`PositionTitle` varchar(19),
`PositionDescription` varchar(99),
`DepartmentID` int not null,
primary key(`PositionID`),
unique index `PositionID_unique`(`PositionID` asc),
index `DepartmentToDetails_idx`(`DepartmentID` asc),
constraint `DepartmentToDetails`
 foreign key(`DepartmentID`)
 references project.tblDepartment(`DepartmentID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblState(
`StateID` int not null auto_increment,
`StateName` varchar(29),
`StateAcronym` varchar(9),
`CountryCode` int not null,
primary key(`StateID`),
unique index `StateID_unique`(`StateID` asc),
index `CountryToDetails_idx`(`CountryCode` asc),
constraint `CountryToDetails`
 foreign key(`CountryCode`)
 references project.tblCountry(`CountryCode`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblCity(
`CityID` int not null auto_increment,
`CityName` varchar(19),
`StateID` int not null,
primary key(`CityID`),
unique index `CityID_unique`(`CityID` asc),
index `StateToDetails_idx`(`StateID` asc),
constraint `StateToDetails`
 foreign key(`StateID`)
 references project.tblState(`StateID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblSuburb(
`PostCode` int not null,
`SuburbName` varchar(19),
`CityID` int not null,
primary key(`PostCode`),
unique index `PostCode_unique`(`PostCode` asc),
index `CityToDetails_idx`(`CityID` asc),
constraint `CityToDetails`
 foreign key(`CityID`)
 references project.tblCity(`CityID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblEmployee(
`EmployeeID` int not null auto_increment,
`EmployeeName` varchar(29),
`EmployeeAge` int(2),
`EmployeeAddress` varchar(29),
`PostCode` int not null,
`ManagerID` int,
`PositionID` int not null,
primary key(`EmployeeID`),
unique index `EmployeeID_unique`(`EmployeeID` asc),
index `SuburbToDetails_idx`(`PostCode` asc),
index `ManagerToDetails_idx`(`ManagerID` asc),
index `PositionToDetails_idx`(`PositionID` asc),
constraint `SuburbToDetails`
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade,
constraint `ManagerToDetails`
 foreign key(`ManagerID`)
 references project.tblEmployee(`EmployeeID`)
 on delete restrict
 on update cascade,
constraint `PositionToDetails`
 foreign key(`PositionID`)
 references project.tblPosition(`PositionID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblSupplier(
`SupplierID` int not null auto_increment,
`SupplierName` varchar(29),
`SupplierAddress` varchar(29),
`SupplierContact` varchar(19),
`PostCode` int not null,
primary key(`SupplierID`),
unique index `SupplierID_unique`(`SupplierID` asc),
index `SupplierSuburbToDetails_idx`(`PostCode` asc),
constraint `SupplierSuburbToDetails`
#constraint's name must be unique for each table inside the database
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblDistribution(
`DistributionID` int not null auto_increment,
`DistributionName` varchar(29),
`DistributionAddress` varchar(39),
`DistributionContact` varchar(19),
`PostCode` int not null,
primary key(`DistributionID`),
unique index `DistributionID_unique`(`DistributionID` asc),
index `DistributionSuburbToDetails_idx`(`PostCode` asc),
constraint `DistributionSuburbToDetails`
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblCustomer(
`CustomerID` int not null auto_increment,
`CustomerName` varchar(39),
`CustomerContact` varchar(19),
`CustomerAddress` varchar(39),
`PostCode` int not null,
primary key(`CustomerID`),
unique index `CustomerID_unique`(`CustomerID` asc),
index `CustomerSuburbToDetails_idx`(`PostCode` asc),
constraint `CustomerSuburbToDetails`
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblCustomerBusiness(
`BusinessNumber` varchar(11) not null,
# "11" is the true length of the Australia Business Number and because the maximum number of integer is a 10-digit number "int" type can't be used here otherwise it will cause the "Duplicate entry for key" problem. (jp, 2009)
`CustomerID` int not null,
primary key(`BusinessNumber`),
unique index `BusinessNumber_unique`(`BusinessNumber` asc),
index `CustomerToDetails_idx`(`CustomerID` asc),
constraint `CustomerToDetails`
 foreign key(`CustomerID`)
 references project.tblCustomer(`CustomerID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblManufacture(
`ManufactureID` int not null auto_increment,
`ManufactureName` varchar(39),
`ManufactureContact` varchar(19),
`ManufactureAddress` varchar(39),
`PostCode` int not null,
primary key(`ManufactureID`),
unique index `ManufactureID_unique`(`ManufactureID` asc),
index `ManufactureSuburbToDetails_idx`(`PostCode` asc),
constraint `ManufactureSuburbToDetails`
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblRetailOutlet(
`OutletID` int not null auto_increment,
`OutletName` varchar(39),
`OutletContact` varchar(19),
`OutletAddress` varchar(39),
`PostCode` int not null,
`CustomerID` int not null,
primary key(`OutletID`),
unique index `OutletID_unique`(`OutletID` asc),
index `RetailOutletSuburbToDetails_idx`(`PostCode` asc),
index `RetailOutletCustomerToDetails_idx`(`CustomerID` asc),
constraint `RetailOutletSuburbToDetails`
 foreign key(`PostCode`)
 references project.tblSuburb(`PostCode`)
 on delete restrict
 on update cascade,
constraint `RetailOutletCustomerToDetails`
 foreign key(`CustomerID`)
 references project.tblCustomer(`CustomerID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblSalesInvoice(
`InvoiceID` int not null auto_increment,
`InvoiceTime` time,
`CustomerID` int not null,
`EmployeeID` int not null,
`DateID` int not null,
`MonthID` int not null,
`YearID` int not null,
primary key(`InvoiceID`),
unique index `InvoiceID_unique`(`InvoiceID` asc),
index `SalesInvoiceCustomerToDetails_idx`(`CustomerID` asc),
index `SalesInvoiceEmployeeToDetails_idx`(`EmployeeID` asc),
index `SalesInvoiceDateToDetails_idx`(`DateID` asc),
index `SalesInvoiceMonthToDetails_idx`(`MonthID` asc),
index `SalesInvoiceYearToDetails_idx`(`YearID` asc),
constraint `SalesInvoiceCustomerToDetails`
 foreign key(`CustomerID`)
 references project.tblCustomer(`CustomerID`)
 on delete restrict
 on update cascade,
constraint `SalesInvoiceEmployeeToDetails`
 foreign key(`EmployeeID`)
 references project.tblEmployee(`EmployeeID`)
 on delete restrict
 on update cascade,
constraint `SalesInvoiceDateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `SalesInvoiceMonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade,
constraint `SalesInvoiceYearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblIPR(
`IPRID` int not null auto_increment,
`YearID` int not null,
`DateID` int not null,
`MonthID` int not null,
`CountryCode` int not null,
`IPRTypeID` int not null,
`SupplierID` int not null,
primary key(`IPRID`),
unique index `IPRID_unique`(`IPRID` asc),
index `IPRYearToDetails_idx`(`YearID` asc),
index `IPRDateToDetails_idx`(`DateID` asc),
index `IPRMonthToDetails_idx`(`MonthID` asc),
index `IPRCountryToDetails_idx`(`CountryCode` asc),
index `IPRTypeToDetails_idx`(`IPRTypeID` asc),
index `SupplierToDetails_idx`(`SupplierID` asc),
constraint `IPRYearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade,
constraint `IPRDateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `IPRMonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade,
constraint `IPRCountryToDetails`
 foreign key(`CountryCode`)
 references project.tblCountry(`CountryCode`)
 on delete restrict
 on update cascade,
constraint `IPRTypeToDetails`
 foreign key(`IPRTypeID`)
 references project.tblIPRType(`IPRTypeID`)
 on delete restrict
 on update cascade,
constraint `SupplierToDetails`
 foreign key(`SupplierID`)
 references project.tblSupplier(`SupplierID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblInventory(
`ProductISBN` varchar(29) not null,
`ProductName` varchar(39),
`ProductDescription` varchar(299),
`ProductPrice` decimal(9,2),
#maximum number allowed is 9,999,999.99
`ProductQuantity` int,
`RetailPrice` decimal(9,2),
`LicenseFee` decimal(9,2),
`DistributionID` int not null,
`GenreID` int not null,
`IPRID` int not null,
primary key(`ProductISBN`),
unique index `ProductISBN_unique`(`ProductISBN` asc),
index `DistributionToDetails_idx`(`DistributionID` asc),
index `GenreToDetails_idx`(`GenreID` asc),
index `IPRToDetails_idx`(`IPRID` asc),
constraint `DistributionToDetails`
 foreign key(`DistributionID`)
 references project.tblDistribution(`DistributionID`)
 on delete restrict
 on update cascade,
constraint `GenreToDetails`
 foreign key(`GenreID`)
 references project.tblGenre(`GenreID`)
 on delete restrict
 on update cascade,
constraint `IPRToDetails`
 foreign key(`IPRID`)
 references project.tblIPR(`IPRID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblSalesItem(
`ItemID` int not null auto_increment,
`ItemQuantity` int,
`ProductISBN` varchar(29) not null,
`InvoiceID` int not null,
primary key(`ItemID`),
unique index `ItemID_unique`(`ItemID` asc),
index `ProductToDetails_idx`(`ProductISBN` asc),
index `InvoiceToDetails_idx`(`InvoiceID` asc),
constraint `ProductToDetails`
 foreign key(`ProductISBN`)
 references project.tblInventory(`ProductISBN`)
 on delete restrict
 on update cascade,
constraint `InvoiceToDetails`
 foreign key(`InvoiceID`)
 references project.tblSalesInvoice(`InvoiceID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblGamePlayed(
`GameID` int not null auto_increment,
`ProductISBN` varchar(29) not null,
`AgeGroupID` int not null,
`GenderID` int not null,
primary key(`GameID`),
unique index `GameID_unique`(`GameID`),
index `GamePlayedProductToDetails_idx`(`ProductISBN` asc),
index `GamePlayedAgeGroupToDetails_idx`(`AgeGroupID` asc),
index `GamePlayedGenderToDetails_idx`(`GenderID` asc),
constraint `GamePlayedProductToDetails`
 foreign key(`ProductISBN`)
 references project.tblInventory(`ProductISBN`)
 on delete restrict
 on update cascade,
constraint `GamePlayedAgeGroupToDetails`
 foreign key(`AgeGroupID`)
 references project.tblAgeGroup(`AgeGroupID`)
 on delete restrict
 on update cascade,
constraint `GamePlayedGenderToDetails`
 foreign key(`GenderID`)
 references project.tblGender(`GenderID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblOutsourcingInvoice(
`InvoiceID` int not null auto_increment,
`EmployeeID` int not null,
`ManufactureID` int not null,
`MonthID` int not null,
`DateID` int not null,
`YearID` int not null,
primary key(`InvoiceID`),
unique index `InvoiceID_unique`(`InvoiceID` asc),
index `EmployeeToDetails_idx`(`EmployeeID` asc),
index `ManufactureToDetails_idx`(`ManufactureID` asc),
index `MonthToDetails_idx`(`MonthID` asc),
index `DateToDetails_idx`(`DateID` asc),
index `YearToDetails_idx`(`YearID` asc),
constraint `EmployeeToDetails`
 foreign key(`EmployeeID`)
 references project.tblEmployee(`EmployeeID`)
 on delete restrict
 on update cascade,
constraint `ManufactureToDetails`
 foreign key(`ManufactureID`)
 references project.tblManufacture(`ManufactureID`)
 on delete restrict
 on update cascade,
constraint `MonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade,
constraint `DateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `YearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblProduction(
`ProductID` int not null auto_increment,
`ProductName` varchar(29),
`ProductDescription` varchar(299),
`CompletedPercentage` decimal(3,2),
#maximum value is "9.99" because the project can be completed before deadline
`PlannedDays` int,
`EmployeeID` int,
`YearID` int not null,
`DateID` int not null,
`MonthID` int not null,
`GenreID` int not null,
`IPRID` int,
`StageID` int not null,
primary key(`ProductID`),
unique index `ProductID_unique`(`ProductID` asc),
index `ProductionEmployeeToDetails_idx`(`EmployeeID` asc),
index `ProductionYearToDetails_idx`(`YearID` asc),
index `ProductionDateToDetails_idx`(`DateID` asc),
index `ProductionMonthToDetails_idx`(`MonthID` asc),
index `ProductionGenreToDetails_idx`(`GenreID` asc),
index `ProductionIPRToDetails_idx`(`IPRID` asc),
index `StageToDetails_idx`(`StageID` asc),
constraint `ProductionEmployeeToDetails`
 foreign key(`EmployeeID`)
 references project.tblEmployee(`EmployeeID`)
 on delete restrict
 on update cascade,
constraint `ProductionYearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade,
constraint `ProductionDateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `ProductionMonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade,
constraint `ProductionGenreToDetails`
 foreign key(`GenreID`)
 references project.tblGenre(`GenreID`)
 on delete restrict
 on update cascade,
constraint `ProductionIPRToDetails`
 foreign key(`IPRID`)
 references project.tblIPR(`IPRID`)
 on delete restrict
 on update cascade,
constraint `StageToDetails`
 foreign key(`StageID`)
 references project.tblStage(`StageID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblPromotionEvent(
`EventID` int not null auto_increment,
`PromotionCost` decimal(9,2),
`Duration` int,
#Duration is the number of days for promotion
`EmployeeID` int not null,
`ProductID` int not null,
`YearID` int not null,
`DateID` int not null,
`MediaOutletID` int not null,
`MonthID` int not null,
primary key(`EventID`),
unique index `EventID_unique`(`EventID` asc),
index `EventEmployeeToDetails_idx`(`EmployeeID` asc),
index `EventProductToDetails_idx`(`ProductID` asc),
index `EventYearToDetails_idx`(`YearID` asc),
index `EventDateToDetails_idx`(`DateID` asc),
index `EventMediaOutletToDetails_idx`(`MediaOutletID` asc),
index `EventMonthToDetails_idx`(`MonthID` asc),
constraint `EventEmployeeToDetails`
 foreign key(`EmployeeID`)
 references project.tblEmployee(`EmployeeID`)
 on delete restrict
 on update cascade,
#if the employee resigned, the project can be passed onto someone else before the employee's record is deleted and only those who are not referenced can be deleted
constraint `EventProductToDetails`
 foreign key(`ProductID`)
 references project.tblProduction(`ProductID`)
 on delete restrict
 on update cascade,
constraint `EventYearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade,
constraint `EventDateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `EventMediaOutletToDetails`
 foreign key(`MediaOutletID`)
 references project.tblMediaOutlet(`MediaOutletID`)
 on delete restrict
 on update cascade,
constraint `EventMonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblOutsourcedProduct(
`ItemID` int not null auto_increment,
`OutsourcingCost` decimal(9,2),
`Quantity` int,
`CompletedPercentage` decimal(3,2),
`ProductID` int not null,
`InvoiceID` int not null,
`DateID` int not null,
`MonthID` int not null,
`YearID` int not null,
primary key(`ItemID`),
unique index `ItemID_unique`(`ItemID` asc),
index `OutsourcedProductToDetails_idx`(`ProductID` asc),
index `OutsourcedInvoiceToDetails_idx`(`InvoiceID` asc),
index `OutsourcedDateToDetails_idx`(`DateID` asc),
index `OutsourcedMonthToDetails_idx`(`MonthID` asc),
index `OutsourcedYearToDetails_idx`(`YearID` asc),
constraint `OutsourcedProductToDetails`
 foreign key(`ProductID`)
 references project.tblProduction(`ProductID`)
 on delete restrict
 on update cascade,
constraint `OutsourcedInvoiceToDetails`
 foreign key(`InvoiceID`)
 references project.tblOutsourcingInvoice(`InvoiceID`)
 on delete restrict
 on update cascade,
constraint `OutsourcedDateToDetails`
 foreign key(`DateID`)
 references project.tblDate(`DateID`)
 on delete restrict
 on update cascade,
constraint `OutsourcedMonthToDetails`
 foreign key(`MonthID`)
 references project.tblMonth(`MonthID`)
 on delete restrict
 on update cascade,
constraint `OutsourcedYearToDetails`
 foreign key(`YearID`)
 references project.tblYear(`YearID`)
 on delete restrict
 on update cascade
)engine=InnoDB;
create table if not exists project.tblGameTested(
`GameID` int not null auto_increment,
`AgeGroupID` int,
`GenderID` int,
`ProductID` int,
primary key(`GameID`),
unique index `GameID_unique`(`GameID` asc),
index `GameTestedAgeGroupToDetails_idx`(`AgeGroupID` asc),
index `GameTestedGenderToDetails_idx`(`GenderID` asc),
index `GameTestedProductToDetails_idx`(`ProductID` asc),
constraint `GameTestedAgeGroupToDetails`
 foreign key(`AgeGroupID`)
 references project.tblAgeGroup(`AgeGroupID`)
 on delete restrict
 on update cascade,
constraint `GameTestedGenderToDetails`
 foreign key(`GenderID`)
 references project.tblGender(`GenderID`)
 on delete restrict
 on update cascade,
constraint `GameTestedProductToDetails`
 foreign key(`ProductID`)
 references project.tblProduction(`ProductID`)
 on delete restrict
 on update cascade
)engine=InnoDB;

Set foreign_key_checks=1;
#enable foreign key check to avoid possible referential integrity violation
use project;
insert into tblIPRType(`IPRType`)
values('License'),
('Patent'),
('Copyright'),
('Trademarks'),
('Trade Dress'),
('Trade Secret'),
('Industrial Design Rights');
#(Intellectual property, n. d.)
insert into tblCountry()
values(86,'CN','China'),
(61,'AU','Australia'),
(1,'US','United States');
#(List of country calling codes, n. d.)
#the following uses a stored procedure and calls it for inserting records into the tblDate table automatically
delimiter $$
#redefine the default delimiter ";" to "$$" temporarily to pass the ";" inside the body function to the SQL server (Ahsan, 2010)
drop procedure if exists InsertDate$$
create procedure InsertDate()
#"()" is necessary
begin
#"begin" and "end" is a pair of keywords
	declare i int;
#declare the variable
	set i=1;
#initialize the value as 1
	while i <=31 do
	insert into tblDate(`DateNumber`)
	values(i);
#the primary key column increments automatically
	set i=i+1;
#loop continues until i > 31
	end while;
end $$
#ending definition of routine using newly defined delimiter
delimiter ;
#redefine the delimiter to default
call InsertDate();
#call the routine to run
insert into tblMonth(`MonthName`)
values('January'),
('February'),
('March'),
('April'),
('May'),
('June'),
('July'),
('August'),
('September'),
('October'),
('November'),
('December');
#use the routine again to insert values into tblYear
delimiter $$
drop procedure if exists InserYear$$
create procedure InsertYear()
begin
	declare i int;
	set i=1998;
#company started from 1998
	while i <=2020 do
	insert into tblYear(`YearNumber`)
	values(i);
	set i=i+1;
	end while;
end$$
delimiter ;
call InsertYear();
insert into tblGenre(`GenreName`,`GenreDescription`)
values('RPG',"Role Play Game lets the player play someone to venture and increase its level"),
('Action',"Video game lets the player play someone to venture featuring the actions in fight or overcoming obstacles"),
('Shoot',"Shoot game visualizes the real battle onto the screen and lets the player to shoot by pointing its cursor"),
('Tactical',"Tactical game let the player play the role of a commander to deploy its army or construct its power in order to win");
insert into tblAgeGroup(`MinimumAge`,`MaximumAge`,`GroupDescription`)
values(9,11,'Junior middle school students'),
(12,18,'The teenagers');
insert into tblGender(`GenderName`)
values('Male'),
('Female');
insert into tblStage(`StageName`,`StageDescription`)
values('First Stage','Design team develops a new game'),
('Second Stage','Program team writes and tests the code on different platforms'),
('Third Stage','Sales and marketing team promote the product via media outlets'),
('Fourth Stage','Production team outsources the product for mass production');
insert into tblMediaOutlet(`MediaType`,`MediaDescription`)
values('TV','Advertise the game on TV program or advertisement'),
('Internet','Introduce the game on websites'),
('Billboard','Advertise the game on billboards alongside the streets');
insert into tblDepartment(`DepartmentName`,`DepartmentDescription`)
values('Human Resource','Managing matters concerning the employees'),
('Sales','Responsible for products sold to retailers'),
('Marketing','Responsible for advertising the product'),
('Design','Responsible for designing new games'),
('Program','Responsible for coding and testing'),
('Production','Responsible for designing and producing the game');
insert into tblPosition(`PositionTitle`,`PositionDescription`,`DepartmentID`)
values('HR Manager','GM of HR',1),
('Salesperson','Sales representative',2),
('Sales Manager','Manager of sales',2),
('Host','Marketing host',3),
('Marketing Manager','Manager of marketing',3),
('Designer','Designs the game',4),
('Programmer','Codes and tests the game',4),
('Outsourcer','Outsources the game',4),
('Production Manager','Manager of production',4);
insert into tblState(`StateName`,`StateAcronym`,`CountryCode`)
values('West Australia','WA',61),
('New South Wales','NSW',61),
('Guangdong Province','GD',86),
('Macao S.A.R.','MO',86),
('Califonia','CA',1),
('HongKong S.A.R.','HK',86);
insert into tblCity(`CityName`,`StateID`)
values('Perth',1),
('Sydney',2),
('Melbourne',2),
('Guangzhou',3),
('Shunde',3),
('Macao',4),
('Los Angles',5),
('Hongkong',6);
insert into tblSuburb()
values(6060,'Yokine',1),
(6054,'Maddington',1),
(2176,'Abbotsbury',2),
(2093,'Balgowlah',2),
(3196,'Edithvale',3),
(3194,'Mentone',3),
(511400,'Panyu precinct',4),
(510000,'Haizhu precinct',4),
(528329,"Jun'an town",5),
(528311,'Beijiao town',5),
(999078,'Macao',6),
(91331,'Arleta',7),
(999077,'Hongkong',8);
Set foreign_key_checks=0;
#necessary because the Employee table references its primary key which may be inserted later
insert into tblEmployee (`EmployeeName`,`EmployeeAge`,`EmployeeAddress`,`PostCode`,`ManagerID`,`PositionID`)
values('Man Fu Lei',29,'301 Cape Street',6060,null,1),
('Isaac Khoza',23,'15 Burslem Drive',6054,3,2),
('Ugyne Dema',28,'34 Pingston Street',2176,5,4),
('Yurou Tang',19,'64 Xianjian Avenue',2093,9,6),
('Weiwei Zhang',30,'33 Tongling Road',3196,9,7),
('Yun Ma',46,'26 Aliyun Street',3194,9,8),
('Huateng Ma',55,'16 Qkill Road',6060,1,3),
('Hongwei Zhou',39,'360 Court Avenue',6054,1,5),
('Jacky Cheng',61,'16 House Street',2176,1,9);
Set foreign_key_checks=1;
insert into tblSupplier(`SupplierName`,`SupplierAddress`,`SupplierContact`,`PostCode`)
values('AcmeGame','19 Waneroo Road','37563456',6060),
#The first one is the in-house record if IPR isn't a license it must be chosen
('Ubisoft','17 Montreal Street','15344822671',528329),
('Blizzard','19 America Avenue','28455301',999078),
('Softstar','23 Beijing Road','13802689261',510000),
('Mamamia','999 Helpme Avenue','13709394',91331),
('Kingsoft','11 Jinshan Street','92283317',2093);
insert into tblDistribution
(`DistributionName`,`DistributionAddress`,`DistributionContact`,`PostCode`)
values('Warehouse-Perth','17 Flinders Street','92273212',6060),
('Warehouse-Sydney','19 Chedan Avenue','51677899',2176),
('Warehouse-Melbourne','20 Ono Road','13709333',3196);
insert into tblCustomer
(`CustomerName`,`CustomerContact`,`CustomerAddress`,`PostCode`)
values('Coles','93795013','17 Bumbum Avenue',2176),
('Woolwirth','87391471','29 Feihua Street',3194),
('Super L','98765431','155 Rolling Road',2093),
('The Good Guys','12345678','333 Beckam Street',6054),
('Dick Smith','23456234','44 Wiki Street',2093);
insert into tblCustomerBusiness()
values(12345678901,1),
('98765432109',2),
('34537563857',3),
('37532789079',4),
('93749878978',5);
insert into tblManufacture
(`ManufactureName`,`ManufactureContact`,`ManufactureAddress`,`PostCode`)
values('Tianhe Game Ltd.','86756742','33 Dongdong Street',510000),
('Wanghan Hardware','485677959','23 Jiuming Avenue',511400),
('Dongsheng Moto Ltd.','1256857622','33 Gogo Road',528329),
('Aidele Gameware','6894677922','34 Shangli Village',528311);
insert into tblRetailOutlet
(`OutletName`,`OutletContact`,`OutletAddress`,`PostCode`,`CustomerID`)
values('Coles Dogswamp','98756789','11 Flinders Street',6060,1),
('Dakuaiho','34567865','22 Binghamton Avenue',3196,1),
('Nufaconguan','67586749','33 Pinlanch Street',6054,2),
('Xiaoyuxie','67857498','44 Taiwangyan Road',2093,3),
('Yangtian','64542718','55 Changxiao Street',2176,4),
('Zhuanghuai','77685432','67 Jily Avenue',3194,5);
insert into tblSalesInvoice
(`InvoiceTime`,`CustomerID`,`EmployeeID`,`DateID`,`MonthID`,`YearID`)
values('14:25:22',1,2,31,3,2),
('15:33:24',1,2,5,4,2),
('11:30:23',2,2,6,5,2),
('15:44:43',3,7,15,8,3),
('14:33:22',4,7,11,9,3),
('16:44:33',5,2,24,9,11),
('11:22:33',3,2,18,2,17),
('13:44:55',2,2,3,3,15);
insert into tblIPR
(`YearID`,`DateID`,`MonthID`,`CountryCode`,`IPRTypeID`,`SupplierID`)
values(23,31,12,86,1,3),
(22,31,9,61,2,1),
(21,1,1,1,3,1),
(22,1,1,61,1,5),
(21,31,9,86,7,1),
(22,4,4,86,3,1),
(20,9,9,1,1,4),
(21,11,11,61,2,1),
(22,29,12,1,1,2),
(23,10,9,61,4,1),
(22,12,12,86,2,1),
(21,11,12,61,7,1);
insert into tblInventory
(`ProductISBN`,`ProductName`,`ProductDescription`,`ProductPrice`,`ProductQuantity`,`RetailPrice`,`LicenseFee`,`DistributionID`,`GenreID`,`IPRID`)
values('349436-446-345345',"Assasin's creed",'Player acting as an assasin completes missions and kills enemies',12.10,111,44.99,56748,3,2,1),
('868956-345-473978','The Frozen Throne',"Player produces and controls its soldiers to defeat the enemy's army",3.20,222,15.99,null,2,4,2),
('939572-473-397543','Prince of Persia','Player acting as the prince to jump over obstacles and kill the enemies with the power of rewinding',11.10,333,19.99,null,1,2,3),
('359349-347-237494','Legend of Paladin V','Player controls the team of main actors to venture and gain experience by killing monsters',14.20,444,39.99,34579,2,1,4),
('320599-309-389475','Call of Duty','Player controls the cursor to shoot the enemies',18.20,333,38.99,null,3,3,5),
('349887-475-497500','Bio Hazard','Player controls the main actress to venture and shoot the zombies',13.20,222,29.99,null,2,3,6),
('394739-375-374993','Xuanyuan Sword III','Player controls the team of main actors to venture and experience the sensitive story of their legend',14.20,111,34.99,13479,1,1,7),
('390759-374-973498','Amazing Spiderman','Player controls the spiderman to defeat the criminals using his abilities',35.10,222,76.99,null,2,2,8),
('973495-934-359407','Diablo II','Player chooses the career and gains experience by killing monsters',14.10,333,34.99,4956,3,1,9),
('934754-984-397459','Age of Empire II','Player chooses a race and develops its own army until defeating others',13.10,222,29.99,null,2,4,10);
insert into tblSalesItem(`ItemQuantity`,`ProductISBN`,`InvoiceID`)
values(55,'934754-984-397459',1),
(46,'973495-934-359407',2),
(101,'349887-475-497500',3),
(49,'868956-345-473978',3),
(155,'394739-375-374993',4),
(222,'939572-473-397543',5),
(211,'359349-347-237494',5),
(177,'349887-475-497500',6),
(155,'390759-374-973498',7),
(78,'320599-309-389475',8),
(67,'934754-984-397459',8);
insert into tblGamePlayed
(`ProductISBN`,`AgeGroupID`,`GenderID`)
values('320599-309-389475',2,1),
('349436-446-345345',2,1),
('349887-475-497500',2,1),
('359349-347-237494',2,1),
('359349-347-237494',2,2),
('390759-374-973498',1,1),
('390759-374-973498',2,1),
('394739-375-374993',2,1),
('394739-375-374993',2,2),
('868956-345-473978',2,1),
('934754-984-397459',2,1),
('939572-473-397543',1,1),
('939572-473-397543',2,1),
('973495-934-359407',2,1),
('973495-934-359407',2,2);
insert into tblOutsourcingInvoice
(`EmployeeID`,`ManufactureID`,`MonthID`,`DateID`,`YearID`)
values(6,2,8,14,15),
(6,3,7,19,16);
insert into tblProduction
(`ProductName`,`ProductDescription`,`CompletedPercentage`,`PlannedDays`,`EmployeeID`,`YearID`,`DateID`,`MonthID`,`GenreID`,`IPRID`,`StageID`)
values('Tomb raider','An actress ventures to different ancient tombs to discover the treasuries',null,300,null,14,19,9,2,11,4),
('Virus company','A tactical game using strategies to propogate the virus to the world',null,108,null,15,23,7,4,12,4),
('Counter Strike','A shoot game where players play two teams to defeat each other',0.3,111,null,16,3,3,3,null,3),
('Plants VS zombies','A tactical lovely game using plants to defeat zombies',0.5,222,null,17,1,1,4,null,3),
('Devil May Cry','An action game controlling the main actor to kill monsters',0.7,94,5,17,9,9,2,null,2),
('Sanguo wushuang','an action game where player kills enemies in the battle field using skills',0.2,120,4,17,16,8,2,null,1);
insert into tblPromotionEvent
(`PromotionCost`,`Duration`,`EmployeeID`,`ProductID`,`YearID`,`DateID`,`MonthID`,`MediaOutletID`)
values(234589.35,30,3,3,16,15,5,1),
(34758.65,60,8,3,16,15,8,2),
(394759.45,120,3,4,17,3,2,3),
(89380.10,60,8,4,17,7,7,1);
insert into tblOutsourcedProduct
(`CompletedPercentage`,`OutsourcingCost`,`Quantity`,`ProductID`,`InvoiceID`,`DateID`,`MonthID`,`YearID`)
values(1.0,348975.35,300,1,1,14,9,16),
(1.0,239845.65,400,2,1,14,11,16),
(0.4,308432.25,500,1,2,19,5,18),
(0.6,394598.55,400,2,2,19,3,18);
insert into tblGameTested
(`ProductID`,`AgeGroupID`,`GenderID`)
values(1,1,1),
(1,2,1),
(2,2,1),
(2,2,2),
(3,2,1),
(4,1,1),
(4,1,2),
(4,2,1),
(4,2,2),
(5,2,1),
(6,1,1),
(6,2,1);
