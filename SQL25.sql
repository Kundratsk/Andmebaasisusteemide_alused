create database TARge25

--db valimine
use master

--04.03.26
--2 tund

--db kustutamine
drop database TARge25

--tabeli tegemine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male'),
(1, 'Female'),
(3, 'Unknown')

--tabeli sisu vaatamine
select * from Gender

--tehke tabel nimega Person
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'cat@cat.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--soovime näha Person tabeli sisu
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid aj ei ole sisestanud genderId alla väärtust, siis
--see automaatselt sisestab sellele reale väärtuse 3 e mis meil on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email, GenderId)
values (7, 'Flash','f@f.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Plack Panther','p@p.com')

select * from Person

--kustutada DF_Persons_GenderId piirang koodiga
alter table Person
drop constraint DF_Persons_GenderId

--lisame koodiga veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kui sa tead veergude järjekorda peast, 
--siis ei pea neid sisestama
insert into Person 
values (10, 'Green Arrow', 'g@g.com', 2, 154)

--constrainti kustutamine
alter table Person
drop constraint CK_Person_Age

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 130)

-- kustutame rea
delete from Person where Id = 10

--kuidas uuendada andmeid koodiga
--Id 3 uus vanus on 50
update Person
set Age = 50
where Id = 3

--lisame Person tabelisse veeru City ja nvarchar 50
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--k]ik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'
select * from Person where City != 'Gotham'
select * from Person where not City = 'Gotham'

--n'itab teatud vanusega inimesi
--35, 42, 23
select * from Person where Age = 35 or Age = 42 or Age = 23
select * from Person where Age in (35, 42, 23)

--näitab teatud vanusevahemikus olevaid isikuid 22 kuni 39
select * from Person where Age between 22 and 39

--wildcardi kasutamine
--näitab kõik g-tähega algavad linnad
select * from Person where City like 'g%'
--email, kus on @ märk sees
select * from Person where Email like '%@%'

--näitab, kellel on emailis ees ja peale @-märki ainult üks täht ja omakorda .com
select * from Person where Email like '_@_.com'

--kõik, kellel on nimes esimene täht W, A, S
--katusega v'listab
select * from Person where  Name like '[^WAS]%'

select * from Person where  Name like '[WAS]%'

--kes elavad Gothamis ja New Yorkis
select * from Person where City = 'Gotham' or City = 'New York'

--kes elavad Gothamis ja New Yorkis ja on vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

--rida 124
-- 3 tund
--

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime

select * from Person order by Name
--kuvab vastupidises järjestuses nimed

select * from Person order by Name desc
--võtab kolm esimest rida person tabelist
select top 3 * from Person
--kolm esimest, aga tabeli järjestus on Age ja siis Name
select * from Person 
select top 3 Age, Name from Person order by cast(Age as int)

--näita esimesed 50% tabelist

select top 50 percent * from Person 

--kõikide isikute koondvanus
select sum(cast(Age as int)) from Person

--näitab kõige nooremat isikut 
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age veeru int andmetüübiks

alter table Person
alter column Age int

--näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--Kuvab esimeses reas välja toodud järjestuses ja kuvab Age TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab, et mitu rida on selles tabelis
select * from Person
select count(*) from Person

--näutab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnas
--arvutab vanuse kokku konkreetses linnas

select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja 
--kui palju neid igas linnas elab
--eristab soo järgi

select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total person(s)]
from Person
group by GenderId, City having sum(Age) >= 41

--loome tabelid Employees ja Department

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)


insert into Employees(Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

DROP TABLE Employees;


create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

INSERT INTO Department (Id, DepartmentName, Location, DepartmentHead)
VALUES 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella');

--
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutame kõikide palgad kokku

SELECT SUM(cast(Salary as int)) FROM Employees
--miinimum palga saaja
select min(cast(Salary as int)) from Employees

--- rida 251
--- 4 tund
--- 17.03.26
--teeme left join päringu
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location -- ühe kuu palga fond linnade lõikes

--teeme veeru nimega City Employees tabelisse
--nvarchar 30
alter table Employees
add City nvarchar(30)

select * from Employees

--peale selecti tulevad veergude nimed
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
--tabelist nimega Employees ja mis on grupitatud City ja Gender järgi
from Employees group by City, Gender 

--oleks vaja, et linnad oleksid tähestikulises järjekorras
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees group by City, Gender 
order by City
--order by järjestab linnad tähestikuliselt
--aga kui on nullid, siis need tulevad kõige ette

--loeb ära mitu rida on tabelis Employees
-- * asemele võib panna ka veeru nime,
--aga siis loeb ainult selle veeru väärtused, mis ei ole nullid
select COUNT(*) from Employees

--Mitu töötajat on soo ja linna kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
group by City, Gender

-- kuvab ainult kõik mehed linnade kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
where Gender = 'Male'
group by City, Gender

--sama tulemus, aga kasutage having klauslit
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
group by City, Gender
having Gender = 'Male'

--näitab meile ainult need töötajad, kellel on palga summa üle 4000
select * from Employees 
where sum(cast(Salary as int) > 4000

select Name, City, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
group by Salary, City, Name
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1) primary key,
Value nvarchar(30)
)

insert into Test1 values('x')
select * from Test1

--kustutame veeru nimega City Employees tabelist
 alter table Employees
 drop column City

 --inner join
 --kuvab neid, kellel on DepartmentName all olemas väärtus
 select Name, Gender, Salary, DepartmentName
 from Employees
 inner join Department
 on Employees.DepartmentId = Department.Id

 select * from Employees
 select * from Department

 --left join
 --kuvab kõik read Employees tabelist,
 --aga DepartmentName näitab ainult siis, kui on olemas
 select * from Employees
 left join Department
 on Employees.DepartmentId = Department.Id

 --right join
