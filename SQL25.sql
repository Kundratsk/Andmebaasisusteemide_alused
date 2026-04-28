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
--10.03.26

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
alter column Age int;

--näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuvab esimeses reas välja toodud järjestuses ja kuvab Age TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab, et mitu rida on selles tabelis
select * from Person
select count(*) from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnas
--arvutab vanuse kokku konkreetses linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja 
--kui palju neid igas linnas elab
--eristab soo järgi
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
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

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

--
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutame kõikide palgad kokku
select sum(cast(Salary as int)) from Employees
--min palga saaja
select min(cast(Salary as int)) from Employees

--- rida 251
--- 4 tund
--- 17.03.26
--teeme left join päringu
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location --ühe kuu palgafond linnade lõikes

--teem veeru nimega City Employees tabelisse
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
--order by järjestab linnad tähesitkuliselt, 
--aga kui on nullid, siis need tulevad kõige ette

-- loeb ära, mitu rida on tabelis Employees
-- * asemele võib panna ka veeru nime,
-- aga siis loeb ainult selle veeru väärtused, mis ei ole nullid
select COUNT(*) from Employees

--mitu töötajat on soo ja linna kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees 
group by City, Gender

--kuvab ainult kõik mehed linnade kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees 
where Gender = 'Female'
group by City, Gender

--sama tulemuse, aga kasutage having klauslit
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees 
group by City, Gender
having Gender = 'Male'

--näitab meile ainult need töötajad, kellel on palga summa üle 4000
select * from Employees
where sum(cast(Salary as int)) > 4000

select City, sum(cast(Salary as int)) as TotalSalary, Name,
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

insert into Test1 values('X')
select * from Test1

--- kustutame veeru nimega City Employees tabelist
alter table Employees
drop column City

-- inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

-- left join
-- kuvab kõik read Employees tabelist, 
-- aga DepartmentName näitab ainult siis, kui on olemas
-- kui DepartmentId on null, siis DepartmentName näitab nulli
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

-- right join
-- kuvab kõik read Department tabelist
-- aga Name näitab ainult siis, kui on olemas väärtus DepartmentId-s, mis on sama 
-- Department tabeli Id-ga
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id

-- full outer join ja full join on sama asi
-- kuvab kõik read mõlemast tabelist, 
-- aga kui ei ole vastet, siis näitab nulli
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id

-- cross join
-- kuvab kõik read mõlemast tabelist, aga ei võta aluseks mingit veergu,
-- vaid lihtsalt kombineerib kõik read omavahel
-- kasutatakse harva, aga kui on vaja kombineerida kõiki 
-- võimalikke kombinatsioone kahe tabeli vahel, siis võib kasutada cross joini
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

-- päringu sisu
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition

select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Department.Id = Employees.DepartmentId

-- kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

-- kuidas saame department tabelis oleva rea, kus on NULL
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

-- kasutame Employees tabeli asemel lühendit E ja M
-- aga enne seda lisame uue veeru nimega ManagerId ja see on int
alter table Employees
add ManagerId int

-- antud juhul E on Employees tabeli lühend ja M 
-- on samuti Employees tabeli lühend, aga me kasutame 
-- seda, et näidata, et see on manageri tabel
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--inner join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M


select FirstName, LastName, Phone, AddressID, AddressType
from SalesLT.CustomerAddress CA
left join SalesLT.Customer C
on CA.CustomerID = C.CustomerID

-- teha päring, kus kasutate ProductModelit ja Product tabelit, 
-- et näha, millised tooted on millise mudeliga seotud

select PM.Name as ProductModel, P.Name as Product
from SalesLT.Product P
left join SalesLT.ProductModel PM
on PM.ProductModelId = P.ProductModelId

--rida 412
--4 tund
--31.03.26
select isnull('Sinu Nimi', 'No Manager') as Manager

select COALESCE(null, 'No Manager') as Manager

--neil kellel ei ole ülemust, siis paneb neile No Manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

-- kui Expression on õige, siis paneb väärtuse, mida soovid või 
--vastasel juhul paneb No Manager teksti
case when Expression Then '' else '' end

