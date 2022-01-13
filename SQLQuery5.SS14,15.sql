--SS14
--1
use AdventureWorks2019
go
declare @TranName varchar(30);
select @TranName='FirstTransaction';
begin TRANSACTION @TranName;
delete from HumanResources.JobCandidate where JobCandidateID=13;
--2
Begin TRANSACTION
go
delete from HumanResources.JobCandidate where JobCandidateID=11
go
commit TRANSACTION;
go
--3
begin transaction deleteCandidate
with mark N'Deleting a Job Candidate';
go
delete from HumanResources.JobCandidate where JobCandidateID=11;
go
commit transaction deleteCandidate;
--4
use Sterling;
go
create table ValueTable ([value] char)
go
--5
begin transaction
insert into ValueTable values('A');
insert into ValueTable values('B');
go
ROLLBACK TRANSACTION
insert into ValueTable values('C');
select [value] from ValueTable;
--6
create procedure SAVETRANExample @InputCandidateID int
as
declare @TranCounter int;
set @TranCounter=@@TRANCOUNT; if @TranCounter>0
save transaction ProcedureSave;
else
begin transaction;
delete HumanResources.JobCandidate
where JobCandidateID = @InputCandidateID; if @TranCounter=0
commit transaction;
if @TranCounter=1
rollback transaction procedureSave;
go
--7
print @@Trancount begin tran
print @@Trancount begin tran
print @@Trancount commit
print @@Trancount commit
print @@Trancount
--8
print @@Trancount begin tran
print @@Trancount begin tran
print @@Trancount 
rollback
print @@Trancount
--9
use AdventureWorks2019
go
begin transaction ListPriceUpdate
with mark 'update product list prices';
go
update Production.Product
set ListPrice=ListPrice*1.20 where ProductNumber like 'BK-%';
go
commit transaction ListPriceUpdate;
go

--SS15
--1
Begin try
declare @num int;
select @num=217/0;
end try
begin catch
print 'Error occurred, unable to divide by 0'
end catch;
--2
use AdventureWorks2019
go
begin try
select 217/0;
end try 
begin catch
select
ERROR_NUMBER() as ErrorNumber, ERROR_SEVERITY() as ErrorSeverity,ERROR_LINE()
as errorLine,ERROR_MESSAGE() as errorMessage;
end catch;
go
--3
use AdventureWorks2019
go
if object_ID ('sp_ErrorInfo','p') is not null
drop procedure sp_ErrorInfo;
go
create procedure sp_ErrorInfo
as
ERROR_NUMBER() AS ErrorNumber,
ERROR_SEVERITY() AS ErrorSeverity,
ERROR_STATE() AS ErrorState,
ERROR_PROCEDURE() AS ErrorProcedure,
ERROR_LINE() AS ErrorLine,
go
begin try select 217/0;
end try
begin catch
execute sp_ErrorInfo;
end catch;
--4
use AdventureWorks2019
go
begin transaction;
begin try
delete from Production.Product where ProductID=980;
end try
begin catch
select
ERROR_SEVERITY() as errorSeverity,
ERROR_NUMBER() as errorNumber,
ERROR_PROCEDURE() as errorProcedure,
ERROR_STATE() as errorState,
ERROR_MESSAGE() as errorMessage,
ERROR_LINE() as errorLine;
if @@TRANCOUNT>0 rollback transaction;
end catch;
if @@TRANCOUNT>0 commit transaction;
go
--5 
use AdventureWorks2019
go 
begin try
update HumanResources.EmployeePayHistory set PayFrequency = 4 
where BusinessEntityID=1;
end try
begin catch
if @@ERROR = 547
print N'Check constraint violation has occurred.';
end catch
--6
raiserror (N'This is an error message %s %d.', 10, 1, N'serial number', 23);
go
--7
raiserror (N'%*.*s',10,1,7,3,N'HelloWorld');
go
raiserror (N'%7.3s',10,1,N'HelloWorld');
go
--8
begin try
raiserror('Raises Error in the TRY block.',16,1);
end try
begin catch
declare @ErrorMessage nvarchar(4000); declare @ErrorServerity int;
declare @ErrorState int; 
select @ErrorMessage=ERROR_MESSAGE(),
@ErrorServerity=ERROR_SEVERITY(),
@ErrorState=ERROR_STATE();
raiserror (@ErrorMessage,@ErrorServerity,@ErrorState);
end catch;
--9
begin try select 217/0;
end try begin catch
select ERROR_STATE() as ErrorState;
end catch;
go
--10
begin try
select 217/0;
end try
begin catch
select ERROR_SEVERITY() as errorSeverity;
end catch;
go
--11
use AdventureWorks2019
go
if OBJECT_ID('usp_Example','p') is not null
drop procedure usp_Example;
go
create procedure usp_Example AS
select 217/0;
go
begin try
execute usp_Example;
end try
begin catch
select ERROR_PROCEDURE() as errorProcedure;
end Catch;
go
--12
use AdventureWorks2019
go
if OBJECT_ID('usp_example','P') is not null
drop procedure usp_Example;
go
create procedure usp_example as
select 217/0;
go
begin try
execute usp_example
end try
begin catch select
ERROR_NUMBER() as errorNumber, ERROR_SEVERITY() as errorSeverrity, ERROR_STATE() errorState
end catch;
go
--13
begin try
select 217/0;
end try
begin catch
select ERROR_NUMBER() as ErrorNumber;
end catch
go
--14
begin try
select 217/0
end try
begin catch
select ERROR_MESSAGE() as ErrorMessage;
end catch
go
--15
begin try
select 217/0
end try
begin catch 
select ERROR_LINE() as errorLine;
end catch;
go
--16
use AdventureWorks2019
go 
begin try
select*from nonexistent;
end try
begin catch
select
ERROR_NUMBER() as errorNumber,
ERROR_MESSAGE() as errorMessage;
end catch
--17
if OBJECT_ID(N'sp_Example',N'P') is not null
drop procedure sp_Example;
go
create procedure sp_Example AS
select*from Nonexistent;
go
begin try
execute sp_Example;
end try
begin catch select 
ERROR_NUMBER() as ErrorNumber,
ERROR_MESSAGE() as ErrorMessage;
end Catch;
--18
use tempdb;
go
create table dbo.TestRethrow
(ID int primary key);
begin try
insert dbo.TestRethrow(ID) values(1);
insert dbo.TestRethrow(ID) values(1);
end try
begin catch
print'In catch block.';
throw;
end catch;