select * from Employees --vasakpoolne tabel
right join Department --parempoolne tabel
on Employees.DepartmentId = Department.Id
--right join
--kuvab kõik read department tabelist
--aga name näitab ainult siis ui on olemas väärtus DepartmentId-s, mis on sama 
--Department tabeli Id-ga
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id

--full outer join ja full join on sama asi
--kuvab kõik read mõlemast tabelist
--aga kui ei ole vastet, siis näitab nulli

select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id

--cross join
--kuvab kõik read mõlemast tabelist, aga ei võta aluseks mingit veergu,
--vaid lihtsalt kombineerib kõik read omavahel
--kasutatakse harva, aga kui on vaja kombineerida kõiki
--võimalikke kombinatsioone kahe tabeli vahel, siis võib kasutada cross joini
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--päringu sisu
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition

selecct Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Department Id = Employees.DepartmentId

--kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
 from Employees
 left join Department
 on Employees.DepartmentId = Department.Id
 where DepartmentName is null

 select Name, Gender, Salary, DepartmentName
 from Employees
 left join Department
 on Employees.DepartmentId = Department.Id
 where Department.Id is null

 --kuidas saame department tabelis oleva rea, kus on NULL
 select Name, Gender, Salary, DepartmentName
 from Employees
 right join Department
 on Employees.DepartmentId = Department.Id
 where Employees.DepartmentId is null

 --full join
 --kus on vaja kuvada kõik read mõlemast tabelist,
 --millel ei ole vastet
  select Name, Gender, Salary, DepartmentName
 from Employees
 full join Department
 on Employees.DepartmentId = Department.Id
 where Employees.DepartmentId is null
 or Department.Id is null

 --tabeli nimetuse muutmine koodiga
sp_rename 'Employees1', 'Employees'

--kasutame Employees tabeli asemel lühendit E ja M
--aga enne seda lisame uue veeru nimega ManagerId ja see on int
alter table Employees
add ManagerId int

select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--inner join, kasutame lühendeid

select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join, kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M



select FirstName, LastName, Phone, AddressID, AddressType
from SalesLT.CustomerAddress
left join SalesLT.Customer
on SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID

SELECT
	e.EmployeeKey,
	e.FirstName,
	c.SalesAmountQuota,
	c.CalendarYear
from dbo.DimEmployee e
inner join dbo.FactSalesQuota c
	On e.EmployeeKey = c.EmployeeKey ;


	--left join üks veel
Select
	c.SalesterritoryKey,
	c.FirstName,
	e.SalesTerritoryRegion
FROM dbo.DimEmployee c
LEFT JOIN dbo.DimSalesTerritory e
	On c.SalesTerritoryKey = e.SalesTerritoryKey;

	--veel üks right join
SELECT
	c.DateKey,
	c.EndOfDayRate,
	c.AverageRate,
	c.Date,
	e.EnglishDayNameOfWeek
FROM dbo.FactCurrencyRate c
RIGHT JOIN dbo.DimDate e
	ON c.DateKey = e.DateKey






--inner
SELECT 
	c.CustomerKey,
	c.FirstName,
	s.SalesAmount
from dbo.DimCustomer c
inner join dbo.FactInternetSales s
	On c.CustomerKey = s.CustomerKey ;

	--left

Select
	c.CustomerKey,
	c.FirstName,
	s.SalesAmount
FROM dbo.Dimcustomer c
LEFT JOIN dbo.FactInternetSales s
	ON c.CustomerKey = s.CustomerKey;


	--right
SELECT
	c.CustomerKey,
	c.FirstName,
	s.SalesAmount
FROM dbo.Dimcustomer c
RIGHT JOIN dbo.FactInternetSales s
	ON c.CustomerKey = s.Customerkey;

	--outer join


SELECT 
	c.CustomerKey,
	c.FirstName,
	s.SalesAmount
FROM dbo.DimCustomer c
FULL OUTER JOIN dbo.FactInternetSales s
	ON c.CustomerKey = s.CustomerKey;

--cross
SELECT
	c.FirstName,
	p.EnglishProductName
FROM dbo.DimCustomer c
CROSS JOIN dbo.DimProduct p;


create table Students
(
StudentId int primary key,
FirstName nvarchar(50),
LastName nvarchar(50),
Gender nvarchar(30),
City nvarchar(50),
email nvarchar(50)
)

insert into Students(StudentId, FirstName, LastName, Gender, City, email)
values (1, 'Marek', 'Lepp', 'Male', 'Tartu', 'm.l@gmail.com'),
(2, 'Tarmo', 'Tepp', 'Male', 'Põlva', 'T.T@gmail.com'),
(3, 'Marju', 'Palju', 'Female', 'Tartu', 'M.pa@gmail.com'),
(4, 'Mardo', 'Kask', 'Male', 'Tallinn', 'm.K@gmail.com'),
(5, 'Mari', 'Puu', 'Female', 'Tallinn', 'M.puu@gmail.com'),
(6, 'Merle', 'Tamm', 'Female', 'Tartu', 'm.tamm@gmail.com'),
(7, 'Pelle', 'Kastan', 'Female', 'Jõhvi', 'pelle.k@gmail.com'),
(8, 'Mait', 'Poolt', 'Male', 'Tapa', 'mait.p@gmail.com'),
(9, 'Kati', 'Latt', 'Female', 'Narva', 'kati.l@gmail.com'),
(10, 'Taimi', 'Lang', 'Female', 'Haapsalu', 'taimi.l@gmail.com');