--teeme päringu, kus kasutame case-i
-- tuleb kasutada ka left join
select E.Name as Employee, case when M.Name is null then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

--muudame veeru nime koodiga
sp_rename 'Employees.Middlename', 'MiddleName'
select* from Employees

update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

--igast reast võtab esimesena mitte nulli väärtuse ja paneb Name veergu
--kasutada coalesce
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutate union all
--kahe tabeli andmete vaatamiseks
--näitab kõik read mõlemast tabelist
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtuste eemaldamiseks kasutame unionit
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kuidas tulemust sorteerida nime järgi
--kasutada union all-i
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
--salvestatud protseduurid on SQL-i koodid, mis on salvest
--salvestatud andmebaasis ja mida saab käivitada, 
--et teha mingi kindel töö ära
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saame kasutada spGetEmployees-i
spGetEmployees
exec spGetEmployees
execute spGetEmployees

---
create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees 
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--miks saab veateate
spGetEmployeesByGenderAndDepartment
--õige variant
spGetEmployeesByGenderAndDepartment 'female', 1
--kuidas minna sp järjekorrast mööda parameetrite sisestamisel
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

sp_helptext spGetEmployeesByGenderAndDepartment

--muudame sp-d ja võti peale, et keegi teine 
--peale teie ei saaks seda muuta
alter procedure spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
with encryption --paneb võtme peale
as begin
	select FirstName, Gender, DepartmentId from Employees 
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--
create proc spGetEmployeeCountByGender
@Gender nvarchar(10),
--output on parameeter, mis võimaldab meil salvestada protseduuri 
--sees tehtud arvutuse tulemuse ja kasutada seda väljaspool protseduuri
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees 
	where Gender = @Gender
end


--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib tulemuse, mis on parameetris @EmployeeCount
declare @TotalCount int
exec spGetEmployeeCountByGender 'Female', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount

--näitab ära, et mitu rida vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender 
--mis on out?
--out on parameeter, mis võimaldab meil salvestada protseduuri
@EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame, millest sõltub see sp
sp_depends spGetEmployeeCountByGender
--vaatame tabelit sp_depends-ga
sp_depends Employees

---
create proc spGetNameById
@Id int,
@Name nvarchar(30) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--tahame näha kogu tabelite ridade arvu
--count kasutada
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--saame teada, et mitu rida on tabelis
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees

--mis id all on keegi nime järgi
create proc spGetIdByName1
@Id int,
@FirstName nvarchar(30) output
as begin
	select @FirstName = FirstName from Employees where @Id = Id
end

--annab tulemuse, kus id 1 real on keegi koos nimega
declare @FirstName nvarchar(30)
execute spGetIdByName1 9, @FirstName output
print 'Name of the employee = ' + @FirstName

---
declare @FirstName nvarchar(30)
execute spGetNameById 3, @FirstName output
print 'Name of the employee = ' + @FirstName
--ei anna tulemust, sest sp-s on loogika viga
--sp-s on viga, sest @Id on parameeter, 
--mis on mõeldud selleks, et me saaksime sisestada id-d 
--ja saada nime, aga sp-s on loogika viga, sest see 
--üritab määrata @Id väärtuseks Id veeru väärtust, mis on vale

-- rida 662
--tund 5
--07.04.26
declare @FirstName nvarchar(30)
execute spGetNameById 1, @FirstName out
print 'Name of the employee = ' + @FirstName

sp_help spGetNameById

create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

declare @EmployeeName nvarchar(30)
execute @EmployeeName = spGetNameById2 3
print 'Name of the employee = ' + @EmployeeName


--------------------------
alter PROCEDURE spGetNameById2
    @FirstName NVARCHAR(30) OUTPUT,
    @Id INT
AS
BEGIN
    SELECT @FirstName = FirstName
    FROM Employees
    WHERE Id = @Id
END


DECLARE @FirstName NVARCHAR(30)
EXEC spGetNameById2
    @Id = 3,
    @FirstName = @FirstName OUTPUT
