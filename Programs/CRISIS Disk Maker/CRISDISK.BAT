@rem======================================================================
@rem
@rem  Prevent the display of commands during execution.
@rem
@rem======================================================================
	@echo off


rem	crisdisk.bat - Batch File to Create CRISIS Recovery Disk
rem======================================================================
rem	Copyright (c) 1985-96 Phoenix Technologies Ltd.
rem	This program contains proprietary and confidential information. All
rem	rights reserved except as may be permitted by prior written consent.
rem
rem
rem			R E V I S I O N    H I S T O R Y
rem    	 $Log:   K:/nb/archive/nubios/crisis/std.600/minidos.bav  $
rem	
rem	   Rev 1.0   31 Jul 2001 16:54:02            
rem	$START:     ---------------------------------------------------------
rem	$REPORT:    ECR=IRV03376
rem	$AUTHOR:
rem	$REVIEWERS:
rem	$SCOPE:     All BIOS builds             
rem	$REQUIRES: 
rem		    script.600\build.mak -r1.152
rem		    script.600\bootblok.mak -r1.35
rem		    script.600\filerev.dfl -r1.77
rem		    crisis\std.600\fulldos.bat -r1.0
rem		    crisis\std.600\minidos.bat -r1.0
rem	 	    crisis\std.600\filerev.dfl -r1.57
rem	
rem		    obsolete crisdisk.bat -r1.7
rem	
rem	$GENERAL:   Added support for creating FULLDOS under Nmaker Crisis.
rem	$INSTALL:   
rem	
rem	$TECHNICAL: 
rem		1) Modified BOOTBLOK.MAK in SCRIPT.600 to generate a FULLDOS.TXT.
rem		2) Modified BUILD.MAK in SCRIPT.600 to detect the FULLDOS.TXT in 
rem		bootblok directory then perform a FULLDOS crisdisk.zip.
rem		3) Obsolesced crisdisk.bat in the crisis\std.600.
rem	        4) Created fulldos.bat and minidos.bat in crisis\std.600 for
rem	        crisdisk.zip. Either fulldos.bat or minidos.bat are copied to
rem	        crisdisk.bat depending on the type of crisdisk.zip being created.
rem	
rem	      
rem Came from:	 K:/nb/archive/nubios/crisis/std.600/crisdisk.bat -r1.7
rem	
rem======================================================================


rem======================================================================
rem
rem  Initialize the global variables used by the script file.
rem
rem======================================================================
	set crisisDrivePresent=false
	if not '%crisisDrivePresent%'=='false' goto cdEnvErr

	set crisisHelpFlag=false
	if not '%crisisHelpFlag%'=='false' goto cdEnvErr

	set crisisParamaterError=false
	if not '%crisisParamaterError%'=='false' goto cdEnvErr

	set crisisDriveName=A:
	if not '%crisisDriveName%'=='A:' goto cdEnvErr


rem======================================================================
rem
rem  Clear the initial screen display.
rem
rem======================================================================
	cls


rem======================================================================
rem
rem  Check the command line for legal parameter values, exit when done.
rem
rem======================================================================
:cdParmLp
	if '%1'=='' goto cdParmCk


rem======================================================================
rem
rem  Check for the Crisis Disk destination drive.
rem
rem======================================================================
	if '%1'=='A:' goto cdDrvSet
	if '%1'=='a:' goto cdDrvSet

	if '%1'=='B:' goto cdDrvSet
	if '%1'=='b:' goto cdDrvSet


rem======================================================================
rem
rem  Check for the Crisis Disk help flag.
rem
rem======================================================================
	if '%1'=='/?' goto cdFlgSet
	if '%1'=='-?' goto cdFlgSet


rem======================================================================
rem
rem  Process any illegal parameters.
rem
rem======================================================================
	goto cdParmBd


rem======================================================================
rem
rem  Set the Crisis Disk drive if specified.
rem
rem======================================================================
:cdDrvSet
	if not '%crisisDrivePresent%'=='false' echo.
	if not '%crisisDrivePresent%'=='false' echo -----     Warning - Extra Paramater "%1" Ignored

	if '%crisisDrivePresent%'=='false' set crisisDriveName=%1
	if '%crisisDrivePresent%'=='false' set crisisDrivePresent=true

	goto cdParmNx


