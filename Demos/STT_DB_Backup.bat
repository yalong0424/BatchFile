@echo off
setlocal EnableDelayedExpansion

rem get max backupdate size
set max_file_Size=0
set max_size_file_name=""
for /r %%i in (*.rar) do (
	set "cur_file_size=%%~zi"
	echo current file size is: !cur_file_size!
	if !cur_file_size! gtr !max_file_Size! (
		if exist !max_size_file_name! (
			echo ready to delete file: !max_size_file_name!
			del /F /S /Q !max_size_file_name!
		)
		set "max_file_Size=!cur_file_size!"
		set "max_size_file_name=%%~i"
		echo new max size file name is: !max_size_file_name!
		echo new max file size is: !max_file_Size!
	) else (
		echo ready to delete file: %%~i
		del /F /S /Q %%~i
	)
	echo --------------------------------------------
)
echo max size file name: %max_size_file_name%
echo max file size is: %max_file_Size%

rem backup new data
set "Ymd=%date:~10,4%%date:~4,2%%date:~7,2%"
echo making backup folder...
md "D:\Backup\JimingWang_ST1\%Ymd%"
echo backup stt autotranslate database...
"C:\Program Files\MySQL\MySQL Server 5.5\bin\mysqldump.exe" -uroot -proot autotranslate > D:\Backup\JimingWang_ST1\%Ymd%\autotranslate.sql
echo Winrar loading...
"C:\Program Files\WinRAR\WinRAR.exe" a -ep1 -r -o+ -m5 -df "D:\Backup\JimingWang_ST1\%Ymd%.rar" "D:\Backup\JimingWang_ST1\%Ymd%"
echo OK!

rem get new data size
for /r %%i in (%Ymd%.rar) do (
	set "new_backup_file_size=%%~zi"
	echo new bacup file is: %%~i , and size is: !new_backup_file_size!
)

rem judge if really need backup new data
if %new_backup_file_size% geq %max_file_Size% (
	if exist %max_size_file_name% (
		echo ready to delete old backup file: %max_size_file_name%
		del /F /S /Q %max_size_file_name%
	)
) else (
	echo msgbox "The size of new backup file less than exist file size!" > msgbox.vbs
	msgbox.vbs
	del msgbox.vbs
)