PRINT 'Name of the employee = ' + @FirstName
--return annab ainult int tüüpi väärtust, 
--seega ei saa kasutada return-i, et tagastada nime, 
--mis on nvarchar tüüpi

----sisseehitatud string funktsioonid
-- see konverteerib ASCII tähe väärtuse numbriks
select ascii('A')
-- kuvab A-tähe
select char(65)

--prindime kogu tähestiku välja A-st Z-ni
--kasutame while tsüklit
declare @Start int
set @Start = 1
while (@Start <= 122)
begin
	print char(@Start)
	set @Start = @Start + 1
end

--eemaldame tühjad kohad sulgudes
select ltrim('                  Hello')

--tühiukute eemaldamine sõnas
select ltrim(FirstName) as FirstName, MiddleName, LastName
from Employees

select RTRIM('            Hello                  ')

--keerba kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower-ga saan muuta märkide suurust
--reverse funktsioon keerab stringi tagurpidi
select reverse(upper(ltrim(FirstName))) as FirstName, 
MiddleName,LOWER(LastName), rtrim(ltrim(FirstName)) + ' ' +
MiddleName + ' ' + LastName as FullName
from Employees

---left, right, substring
--left võtab stringi vasakult poolt neli esimest tähte
select left('ABCDEF', 4)
--right võtab stringi paremalt poolt neli esimest tähte
select right('ABCDEF', 4)

--kuvab @tähemärgi asetust
select charindex('@', 'sara@aaa.com')

--alates viiendast tähemärgist võtab kaks tähte
select substring('leo@bbb.com', 5, 2)

--- @-m'rgist kuvab kolm tähemärki. Viimase nr saab 
-- määrata pikkust
select substring('leo@bbb.com', charindex('@', 'leo@bbb.com')
+ 1, 3)

---peale @-märki reguleerin tähemärkide pikkuse näitamist
select SUBSTRING('leo@bbb.com', charindex('@', 'leo@bbb.com') + 2,
len('leo@bbb.com') - CHARINDEX('@', 'leo@bbb.com'))

--saame teada domeeninimed emailides
--kasutame Person tabelit ja substringi, len ja charindexi
select SUBSTRING(Email, charindex('@', Email) + 1,
len(Email) - charindex('@', Email)) as DomainName
from Person

select * from Person

alter table Employees
add Email nvarchar(20)

select * from Employees

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

--lisame *-märgi alates teatud kohast
select FirstName, LastName,
	substring(Email, 1, 2) + replicate('*', 5) +
	--peale teist tähemärki paneb viis tärni
	substring(Email, charindex('@', Email), len(Email) 
	- CHARINDEX('@', Email) + 1) as MaskedEmail
	--kuni @-märgini paneb tärnid ja siis jätkab emaili näitamist
	--on dünaamiline, sest kui emaili pikkus on erinev, 
	--siis paneb vastavalt tärne
from Employees

--kolm korda näitab stringis olevat väärtust
select replicate('Hello', 3)

--kuidas sisestada tühikut kahe nime vahele
--kasutada funktsiooni
select space(5)

--võtame tabeli Employees ja kuvame eesnime ja perkonnanime vahele tühikut
select FirstName + space(25) + LastName as FullName from Employees

--PATINDEX
--sama, mis charindex, aga patindex võimaldab kasutada wildcardi
--kasutame tabelit Employees ja leiame kõik read, kus emaili lõpus on aaa.com
select Email, PATINDEX('%@aaa.com', Email) as Position 
from Employees
where PATINDEX('%@aaa.com', Email) > 0
--leiame kõik read, kus emaili lõpus on aaa.com või bbb.com

--asendame emaili lõpus olevat domeeninimed
--.com asemel .net-iga, kasutage replace funktsiooni
select FirstName, LastName, Email,
REPLACE(Email, '.com', '.net') as NewEmail
from Employees

--soovin asendada peale esimest märkki olevad tähed viie tärniga
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

---ajaga seotud andmetüübid
create table DateTest
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTest

--sinu masina kellaaeg
select getdate() as CurrentDateTime

insert into DateTest
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())
select * from DateTest

