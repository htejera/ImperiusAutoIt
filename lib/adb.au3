;adb.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
;An ADB pseudo-client. Based on <https://www.autoitscript.com/forum/topic/160936-android-udf/> by Kyaw Swar Thwin.

;Function: Adb
;
;Parameters:
;	$sDevice - String. The device serial id.Default is empty.
;	$oLogger - Object. A Looger instance. Defualt is empty.
;
;Returns:
;   Object. An Adb instance.
Func Adb($sDeviceID = "", $oLogger = "")
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("connect", "_Adb_Connect")
		.AddMethod("isOnline", "_Adb_IsOnline")
		.AddMethod("isOffline", "_Adb_IsOffline")
		.AddMethod("fileExists", "_Adb_FileExists")
		.AddMethod("install", "_Adb_Install")
		.AddMethod("uninstall", "_Adb_Uninstall")
		.AddMethod("push", "_Adb_Push")
		.AddMethod("pull", "_Adb_Pull")
		.AddMethod("shell", "_Adb_Shell")
		.AddMethod("run", "_Adb_Run")
		.AddMethod("forward", "_Adb_Forward")
		.AddMethod("stopPackage", "_Adb_StopPackage")
		.AddMethod("getMemoryInfo", "_Adb_GetMemoryInfo")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("deviceId", $ELSCOPE_PRIVATE, $sDeviceID)
		.AddProperty("oLogger", $ELSCOPE_PRIVATE, $oLogger)
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>Adb

