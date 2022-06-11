@echo off
setlocal enabledelayedexpansion

rem -- Variable definitions (Config) -------------------------------------------------------
set BACKUP_EXTENSION=bak
set TARGET_FORDER=Microsoft.FlightSimulator\LocalCache\Packages\Official\OneStore\
set MSFS_FORDER=C:\Users\air\AppData\Local\Packages\Microsoft.FlightSimulator_8wekyb3d8bbwe\LocalCache\Packages\Official\OneStore\

rem -- Start -------------------------------------------------------------------------------
set /P START_FLAG="> Start to do change file. Please press (y/n)... "
if NOT %START_FLAG% == y (goto :exit)

set /P START_FLAG="> Is '%MSFS_FORDER%' the MSFS2020 folder, please press (y/n)... "
if NOT %START_FLAG% == y (goto :exit)

set CURRENT_FORDER=%~dp0
set ts=%time: =0%
set ts=%date:~10,4%%date:~4,2%%date:~7,2%_%ts:~0,2%%ts:~3,2%%ts:~6,2%

echo # Check if the original files exist or not.
set NO_FILE_FLAG=0
for /R %CURRENT_FORDER%%TARGET_FORDER% %%1 in (*) do (
	set FILE_PATH=%%1
	set TARGET_FILE_PATH=!FILE_PATH!
	set ORIGINAL_FILE_PATH=!!FILE_PATH:%CURRENT_FORDER%%TARGET_FORDER%=%MSFS_FORDER%!!
	if exist !ORIGINAL_FILE_PATH! (
		echo  - [OK] !ORIGINAL_FILE_PATH! is exist.
	) else (
		echo  - [NG] !ORIGINAL_FILE_PATH! is not exist.
		set NO_FILE_FLAG=1
	)
)
if %NO_FILE_FLAG% == 1 (goto :exit)

echo # Replace the files.
for /R %CURRENT_FORDER%%TARGET_FORDER% %%1 in (*) do (
	set FILE_PATH=%%1
	set TARGET_FILE_PATH=!FILE_PATH!
	set ORIGINAL_FILE_PATH=!!FILE_PATH:%CURRENT_FORDER%%TARGET_FORDER%=%MSFS_FORDER%!!
	set BACKUP_FILE_PATH=!ORIGINAL_FILE_PATH!.%BACKUP_EXTENSION%_%ts%
	copy !ORIGINAL_FILE_PATH! !BACKUP_FILE_PATH! > nul
	copy !TARGET_FILE_PATH! !ORIGINAL_FILE_PATH! > nul
	echo  - Complete to replace !ORIGINAL_FILE_PATH!.
)

:exit

set /P START_FLAG="> Finished to do change file. Please press any key..."
exit 0
endlocal