update DateTest set c_datetimeoffset = '2026-04-07 12:00:05.0566667 +02:00'
where c_datetimeoffset = '2026-04-07 17:13:05.0566667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' --veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aja ja ajavööndi päring
select GETUTCDATE(), 'GETUTCDATE' --UTC aja päring

select isdate('asdasd') --tagastab 0, sest see ei ole kehtiv kuupäev
select isdate(getdate()) --tagastab 1, sest on kp
select isdate('2026-04-07 12:00:05.0566667') --tagastab 0 kuna max kolm komakohta v]ib olla
select isdate('2026-04-07 12:00:05.056') --tagastab 1
select day(getdate()) --annab tänase päeva nr
select day('03/29/2026') --annab stringis oleva kp ja järjestus peab olema õige
select month(getdate()) --annab jooksva kuu nr
select month('03/29/2026') -- annab stringis oleva kuu
select year(getdate()) -- annab jooksva aasta nr
select year('03/29/2026') -- annab stringis oleva aasta nr

--rida 841
--tund 6
--14.04.26

select datename(day, '2026-04-07 12:00:05.056') --annab stringis oleva päeva nime
select datename(weekday, '2026-04-07 12:00:05.056') --annab stringis oleva päeva nime
select datename(month, '2026-04-07 12:00:05.056') -- annab stringis oleva kuu nime

create table EmployeesWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud
select Name, DateOfBirth, Datename(weekday, DateOfBirth) as [Day],
	   MONTH(DateOfBirth) as [Month], 
	   DATENAME(month, DateOfBirth) as [MonthName],
	   YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

select DATEPART(weekday, '2026-04-07 12:00:05.056') -- annab stringis oleva päeva nr, kus 1 on pühapäev
select DATEPART(month, '2026-04-07 12:00:05.056') -- annab stringis oleva kuu nr
select DATENAME(week, '2026-04-07 12:00:05.056')
select dateadd(day, 20, '2026-04-07 12:00:05.056') -- annab stringis oleva kuupäeva, mis on 20 päeva pärast
select dateadd(day, -20, '2026-04-07 12:00:05.056') -- annab stringis oleva kuupäeva, mis on 20 päeva enne
select datediff(month, '04/30/2025', '01/31/2026')
select datediff(year, '04/30/2025', '01/31/2026')

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
	select @tempdate = @DOB

	select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) > month(getdate())) or (month(@DOB))
	= month(getdate()) and day(@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate = dateadd(year, @years, @tempdate)

	select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate = dateadd(month, @months, @tempdate)

	select @days = datediff(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(10)) + ' years, ' 
		+ cast(@months as nvarchar(10)) + ' months, ' 
		+ cast(@days as nvarchar(10)) + ' days old'
	return @Age
end

--saame vanuse välja arvutada, kui kasutame fnComputeAge funktsiooni
select Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age 
from EmployeesWithDates

--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet
--stringis olevaga
select dbo.fnComputeAge('03/23/2008')

--nr peale DOB muutujat näitab, 
--et missugusena järjestuses me tahame näidata veeru sisu
select Id, Name, DateOfBirth,
convert(nvarchar,DateOfBirth, 109) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id]
from EmployeesWithDates

select cast(getdate() as date) --tänane kp
select convert(date, getdate()) --tänane kp

---matemaatilised funktsioonid
select abs(-101.5) --absoluutväärtus, tagastab 101.5
select ceiling(101.5) --tagastab 102, ümardab üles
select CEILING(-101.5) --tagastab -101, ümardab üles positiivsema nr poole
select floor(101.5) --tagastab 101, ümardab alla
select floor(-101.5) --tagastab -102, ümardab alla negatiivsema nr poole 
select power(2, 4) -- 2 astmel 4 e 2x2x2x2, esimene nr on alus
select SQUARE(5) -- tagastab 25, võtab arvu ja korrutab iseendaga
select sqrt(25) --tagastab 5, võtab arvu ja leiab selle ruutjuure

select rand() --tagastab juhusliku arvu vahemikus 0 kuni 1
--oleks vaja, et iga kord annab rand meile ühe täisarvu vahemikus 1 kuni 100
select ceiling (rand() * 100)

