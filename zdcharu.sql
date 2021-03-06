USE [ge_two]
GO
/****** Object:  Trigger [dbo].[Tigger_AutoInsertLis_1]    Script Date: 03/23/2021 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
ALTER TRIGGER [dbo].[Tigger_AutoInsertLis_1]
   ON  [dbo].[Check_Base]
   AFTER UPDATE, insert
AS 
BEGIN
	SET NOCOUNT ON;
	declare @mzh varchar(20)
	declare @checkdate varchar(20)
	declare @maxid int
	declare @iexists int
	declare @sex varchar(20)
	declare @yqmc varchar(100)
	if update (mzh)
	begin
		select @mzh=mzh,@checkdate=CONVERT(varchar(20), CheckDate,23),@sex=Sex ,@yqmc=yqmc from inserted--获取该门诊号
		if ( LEN(@mzh)=10 and @yqmc= 'xp100' )
		begin
			--判断 白带常规 是否存在数据了
			select @iexists=COUNT(*) from Check_Base where Mzh=@mzh and CONVERT(varchar(20),checkdate,23)=@checkdate and Yqmc =  '白带常规'
			if @iexists=0 and @sex='女'
			begin
				--若数据为0 则执行数据插入操作
				insert into Check_Base(CheckDate, YangBenBh, BingRenLx, Mzh, Name, Sex, Age, Ssks, Cwh, Bblx, Sjys, Sjsj, Cysj, Jyys, Shys, Lczd, BeiZhu, Sfsh, Sfdy, Yqmc) 
				select CheckDate, YangBenBh, BingRenLx, Mzh, Name, Sex, Age, Ssks, Cwh, Bblx, Sjys, Sjsj, Cysj, Jyys, Shys, Lczd, BeiZhu, Sfsh, Sfdy, '白带常规' 
				from Check_Base 
				where Mzh=@mzh and CONVERT(varchar(20),checkdate,23)=@checkdate and Yqmc = 'xp100'
				
				set @maxid= ( select  top 1  ID  from Check_Base order by id desc)
				
				insert into Check_Item (ID, Xmbh, Jyxm, Zwms, ResultValue, Zt, Ckz, Dw, Rksj, IsUpload)
				select @maxid,Item_Xh,Item_Dm,Item_Name,MRZ,'',[Range],Item_Dw,GETDATE(),null
				from Sys_Inspect where Jqxh = '白带常规'  
			end
			  
			--判断 男女婚检 是否存在数据了
			select @iexists=COUNT(*) from Check_Base where Mzh=@mzh and CONVERT(varchar(20),checkdate,23)=@checkdate and Yqmc =  '男女婚检'
			if @iexists=0
			begin
				--若数据为0 则执行数据插入操作
				
				insert into Check_Base(CheckDate, YangBenBh, BingRenLx, Mzh, Name, Sex, Age, Ssks, Cwh, Bblx, Sjys, Sjsj, Cysj, Jyys, Shys, Lczd, BeiZhu, Sfsh, Sfdy, Yqmc) 
				select CheckDate, YangBenBh, BingRenLx, Mzh, Name, Sex, Age, Ssks, Cwh, Bblx, Sjys, Sjsj, Cysj, Jyys, Shys, Lczd, BeiZhu, Sfsh, Sfdy, '男女婚检' 
				from Check_Base 
				where Mzh=@mzh and CONVERT(varchar(20),checkdate,23)=@checkdate and Yqmc = 'xp100'
				
				set @maxid= ( select  top 1  ID  from Check_Base order by id desc)
				
				insert into Check_Item (ID, Xmbh, Jyxm, Zwms, ResultValue, Zt, Ckz, Dw, Rksj, IsUpload)
				select @maxid,Item_Xh,Item_Dm,Item_Name,MRZ,'',[Range],Item_Dw,GETDATE(),null
				from Sys_Inspect where Jqxh = '男女婚检'  
			end
			
		end
	end
END
