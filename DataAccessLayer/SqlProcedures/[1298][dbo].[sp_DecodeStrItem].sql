SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* @author Gilad Reich
* @date 4-30-2018
* @source https://ko4life.net/topic/511-decoding-userdata-stritem-column-with-raw-sql
*/
CREATE OR ALTER procedure [dbo].[_HorrusTB_DecodeStrItem]
    @strUserId varchar(21),
    @displayAll bit = 0
AS

declare @T_PlayerItems TABLE(Slot int, Num int, strName char(50), MaxDuarbility smallint, CurrentDuarbility smallint, ItemCount smallint);

declare @int32Num int;
declare @strName char(50);
declare @MaxDuarbility smallint;
declare @int16Duarbility smallint;
declare @int16ItemCount smallint;

declare @binaryData varbinary(400);
set @binaryData = cast((select strItem from USERDATA where strUserId = @strUserId) as varbinary(400));

declare @i int = 0
while @i < 50 
begin
	set @int32Num        = cast(cast(reverse(substring( @binaryData, @i*8-7, 4 )) as varbinary(4)) as int);
	set @int16Duarbility = cast(cast(reverse(substring( @binaryData, @i*8-3, 2 )) as varbinary(2)) as smallint);
	set @int16ItemCount  = cast(cast(reverse(substring( @binaryData, @i*8-1, 2 )) as varbinary(2)) as smallint);
	set @strName         = (select strName from ITEM where Num=@int32Num);
	set @MaxDuarbility   = (select Duration from ITEM where Num=@int32Num);
	
	insert into @T_PlayerItems values(@i, @int32Num, @strName, @MaxDuarbility, @int16Duarbility, @int16ItemCount);
	
	set @i = @i + 1;
end

if @displayAll = 1
	select * from @T_PlayerItems;
else
	select * from @T_PlayerItems where strName is not null;