--annab juhuslik number vahemikus 1 kuni 1000
--ja teeb seda 10 korda, et näha erinevaid numbreid
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print ceiling (rand() * 1000)
	set @counter = @counter + 1
end

select ROUND(850.556, 2) --ümardab 850.556 kahe komakohani, tagastab 850.56
select ROUND(850.556, 2, 1) --ümardab 850.556 kahe komakohani, 
--aga kui kolmas komakoht on 5 või suurem, siis ümardab alla, 
--tagastab 850.550
select ROUND(850.556, 1) --ümardab 850.556 ühe komakohani, tagastab 850.6
select ROUND(850.556, 1, 1)--ümardab 850.556 ühe komakohani, 
--aga kui kolmas komakoht on 5 või suurem, siis ümardab alla, tagastab 850.5
select ROUND(850.556, -2)--ümardab 850.556 sadade kaupa, tagastab 900
select ROUND(850.556, -1)--ümardab 850.556 kümnete kaupa, tagastab 850

create function dbo.CalculateAge (@DOB date)
returns int
as begin
declare @Age int

set @Age = datediff(year, @DOB, getdate()) -
	case 
		when (month(@DOB) > month(getdate())) or
			 (month(@DOB) = month(getdate()) and day(@DOB) > day(getdate())) 
		then 1 
		else 0
		end
	return @Age
end
-----
execute CalculateAge '10/25/1980'

--arvutab v'lja, kui vana on isik ja v]tab arvesse, 
--kas isiku sünnipäev on juba sel aastal olnud või mitte
--antud juhul näitab, kes on üle 40 aasta vanad
select Id, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 40

---inline table valued functions
--teha EmployeesWithDates tabelisse
--uus veerg nimega DepartmentId int,
-- ja teine veerg on Gender nvarchar(10)

update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 1
update EmployeesWithDates set Gender = 'Female', DepartmentId = 2
where Id = 2
update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 3
update EmployeesWithDates set Gender = 'Female', DepartmentId = 3
where Id = 4
insert into EmployeesWithDates (Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', '1978-11-29 12:59:30.670', 1, 'Male')

select * from EmployeesWithDates

--scalar function e skaleeritav funktsioon annab mingis vahemikus olevaid
--väärtusi, aga inline table valued function tagastab tabeli
--ja seal ei kasutata begin ja endi vahele kirjutamist, 
--vaid lihtsalt kirjutad selecti
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--soovime vaadata kõiki naisi EmployeesWithDates tabelist
select * from fn_EmployeesByGender('Female')

--soovin ainult näha Pam ja kasutan funktsiooni fn_EmployeesByGender
select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--esimene on funktsioon ja teine on Department tabel
select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()


--multi statement table valued function
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, cast(DateOfBirth as date) from EmployeesWithDates

	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas 
--kuna käsitletakse vaatena
--multi statement table valued funktsioonid on nagu tavalised funktsioonid,
--pm on tegemist stored procedurega ja see võib olla aeglasem, 
--sest see ei saa kasutada vaate optimeerimist e kulutab rohkem ressurssi
select * from EmployeesWithDates
update fn_GetEmployees() set Name = 'Sara' where Id = 4 --saab muuta andmeid
select * from EmployeesWithDates
update fn_MS_GetEmployees() set Name = 'Sara' where Id = 4 
--ei saa muuta andmeid multistate table valued funktsioonis, 
--sest see on nagu stored procedure

--rida 1045
--tund 7
--21.04.26

--determnistic vs nondeterministic functions
select count(*) from EmployeesWithDates
--kõik tehtemärgid on deterministic, sest nad annavad alati sama tulemuse, 
--kui sisend on sama. Selle alla kuuluvad veel sum, avg, min, max, count
select square(3)

--mitte ettemääratud funktsioonid võivad anda erinevaid tulemusi
select getdate() --kuna see annab alati jooksva aja, siis on nondeterministic
select CURRENT_TIMESTAMP
select rand()

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(20)
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

--kuidas saab kasutada fn_GetNameById funktsiooni
select dbo.fn_GetNameById(3)
--sellega saab näha funktsiooni sisu
sp_helptext fn_GetNameById

--muuta funktsiooni fn_GetNameById ja krüpteerida see ära, 
--et keegi teine peale sinu ei saaks seda muuta
alter function fn_GetNameById(@id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end
--nüüd kui tahame näha fn_GetNameById funktsiooni sisu, siis ei saa
sp_helptext fn_GetNameById


create function fn_GetEmployeeNameById(@id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end
--tuleb veateade
--Cannot schema bind function 'fn_GetEmployeeNameById' 
--because name 'EmployeesWithDates' is invalid for schema binding. 
--Names must be in two-part format and an object cannot 
--reference itself.

--nüüd on korras variant
create function dbo.fn_GetEmployeeNameById123(@id int)
returns nvarchar(20)
with encryption, schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @id)
end

--mis on schemabinding?
--schemabinding seob päringus oleva tabeli ära ja ei luba seda muuta
--Mis see annab meile?
--see annab meile jõudluse eelise, sest SQL Server teab, et 
--see tabel ei muutu veergude osas

--ei saa tabelit kustutada, kui sellel on schemabindinguga funktsioon
drop table EmployeesWithDates

--temporary tables
--need on tabelid, mis on loodud ajutiselt ja kustutatakse automaatselt
--neid on kahte tüüpi: local temporary tables ja global temporary tables
--#-ga algavad local temporary tables ja 
--##-ga algavad global temporary tables

create table #PersonDetails(Id int, Name nvarchar(20))
--kuhu tabel tekkis?
insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'Max')
insert into #PersonDetails values(3, 'Uhura')
go
select * from #PersonDetails

--saame otsida seda objekti ülesse
select * from sysobjects
where Name like 'dbo.#PersonDetails______________________________________________________________________________________________________000000000007%'


--kustutame tabeli ära
drop table #PersonDetails

--teeme stored procedure, mis loob 
--local temporary table-i ja täidab selle andmetega
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'Max')
insert into #PersonDetails values(3, 'Uhura')