rem======================================================================
rem
rem  Set the Crisis Disk update mode if specified.
rem
rem======================================================================
:cdFlgSet
	if not '%crisisHelpFlag%'=='false' echo.
	if not '%crisisHelpFlag%'=='false' echo -----     Warning - Extra Paramater "%1" Ignored

	if '%crisisHelpFlag%'=='false' set crisisHelpFlag=true

	goto cdParmNx


rem======================================================================
rem
rem  Display an error message for illegal parameters.
rem
rem======================================================================
:cdParmBd
	echo.
	echo -----     Error - Illegal Parameter "%1"

	set crisisParamaterError=true


rem======================================================================
rem
rem  Check for the next valid paramater.
rem
rem======================================================================
:cdParmNx
	shift

	goto cdParmLp


rem======================================================================
rem
rem  Prevent Crisis Disk creation if an error occured.
rem
rem======================================================================
:cdParmCk
	if '%crisisParamaterError%'=='true' goto cdParmSh


rem======================================================================
rem
rem  Display help screen if help is requested.
rem
rem======================================================================
	if '%crisisHelpFlag%'=='true' goto cdParmSh


rem======================================================================
rem
rem  Indicate that the BOOT BLOCK boot disk will be created.
rem
rem======================================================================
	echo.
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo               Creating the CRISIS diskette on drive %crisisDriveName%
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo.
	pause Press any key to format the CRISIS disk...


rem======================================================================
rem
rem  Format the Crisis Disk.
rem
rem======================================================================
	cls

	echo.
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo               The Crisis Disk in drive %crisisDriveName% is being formatted
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo.

	format /q /u /v /t:80 /n:18 %crisisDriveName%

	if ERRORLEVEL==3 goto cdFmtBrk
	if ERRORLEVEL==4 goto cdFtlFmt
	if ERRORLEVEL==5 goto cdNoProc

	echo.
	pause Press any key to copy the utilities to the CRISIS disk...


rem======================================================================
rem
rem  Copy the utility files to the boot disk in the required order.
rem
rem======================================================================
	cls

	echo.
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo               The necessary files are being copied to the
	echo               Crisis Disk
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo.

	set crisisCurrentFile=MINIDOS.SYS
	echo Copying the file "%crisisCurrentFile%"
	xcopy /v %crisisCurrentFile% %crisisDriveName% >nul
	if ERRORLEVEL==1 goto cdNoFile
	if ERRORLEVEL==2 goto cdCpyBrk
	if ERRORLEVEL==4 goto cdMemErr
	if ERRORLEVEL==5 goto cdWrtErr

	set crisisCurrentFile=PHLASH.EXE
	if exist PHLASH16.EXE set crisisCurrentFile=PHLASH16.EXE
	echo Copying the file "%crisisCurrentFile%"
	xcopy /v %crisisCurrentFile% %crisisDriveName% >nul
	if ERRORLEVEL==1 goto cdNoFile
	if ERRORLEVEL==2 goto cdCpyBrk
	if ERRORLEVEL==4 goto cdMemErr
	if ERRORLEVEL==5 goto cdWrtErr

	if exist PHLASH16.EXE goto NOPLATFORM
	set crisisCurrentFile=PLATFORM.BIN
	echo Copying the file "%crisisCurrentFile%"
	xcopy /v %crisisCurrentFile% %crisisDriveName% >nul
	if ERRORLEVEL==1 goto cdNoFile
	if ERRORLEVEL==2 goto cdCpyBrk
	if ERRORLEVEL==4 goto cdMemErr
	if ERRORLEVEL==5 goto cdWrtErr

:NOPLATFORM
	set crisisCurrentFile=VGABIOS.EXE
	if not exist %crisisCurrentFile% goto cdnovga
	echo Copying the file "%crisisCurrentFile%"
	xcopy /v %crisisCurrentFile% %crisisDriveName% >nul
	if ERRORLEVEL==1 goto cdNoFile
	if ERRORLEVEL==2 goto cdCpyBrk
	if ERRORLEVEL==4 goto cdMemErr
	if ERRORLEVEL==5 goto cdWrtErr

:cdnovga
	set crisisCurrentFile=BIOS.ROM
	if exist PHLASH16.EXE set crisisCurrentFile=BIOS.WPH
	echo Copying the file "%crisisCurrentFile%"
	xcopy /v %crisisCurrentFile% %crisisDriveName% >nul
	if ERRORLEVEL==1 goto cdNoFile
	if ERRORLEVEL==2 goto cdCpyBrk
	if ERRORLEVEL==4 goto cdMemErr
	if ERRORLEVEL==5 goto cdWrtErr

	echo.
	pause Press any key to create the CRISIS disk boot sector...


