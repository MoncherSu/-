create database real_estate_agency_Ismagilova_Is2314
go 
use real_estate_agency_Ismagilova_Is2314
go

create table City(
City_Id int IDENTITY(1,1) constraint PK_CityId_City Primary key,
City_Name nvarchar(30)
CONSTRAINT UQ_City_Name UNIQUE (City_Name)
)

create table Address(
Address_Id int IDENTITY(1,1) constraint PK_AddressId_Address Primary key,
Address nvarchar(30),
Home_number int,
City int constraint FK_City_to_Adress Foreign key (City) References City(City_Id) on delete cascade,
CONSTRAINT UQ_Address_Unique UNIQUE (Address, City)
)

create table Agents_Specialization(
Spec_Id int IDENTITY(1,1) constraint PK_Spec_Id Primary key,
Specialization nvarchar(30))

create table Agents(
Agent_Id int IDENTITY(1,1) constraint PK_Agent_Id Primary key,
Last_Name nvarchar(30),
First_Name nvarchar(30),
Middle_Name nvarchar(30),
Oklad int constraint CK_Oklad_Employee Check(Oklad>=22440), 
Nadbavka int,
Phone nvarchar(10) constraint UQ_Agents_Phone Unique not null,
Email nvarchar(30) constraint UQ_Agents_Email Unique not null,
Spec int,
constraint FK_Agents_To_Spec Foreign key(Spec) references Agents_Specialization(Spec_Id))

Create table Klient(
Klient_Id int IDENTITY(1,1) constraint PK_Klient_Id Primary key,
Last_Name nvarchar(30),
First_Name nvarchar(30),
Middle_Name nvarchar(30),
BirthDay Date,
Phone nvarchar(10),
Email nvarchar(30),
Agent int,
CONSTRAINT UQ_Klient_Phone_Email UNIQUE (Phone, Email),
CONSTRAINT FK_Klient_To_Agent foreign key (Agent) references Agents(Agent_Id) on delete set null,
CONSTRAINT CK_Klient_Age CHECK (BirthDay <= DATEADD(year, -18, GETDATE()))
)

create table Klient_Seller(
Klient_Seller_ID int IDENTITY(1,1) constraint PK_Klient_Seller_Id Primary key,
Klient_Id int,
Min_Summ int,
constraint FK_Seller_To_klient foreign key(Klient_Id) references Klient(Klient_Id) on delete cascade)

create table Klient_Buyer(
Klient_Buyer_ID int IDENTITY(1,1) constraint PK_Klient_Buyer_Id Primary key,
Klient_Id int,
Klient_wish nvarchar(60),
constraint FK_Buyer_To_klient foreign key(Klient_Id) references Klient(Klient_Id) on delete cascade)

create table Object_Type(
Type_Id int IDENTITY(1,1) constraint PK_TypeId_ObjectType Primary key,
Type_name nvarchar(30),
CONSTRAINT UQ_Type_name UNIQUE (Type_name))

create table Object_Status(
Object_Status_Id int IDENTITY(1,1) constraint PK_Object_Status_Id Primary key,
Object_Stat nvarchar(30),
CONSTRAINT UQ_Object_Status_Unique UNIQUE (Object_Stat))

create table Object_Condition(
Object_Condition_Id int IDENTITY(1,1) constraint PK_ObjectConditionId_Condition Primary key,
Object_Condition nvarchar(30),
CONSTRAINT UQ_ObjectCondition_Unique UNIQUE (Object_Condition)
)

create table Object(
Object_Id int IDENTITY(1,1) constraint PK_ObjectId_Object Primary key,
Object_Desc nvarchar(30),
Object_Type int Not NUll,
Square int Not Null,
Floor int,
Num_of_rooms int,
Status int not null,
Adress int Not null,
Condition int,
Seller_Id int,
constraint FK_Object_to_ObjecType Foreign Key (Object_Type) References Object_Type(Type_Id),
constraint FK_Object_to_Status Foreign Key(Status) References Object_Status(Object_Status_Id),
constraint FK_Object_To_Condition Foreign Key(Condition) References Object_Condition(Object_Condition_Id),
constraint FK_Object_To_Adress Foreign Key(Adress) References Address(Address_Id),
CONSTRAINT UQ_Object_Desc UNIQUE (Object_Desc),
CONSTRAINT CK_Object_Square_Positive CHECK (Square > 0),
constraint FK_Object_To_Seller foreign key(Seller_Id) references Klient_Seller(Klient_Seller_ID) on delete set null)

create table Deal_Type(
Deal_Type int IDENTITY(1,1) constraint PK_Deal_Type Primary key,
Deal_Spec nvarchar(30)
)

create table Deal_Status(
Status_Id int IDENTITY(1,1) constraint PK_Deal_Stat Primary key,
Status_Sp nvarchar(30)
)

create table Deal(
Deal_Id int IDENTITY(1,1) constraint PK_Deal_Id Primary Key,
Deal_Date Date,
Deal_Type int,
Object int,
Klient_Buyer int,
Deal_Status int,
Value int,
Comiss int constraint DF_Agreement_Comiss DEFAULT(1),
Term date,
CONSTRAINT CK_Agreement_Value_Positive CHECK (Value > 0),
Constraint CK_Agreement_Comiss Check (Comiss >=1 and Comiss <=5),
constraint FK_Deal_To_Object Foreign key(Object) references Object(Object_Id) on delete set null,
constraint FK_Deal_To_Klient_Buyer Foreign key(Klient_Buyer) references Klient_Buyer(Klient_Buyer_Id) on delete set null,
constraint FK_Deal_To_DealStatus Foreign key(Deal_Status) references Deal_Status(Status_Id),
constraint FK_Deal_To_DealType Foreign key(Deal_Type) references Deal_Type(Deal_Type))

Create table Meeting_Status(
Status_Id int IDENTITY(1,1) constraint PK_Meeting_Status Primary key,
Status_Sp nvarchar(30)
)

create table Meeting(
Meeting_Id int IDENTITY(1,1) constraint PK_Meeting_Id Primary key,
DataTime DateTime,
Klient int,
Status int,
constraint FK_Meeting_To_Klient Foreign key(Klient) references Klient(Klient_Id) on delete cascade,
constraint FK_Meeting_To_MeetingStatud foreign key(Status) references Meeting_Status(Status_Id)
)