select * from #PersonDetails
end
---
exec spCreateLocalTempTable

select * from sysobjects
where Name like '[dbo].[#A895AD85]%'

---globaalse tabeli loomine
create table ##GlobalPersonDetails(Id int, Name nvarchar(20))
--mis on globaalse ja lokaalse tabeli erinevus?
--globaalse tabeli saab näha ja kasutada kõigis sessioonides,
--lokaalse tabeli saab näha ja kasutada ainult selles sessioonis, 
--kus see on loodud

--index
create table EmployeeWithSalary
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10)
)

insert into EmployeeWithSalary values(1, 'Sam', 2500, 'Male')
insert into EmployeeWithSalary values(2, 'Pam', 6500, 'Female')
insert into EmployeeWithSalary values(3, 'John', 4500, 'Male')
insert into EmployeeWithSalary values(4, 'Sara', 5500, 'Female')
insert into EmployeeWithSalary values(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary


select * from EmployeeWithSalary
where Salary > 4000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on EmployeeWithSalary(Salary desc)

create index IX_Employee_Salary123
on EmployeeWithSalary(Salary)
where Salary > 4000 and Salary < 7000

SELECT *
FROM EmployeeWithSalary WITH (INDEX(IX_Employee_Salary123))
WHERE Salary > 4000 AND Salary < 7000;
--proovige nüüd pärida tabelit EmployeeWithSalary
-- ja kasutada index-t IX_Employee_Salary
select * from EmployeeWithSalary with (index (IX_Employee_Salary))

--indeksi kustutamine
drop index IX_Employee_Salary123 on EmployeeWithSalary
drop index EmployeeWithSalary.IX_Employee_Salary

SET STATISTICS PROFILE ON;

SELECT Name, Salary
FROM EmployeeWithSalary
WHERE Salary > 1000 AND Salary < 5000;

SET STATISTICS PROFILE OFF;
---
SET SHOWPLAN_ALL ON;
go
SELECT Name, Salary
FROM EmployeeWithSalary
WHERE Salary > 1000 AND Salary < 5000;
go
SET SHOWPLAN_ALL OFF;
go


---- indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

-- klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse 
-- ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks
--kui lisad primaarvõtme, siis luuakse automaatselt klastris olev indeks

create table EmployeeCity
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10),
City nvarchar(20)
)