#Region Methods
;Function: __Run
;A wrapper for Run function. Runs an external program.
;
;Parameters:
;   $oSelf - Object reference.
;	$sCommand - String. The command to execute.
;
;Returns:
;  String. The command output.
Func __Run($oSelf, $sCommand)
	Local $iPID, $sLine, $sOutput = ""
	$iPID = Run(@ComSpec & " /c " & $sCommand & " 2>&1", @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While 1
		$sLine = StdoutRead($iPID)
		If (@error Or StringInStr($sLine, "Starting server on port") <> 0) Then
			ExitLoop
		EndIf
		$sOutput &= $sLine
	WEnd
	StdioClose($iPID)
	$sOutput = StringStripCR(StringTrimRight($sOutput, StringLen(@CRLF)))
	If (IsObj($oSelf.oLogger)) Then
		$oSelf.oLogger.info("[ADB] Run command:" & $sCommand & ". Result:" & $sOutput)
	EndIf
	Return $sOutput
EndFunc   ;==>__Run

;Function: _Adb_Connect
;Start the adb server process.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;
Func _Adb_Connect($oSelf)
	__Run($oSelf, "adb start-server")
EndFunc   ;==>_Adb_Connect

;Function: _Adb_IsOffline
;Check if the adb server is offline.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;
Func _Adb_IsOffline($oSelf)
	Return __Run($oSelf, "adb get-state") = "offline"
EndFunc   ;==>_Adb_IsOffline

;Function: _Adb_IsOnline
;Check if the adb server is online.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;
Func _Adb_IsOnline($oSelf)
	Return __Run($oSelf, "adb get-state") = "device"
EndFunc   ;==>_Adb_IsOnline

;Function: _Adb_Install
;Pushes an Android application (specified as a full path to an .apk file) to an emulator/device.
;
;Parameters:
;   $oSelf - Object reference.
;	$sFilePath - String. The full path to the .apk file.
;	$iMode - String. 1=Install on Internal Storage  2=Install application on sdcard. Default is 1.
;	$bReinstall - Boolean. True = Install on Internal Storage. Default is False.
;
;Returns:
;  Boolean Success: True Failure: False.
Func _Adb_Install($oSelf, $sFilePath, $iMode = 1, $bReinstall = False)
	Local $aOutput
	If $iMode = Default Then $iMode = 1
	If $bReinstall = Default Then $bReinstall = False
	If $iMode = 2 Then ; Install on SD Card
		If $bReinstall Then
			$aOutput = StringSplit(_Adb_Run($oSelf, 'install -r -s "' & $sFilePath & '"'), @LF)
		Else
			$aOutput = StringSplit(_Adb_Run($oSelf, 'install -s "' & $sFilePath & '"'), @LF)
		EndIf
	Else ; Install on Internal Storage
		If $bReinstall Then
			$aOutput = StringSplit(_Adb_Run($oSelf, 'install -r "' & $sFilePath & '"'), @LF)
		Else
			$aOutput = StringSplit(_Adb_Run($oSelf, 'install "' & $sFilePath & '"'), @LF)
		EndIf
	EndIf
	If $aOutput[UBound($aOutput) - 1] <> "Success" Then
		$aOutput = _StringBetween($aOutput[UBound($aOutput) - 1], "[", "]")
		If Not @error Then
			Switch $aOutput[0]
				Case "INSTALL_FAILED_ALREADY_EXISTS"
					Return SetError(1, 0, $INSTALL_FAILED_ALREADY_EXISTS)
				Case "INSTALL_FAILED_INVALID_APK"
					Return SetError(1, 0, $INSTALL_FAILED_INVALID_APK)
				Case "INSTALL_FAILED_INVALID_URI"
					Return SetError(1, 0, $INSTALL_FAILED_INVALID_URI)
				Case "INSTALL_FAILED_INSUFFICIENT_STORAGE"
					Return SetError(1, 0, $INSTALL_FAILED_INSUFFICIENT_STORAGE)
				Case "INSTALL_FAILED_DUPLICATE_PACKAGE"
					Return SetError(1, 0, $INSTALL_FAILED_DUPLICATE_PACKAGE)
				Case "INSTALL_FAILED_NO_SHARED_USER"
					Return SetError(1, 0, $INSTALL_FAILED_NO_SHARED_USER)
				Case "INSTALL_FAILED_UPDATE_INCOMPATIBLE"
					Return SetError(1, 0, $INSTALL_FAILED_UPDATE_INCOMPATIBLE)
				Case "INSTALL_FAILED_SHARED_USER_INCOMPATIBLE"
					Return SetError(1, 0, $INSTALL_FAILED_SHARED_USER_INCOMPATIBLE)
				Case "INSTALL_FAILED_MISSING_SHARED_LIBRARY"
					Return SetError(1, 0, $INSTALL_FAILED_MISSING_SHARED_LIBRARY)
				Case "INSTALL_FAILED_REPLACE_COULDNT_DELETE"
					Return SetError(1, 0, $INSTALL_FAILED_REPLACE_COULDNT_DELETE)
				Case "INSTALL_FAILED_DEXOPT"
					Return SetError(1, 0, $INSTALL_FAILED_DEXOPT)
				Case "INSTALL_FAILED_OLDER_SDK"
					Return SetError(1, 0, $INSTALL_FAILED_OLDER_SDK)
				Case "INSTALL_FAILED_CONFLICTING_PROVIDER"
					Return SetError(1, 0, $INSTALL_FAILED_CONFLICTING_PROVIDER)
				Case "INSTALL_FAILED_NEWER_SDK"
					Return SetError(1, 0, $INSTALL_FAILED_NEWER_SDK)
				Case "INSTALL_FAILED_TEST_ONLY"
					Return SetError(1, 0, $INSTALL_FAILED_TEST_ONLY)
				Case "INSTALL_FAILED_CPU_ABI_INCOMPATIBLE"
					Return SetError(1, 0, $INSTALL_FAILED_CPU_ABI_INCOMPATIBLE)
				Case "INSTALL_FAILED_MISSING_FEATURE"
					Return SetError(1, 0, $INSTALL_FAILED_MISSING_FEATURE)
				Case "INSTALL_FAILED_CONTAINER_ERROR"
					Return SetError(1, 0, $INSTALL_FAILED_CONTAINER_ERROR)
				Case "INSTALL_FAILED_INVALID_INSTALL_LOCATION"
					Return SetError(1, 0, $INSTALL_FAILED_INVALID_INSTALL_LOCATION)
				Case "INSTALL_FAILED_MEDIA_UNAVAILABLE"
					Return SetError(1, 0, $INSTALL_FAILED_MEDIA_UNAVAILABLE)
				Case "INSTALL_FAILED_VERIFICATION_TIMEOUT"
					Return SetError(1, 0, $INSTALL_FAILED_VERIFICATION_TIMEOUT)
				Case "INSTALL_FAILED_VERIFICATION_FAILURE"
					Return SetError(1, 0, $INSTALL_FAILED_VERIFICATION_FAILURE)
				Case "INSTALL_FAILED_PACKAGE_CHANGED"
					Return SetError(1, 0, $INSTALL_FAILED_PACKAGE_CHANGED)
				Case "INSTALL_FAILED_UID_CHANGED"
					Return SetError(1, 0, $INSTALL_FAILED_UID_CHANGED)
				Case "INSTALL_FAILED_VERSION_DOWNGRADE"
					Return SetError(1, 0, $INSTALL_FAILED_VERSION_DOWNGRADE)
				Case "INSTALL_FAILED_INTERNAL_ERROR"
					Return SetError(1, 0, $INSTALL_FAILED_INTERNAL_ERROR)
				Case "INSTALL_FAILED_USER_RESTRICTED"
					Return SetError(1, 0, $INSTALL_FAILED_USER_RESTRICTED)
			EndSwitch
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Return $INSTALL_SUCCEEDED
EndFunc   ;==>_Adb_Install

;Function: _Adb_Uninstall
;Removes a package from the emulator/device.
;
;Parameters:
;   $oSelf - Object reference.
;	$sPackage -String. The package to remove.
;	$bKeepDataCache - Boolean. Keep the data and cache directories around after package removal.Default is False.
;
;Returns:
;  Int. Success: 1 Failure: .
Func _Adb_Uninstall($oSelf, $sPackage, $bKeepDataCache = False)
	Local $sOutput
	If $bKeepDataCache = Default Then $bKeepDataCache = False
	If $bKeepDataCache Then
		$sOutput = _Adb_Run($oSelf, 'uninstall -k ' & $sPackage)
	Else
		$sOutput = _Adb_Run($oSelf, 'uninstall ' & $sPackage)
	EndIf
	If $sOutput <> "Success" Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_Adb_Uninstall

;Function: _Adb_Push
;Upload a specified file from your computer to an emulator/device.
;
;Parameters:
;   $oSelf - Object reference.
;	$sLocalPath - String. The full local  path to the file to upload.
;	$sRemotePath - String.
;
;Returns:
;  Int. Success: 1 Failure: .
Func _Adb_Push($oSelf, $sLocalPath, $sRemotePath)
	Return _Adb_Run($oSelf, 'push "' & $sLocalPath & '" "' & $sRemotePath & '"')
EndFunc   ;==>_Adb_Push

;Function: _Adb_Pull
;Download a specified file from an emulator/device to your computer.
;
;Parameters:
;   $oSelf - Object reference.
;	$sRemotePath - String.
;	$sLocalPath - String.
;
;Returns:
;  Int. Success: 1 Failure: .
Func _Adb_Pull($oSelf, $sRemotePath, $sLocalPath)
	Return _Adb_Run($oSelf, 'pull "' & $sRemotePath & '" "' & $sLocalPath & '"')
EndFunc   ;==>_Adb_Pull

;Function: _Adb_Forward
;Forward socket connections.
;
;Parameters:
;   $oSelf - Object reference.
;	$iLocal  - Int. The local port.
;	$iRemote - Int. The remote port.
Func _Adb_Forward($oSelf, $iLocal, $iRemote)
	_Adb_Run($oSelf, 'forward tcp:' & $iLocal & ' tcp:' & $iRemote)
EndFunc   ;==>_Adb_Forward

;Function: _Adb_FileExist
;Checks if a file or directory exists.
;
;Parameters:
;   $oSelf - Object reference.
;	$sFilePath  - String. The directory or file to check.
;
;Returns:
;  Boolean. Success: True Failure: False.
Func _Adb_FileExists($oSelf, $sFilePath)
	Local $sResponse = _Adb_Shell($oSelf, 'if [ -e \"' & $sFilePath & '\" ]; then echo \"Found\"; else echo \"Not Found\"; fi') = "Found"
	Return ($sResponse == "Found") ? True : False
EndFunc   ;==>_Adb_FileExists

;Function: _Adb_GetMemoryInfo
;Get currently memory consumption of an application.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String. The package.
;
;Returns:
;	Success: An array with these values:
;	- element [0] contains the value of Proportional Set Size (PSS).
;	- element [1] contains the value of Private Dirty RAM.
;	- element [2] contains the value of Private Clean RAM.
;	- element [3] contains the value of Swapped Dirty RAM.
;	- element [4] contains the value of Heap Size RAM.
;	- element [5] contains the value of Heap Alloc RAM.
;	- element [6] contains the value of Heap Free RAM.
; Failure: sets the @error flag to non-zero.
Func _Adb_GetMemoryInfo($oSelf, $sPackage)
	Local Enum $PPS, $PDR, $PCR, $SDR, $HSR, $HAR, $HFR
	Local $aResult[7]
	Local $sResponse = _Adb_Shell($oSelf, 'dumpsys meminfo ' & $sPackage)
	;TODO: Please, someone remove this ugly memory parser and make a better regex based parser
	;for this output. Thank you.
	Local $aTotal = _StringBetween($sResponse, "TOTAL   ", "", Default, True)
	Local $iError = @error
	If $iError Then Return SetError($iError, 0)
	Local $aTemp = StringSplit(StringStripWS($aTotal[0], $STR_STRIPSPACES), " ")
	$aResult[$PPS] = $aTemp[1]
	$aResult[$PDR] = $aTemp[2]
	$aResult[$PCR] = $aTemp[3]
	$aResult[$SDR] = $aTemp[4]
	$aResult[$HSR] = $aTemp[5]
	$aResult[$HAR] = $aTemp[6]
	$aResult[$HFR] = StringRegExpReplace($aTemp[7], "\D", "")
	Return $aResult
EndFunc   ;==>_Adb_GetMemoryInfo

;Function: _Adb_StopPackage
;Force stop everything associated with the given package.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String. The package.
;
;Returns:
;	String. The command output.
Func _Adb_StopPackage($oSelf, $sPackage)
	Return _Adb_Shell($oSelf, 'am force-stop ' & $sPackage)
EndFunc   ;==>_Adb_StopPackage

;Function: _Adb_Shell
;Exceute a shell command.
;
;Parameters:
;   $oSelf - Object reference.
;	$sCommand - String. The  shell command to execute.
;
;Returns:
;  Int. Success: 1 Failure: .
Func _Adb_Shell($oSelf, $sCommand)
	Return _Adb_Run($oSelf, 'shell "' & $sCommand & '"')
EndFunc   ;==>_Adb_Shell

;Function: _Adb_Run
;Exceute an adb command.
;
;Parameters:
;   $oSelf - Object reference.
;	$sCommand - String. The command to execute.
;
;Returns:
;  Int. Success: 1 Failure: .
Func _Adb_Run($oSelf, $sCommand)
	Local $sSerial = ($oSelf.deviceId <> "") ? "-s " & $oSelf.deviceId : ""
	Return __Run($oSelf, 'adb ' & $sSerial & ' ' & $sCommand)
EndFunc   ;==>_Adb_Run
#EndRegion Methods