rem======================================================================
rem
rem  Create the boot sector on the crisis disk.
rem
rem======================================================================
	cls

	echo.
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo               The Crisis Disk boot sector for drive %crisisDriveName%
	echo               is being created
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo.

	makeboot %crisisDriveName%

	if not ERRORLEVEL==0 goto cdMkBErr

	echo.
	pause Press any key to exit the CRISIS disk creation utility...


rem======================================================================
rem
rem  Signal that the Crisis Disk has been created.
rem
rem======================================================================
	cls

	echo.
	echo.
	echo          -----------------------------------------------------------
	echo.
	echo               CRISIS diskette on drive %crisisDriveName% successfully created
	echo               Please remove the disk from drive %crisisDriveName%
	echo.
	echo          -----------------------------------------------------------
	echo.


rem======================================================================
rem
rem  Clear the global variables used by the script file.
rem
rem======================================================================
	set crisisDrivePresent=
	if not '%crisisDrivePresent%'=='' goto cdEnvErr

	set crisisHelpFlag=
	if not '%crisisHelpFlag%'=='' goto cdEnvErr

	set crisisDriveName=
	if not '%crisisDriveName%'=='' goto cdEnvErr

	set crisisParamaterError=
	if not '%crisisParamaterError%'=='' goto cdEnvErr

rem======================================================================
rem
rem  Exit from the Crisis Disk creation script.
rem
rem======================================================================
	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that the user interrupted the format process.
rem
rem======================================================================
:cdFmtBrk
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - The user interrupted while formatting, the
	echo         Crisis Disk was not created.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that there was a disk error during the format process.
rem
rem======================================================================
:cdFtlFmt
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - A disk error occured while formatting, the
	echo         Crisis Disk was not created.  Check the disk
	echo         for errors or replace the disk with a new 1.44MB
	echo         disk, then try again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that the user waived the format process.
rem
rem======================================================================
:cdNoProc
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - The user choose not to format the disk, the
	echo         Crisis Disk was not created.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that the file to copy was not found.
rem
rem======================================================================
:cdNoFile
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - The file "%crisisCurrentFile%" was not found,
	echo         the Crisis Disk was not created. Check for the
	echo         file "%crisisCurrentFile%", then try again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that the user interrupted the copy process.
rem
rem======================================================================
:cdCpyBrk
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - The user interrupted while copying "%crisisCurrentFile%",
	echo         the Crisis Disk was not created.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that the copy process initialization failed.
rem
rem======================================================================
:cdMemErr
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - Initialization error when copying "%crisisCurrentFile%",
	echo         the Crisis Disk was not created.  Free extra
	echo         conventional memory by removing any unneeded TSRs,
	echo         then try again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate that there was a disk error during the copy process.
rem
rem======================================================================
:cdWrtErr
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - A disk error occured while copying "%crisisCurrentFile%",
	echo         the Crisis Disk was not created.  Check the
	echo         disk for errors or replace the disk, then try
	echo         again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Desplay the environment variable allocation error message.
rem
rem======================================================================
:cdEnvErr
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - System unable to assign environment variables,
	echo         Increase the main environment space, then try again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Desplay the boot sector error message.
rem
rem======================================================================
:cdMkBErr
	echo.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	echo Error - System unable to create the custom boot sector.
	echo         Check the disk for errors or replace the disk,
	echo         then try again.
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.

	goto cdCrtExt


rem======================================================================
rem
rem  Indicate the correct usage for the batch file.
rem
rem======================================================================
:cdParmSh
	echo.
	echo      #######################################################################
	echo      #                                                                     #
	echo      #     CRISDISK Usage:                                                 #
	echo      #                                                                     #
	echo      #        CRISDISK [DRIVE:] [/? or -?]                                 #
	echo      #                                                                     #
	echo      #           DRIVE    - The drive (A: or B:) where the disk will be    #
	echo      #                      created  (Default is A:)                       #
	echo      #                                                                     #
	echo      #           /? or -? - Display this help screen                       #
	echo      #                                                                     #
	echo      #######################################################################


rem======================================================================
rem
rem  Exit the batch file.
rem
rem======================================================================
:cdCrtExt
	echo.
	pause Press any key to return to DOS...
	echo.
	echo.