-- andmete õige järjestuse loovad klastris olevad indeksid 
-- ja kasutab selleks Id nr-t
-- põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

SELECT * FROM EmployeeCity

-- klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis 
-- ja seda saab klastrite puhul olla ainult üks
CREATE clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--- annab veateate, et tabelis saab olla ainult üks klastris olev indeks
--- kui soovid, uut indeksit luua, siis kustuta olemasolev

--- saame luua ainult ühe klastris oleva indeksi tabeli peale
--- klastris olev indeks on analoogne telefoni nr-le
--- enne seda päringut kustutasime primaarvõtme indeksi ära
SELECT * FROM EmployeeCity

--mitte klastris olev indeks
create nonclustered index IX_EmployeeCity_Name123
on EmployeeCity(Name)

exec sp_helpindex EmployeeCity

SELECT * FROM EmployeeCity

--- erinevused kahe indeksi vahel
--- 1. ainult üks klastris olev indeks saab olla tabeli peale, 
--- mitte-klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab 
--- tagasi viitama tabelile
--- Juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks määratleb ära tabeli ridade slavestusjärjestuse
--- ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indeksid on 
--- salvestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(25),
	LastName nvarchar(25),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(20)
)

exec sp_helpindex EmployeeFirstName

--sisestame andmed tabelisse ja neid ei saa sisestada
insert into EmployeeFirstName 
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(1, 'John', 'Menco', 2500, 'Male', 'London')

--kustutame indeksi ära
drop index EmployeeFirstName.PK__Employee__3214EC078089B561
--- kui käivitad ülevalpool oleva koodi, siis tuleb veateade
--- et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste unikaalsust ja primaarvõtit
--- koodiga Unikaalseid Indekseid ei saa kustutada, aga käsitsi saab

insert into EmployeeFirstName 
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(1, 'John', 'Menco', 2500, 'Male', 'London')

create unique nonclustered index IX_Employee_FirstName_FirstName
on EmployeeFirstName(FirstName, LastName)

insert into EmployeeFirstName 
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(2, 'John', 'Menco', 2500, 'Male', 'London')
-- alguses annab veateate, et Mike Sandoz-st on kaks korda
-- ei saa lisada mitte-klastris olevat indeksit, kui ei ole unikaalseid andmeid
--- kustutame tabeli ja sisestame andmed uuesti

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(25),
	LastName nvarchar(25),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(20)
)

insert into EmployeeFirstName 
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(2, 'John', 'Menco', 2500, 'Male', 'London')

--lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_Employee_FirstName_City
unique nonclustered(City)

insert into EmployeeFirstName 
values
(3, 'John', 'Menco', 4500, 'Male', 'London')


--tund 8
--28.04.26



--1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi,
--samas unikaalne piirang
--loob unikaalse mitte-klastris oleva indeksi
--2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse
--tabelisse, kui tabel
--juba sisaldab väärtusi võtmeveerus
--3. Vaikimisi korduvaid väärtusied ei ole veerus lubatud,
--kui peaks olema unikaalne indeks või piirang. Nt, kui tahad
--sisestada 10 rida andmeid,
--millest 5 sisaldavad korduviad andmeid, siis kõik 10 lükatakse tagasi.
--Kui soovin ainult 5
--rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis
--selleks kasutatakse IGNORE_DUP_KEY

--koodinäide
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

select * from EmployeeFirstName

insert into EmployeeFirstName 
values
(3, 'John', 'Menco', 2345, 'Male', 'London'),
(4, 'John', 'Menco', 1234, 'Male', 'London1'),
(4, 'John', 'Menco', 3456, 'Male', 'London1')

--enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

--view on salvestatud SQL-i päring. Saab käsitleda ka virtuaalse tabelina

select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--loome view
create view vEmployeesByDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--view pärngu kutsumine
select * from vEmployeesByDepartment

