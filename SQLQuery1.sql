create database BlogDB

--1)-
create table Categories(
CategoryId int identity(1,1) primary key,
CategoryName nvarchar(20) not null unique,
)
--2)-
create table Tags(
TagId int identity(1,1) primary key,
TagName nvarchar(20) not null,
)
--3)-
create table Comments(
CommentId int identity(1,1) primary key,
CommentContent nvarchar(250) not null,
CommentUserId int references Users(UserId),
CommentBlogId int references Blogs(BlogId),
)
--4)-
create table Users(
UserId int identity(1,1) primary key,
UserName nvarchar(20) not null unique,
UserFullname nvarchar(20)not null,
UserAge int check(UserAge between 0 and 150)
)
--5)-
create table Blogs(
BlogId int identity(1,1) primary key,
BlogTitle nvarchar(50) not null check (len(BlogTitle) between 1 and 50),
BlogDescription nvarchar(350) not null,
BlogCategoryId int references Categories(CategoryId),------- one to many
BlogUserId int references Users(UserId)
)
--6)-
create table BlogTag(                         -------many to many
BlogTagId int identity(1,1) primary key,
TagBlogId int references Blogs(BlogId),
TAGtagId int references Tags(TagId),
)

--1)
select  Blogs.BlogTitle,Users.UserName ,Users.UserFullname from Blogs
join Users on Blogs.BlogUserId = Users.UserId

--2)
select Blogs.BlogTitle,Categories.CategoryName from Blogs
join Categories on BlogCategoryId=Categories.CategoryId

--3) 
create procedure usp_UserComment @UserId int
as
select Comments.CommentContent from Comments
    where Comments.CommentUserId = @UserId;

exec usp_UserComment @UserId=1

--4)
create procedure usp_UserBlog @userId int
as
select Blogs.BlogTitle from Blogs
where Blogs.BlogUserId=@userId

exec usp_UserBlog @userId=1

--5) 

create function usp_BlogsCategory (@categoryId int)
returns int
as
begin
    declare @Blogcount int
    select @Blogcount=count(*) from Blogs 
	where Blogs.BlogCategoryId = @categoryId

	return @Blogcount
end
select dbo.usp_BlogsCategory(2) as BlogCount
--6)
create function usp_BlogUser (@userId int)
returns table
as
return
(
    select BlogId, BlogTitle, BlogDescription from Blogs
    where BlogUserId = @userId
)

select BlogId, BlogTitle, BlogDescription from dbo.usp_BlogUser(1)

drop table Categories
drop table Tags
drop table Comments
drop table Users
drop table Blogs
DROP TABLE BlogTag

select * from Categories
select * from Tags
select * from Comments
select * from Users
select * from Blogs
select * from BlogTag