--teeme view, kus näeb ainult IT-töötajaid
--view nimi on vITEmployeesinDepartment

create view vITEmployeesinDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where DepartmentName = 'IT';

select * from vITEmployeesinDepartment

--veeru taseme turvalisus
--peale selecti määratled veergude näitamise ära
create view vEmployeeInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeeInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid

CREATE VIEW vEmployeesCountByDepartment
AS
select DepartmentName, COUNT(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment
--muutmiseks kasutame sõna alter
alter view vEmployeesCountByDepartment
....
--kustutamine drop
drop view

--kasutame view-d andmete sisestamiseks
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

--muutke Id 2 olev rida ja uus eesnimi on Tom

update vEmployeesDataExceptSalary
set [FirstName] = 'Pam' where Id = 2

select * from vEmployeesDataExceptSalary

--kustutame ja sisestame andmeid 
delete from vEmployeesDataExceptSalary where Id = 2

--lisame andmeid

delete from vEmployeesDataExceptSalary where Id = 2
insert into vEmployeesDataExceptSalary (Id, Genderm DepartmentId, FirstName)
values(2, 'Female', 2, 'Pam')

--indekseeritud view
--ms sql on indekseeritud view nime all
--oracles-s on materjaliseeritud view

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product values
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

create table ProductSales
(
Id int, 
QuantitySold int
)

insert into ProductSales values
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)


--loome view, mis annab meile veerud TotalSales ja TotalTransaction
create view vTotalSalesByProduct
WITH schemabinding
as
select Name,
SUM(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

select * from vTotalSalesByProduct

---kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
--1. view tuleb luua koos schemabinding-ga
--2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks
--võib olla NULL, siis asendusväärtus peaks olema täpsustatud.
--Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
--3. kui GroupBy on täpsustatud, siis view select list peab
--sisaldama COUNT_BIG(*) väljendit
--4. Baastabelis peaksid view-d olema viidatud kahesosalie nimega
--e antud juhul dbo. Product ja dbo. ProductSales.
--mis erinevus on count_big ja count-i vahel?
--count_big saab tagastada suuremaid väärtuseid 

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)

--paneb view tähtestiku järjekorda
select * from vTotalSalesByProduct

--view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender

--vaatesse ei saa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

select * from fnEmployeeDetails('Male')

--order by kasutamine
--order by-d ei saa kasutada view sees
create view vEmployeeDetailsSorted
as
select Id, FirstName, Gender, DepartmentId
from Employees
order by Id

--temp table kasutamine
create table ##TestTempTable
(Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values
(101, 'Martin', 'Male'),
(102, 'Joe', 'Male'),
(103, 'Pam', 'Female'),
(104, 'James', 'Male')

--view, mis kasutab ##TestTempTable
--View nimi on vOnTempTable
--temp tabelis ei saa kasutada view-d
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable

--triggerid

--DML trigger
-- kokku on kolme tüüpi: DML DDL Ja LOGON

--trigger on stored procedure eriliik, mis automaatselt käivitub,
--kui mingi tegevus
--peaks andmebaasis aset leidma

--DML data manipulation language
--DML-i põhilised käsklused: insert, update ja delete

--DML triggereid saab klassifitseerida kahte tüüpi:
--1. After trigger (kutsutakse ka FOR triggeriks)
--2. Instead of trigger (selmet trigger e selle asemel trigger)

---after trigger käivitub peale sündmust, kui kuskil on
--- tehtud insert, update ja delete

create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

--peale iga töötaja sisestamist tahame teada saada töötaja Id-d,
--päeva ning aega(millal sisestati)
--kõik andmed tulevad EmployeeAudit tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New employee with Id = ' + CAST(@Id as nvarchar(5)) + ' is added at '
+ cast(getdate() as nvarchar(20)))
end

select * from Employees
insert into Employees values
(11, 'Blob','Bob', 'Bomb','Male', 3000, 1, 3, 'bob@bob.com')

select * from EmployeeAudit

create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id = ' + CAST(@Id as nvarchar(5)) +
	' is deleted at ' + CAST(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11

select * from EmployeeAudit

--update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin 
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldLastName 
