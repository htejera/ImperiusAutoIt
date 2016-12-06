;logger.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; Logging. This object allows you to log messages with different log levels.
; Based on <https://www.autoitscript.com/forum/topic/163508-simple-logging-udf-logau3-based-on-log4j-nlog> by jvanegmond.

Global Enum $LOG_TRACE, $LOG_DEBUG, $LOG_INFO, $LOG_WARN, $LOG_ERROR, $LOG_FATAL

;Function: Logger
;
;Parameters:
;	$sFileName - String. The full path to the log file. Writes log entries to a file. Defaul is empty (log to console).
;
;Returns:
;   Object. A Looger instance.
Func Logger($sFileName = "")
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()
	Local $hLastLogHandle = -1
	Local $iLevel = $LOG_INFO
	Local $fLogFormat = _LogFormatDefault
	Local Const $LOG_LEVELSTRING[6] = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"]

	If ($sFileName <> "") Then
		$hLastLogHandle = FileOpen($sFileName, 1 + 8)
	EndIf

	;Methods
	With $oClassObject
		.AddMethod("getLevel", "_GetLevel")
		.AddMethod("setLevel", "_LogLevel")
		.AddMethod("setFormat", "_LogFormat")
		.AddMethod("trace", "_LogTrace")
		.AddMethod("debug", "_LogDebug")
		.AddMethod("info", "_LogInfo")
		.AddMethod("warn", "_LogWarn")
		.AddMethod("error", "_LogError")
		.AddMethod("fatal", "_LogError")
		.AddDestructor("_LogClose")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("logHandle", $ELSCOPE_PRIVATE, $hLastLogHandle)
		.AddProperty("fileName", $ELSCOPE_PRIVATE, $sFileName)
		.AddProperty("level", $ELSCOPE_PRIVATE, $iLevel)
		.AddProperty("format", $ELSCOPE_PRIVATE, $fLogFormat)
		.AddProperty("levelsString", $ELSCOPE_PRIVATE, $LOG_LEVELSTRING)
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>Logger

#Region Methods
;Function: _GetLevel
;Gets the actual log level.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;	String. The actual level.
Func _GetLevel($oSelf)
	Return $oSelf.levelsString[$oSelf.level]
EndFunc   ;==>_GetLevel

;Function: _LogLevel
;Sets the log level. Looger supports 6 logging levels: TRACE, DEBUG , INFO, WARNING , ERROR and FATAL.
;The default logging level is INFO. This means that only log entries with the logging level INFO and higher are output.
;
;Parameters:
;	$iLevel - Int. The log level. $LOG_TRACE = 0, $LOG_DEBUG = 1 $LOG_INFO = 2, $LOG_WARN = 3, $LOG_ERROR = 4, $LOG_FATAL = 5.
Func _LogLevel($oSelf, $iLevel)
	$oSelf.level = $iLevel
EndFunc   ;==>_LogLevel

;Function: _LogFormat
;Sets the log lormat .
;
;Parameters:
;   $oSelf - Object reference.
;	$fFormatFunc - Function. The function with the format.
Func _LogFormat($oSelf, $fFormatFunc)
	$oSelf.format = $fFormatFunc
EndFunc   ;==>_LogFormat

;Function: _LogTrace
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogTrace($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_TRACE, $sMessage)
EndFunc   ;==>_LogTrace

;Function: _LogDebug
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogDebug($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_DEBUG, $sMessage)
EndFunc   ;==>_LogDebug

;Function: _LogInfo
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogInfo($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_INFO, $sMessage)
EndFunc   ;==>_LogInfo

;Function: _LogWarn
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogWarn($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_WARN, $sMessage)
EndFunc   ;==>_LogWarn

;Function: _LogError
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogError($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_ERROR, $sMessage)
EndFunc   ;==>_LogError

;Function: _LogFatal
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogFatal($oSelf, $sMessage)
	_LogMessage($oSelf, $LOG_FATAL, $sMessage)
EndFunc   ;==>_LogFatal

;Function: _LogMessage.
;
;Parameters:
;   $oSelf - Object reference.
;	$iLevel - Int. The log level. Default is INFO.
;	$sMessage -String. The message to log. Default is "".
Func _LogMessage($oSelf, $iLevel = $LOG_INFO, $sMessage = "")
	If ($iLevel < $oSelf.level) Then
		Return
	EndIf

	Local $sLevel = __LogLevelToString($oSelf, $iLevel)
	If @error Then
		ConsoleWriteError("Invalid log level given!")
		Return SetError(2, 0, -1)
	EndIf

	Local $fFormat = $oSelf.format
	$sMessage = $fFormat($sLevel, $sMessage)

	If $iLevel >= $LOG_ERROR Then
		ConsoleWriteError($sMessage & @CRLF)
	Else
		ConsoleWrite($sMessage & @CRLF)
	EndIf

	If ($oSelf .logHandle <> -1) Then
		FileWriteLine($oSelf .logHandle, $sMessage)
	EndIf
EndFunc   ;==>_LogMessage

;Function: _LogMessageUnformatted
;
;Parameters:
;   $oSelf - Object reference.
;	$sMessage -String. The message to log.
Func _LogMessageUnformatted($oSelf, $sMessage)
	ConsoleWrite($sMessage & @CRLF)

	If ($oSelf .logHandle <> -1) Then
		FileWriteLine($oSelf .logHandle, $sMessage)
	EndIf
EndFunc   ;==>_LogMessageUnformatted

;Function: _LogLevelToString
;
;Parameters:
;   $oSelf - Object reference.
;	$iLevel - Int. The log level.
;
;Returns:
;	String. The log level.
Func __LogLevelToString($oSelf, $iLevel)
	If $iLevel < 0 Or $iLevel > UBound($oSelf.levelsString) - 1 Then
		Return SetError(1, 0, "")
	EndIf

	Return $oSelf.levelsString[$iLevel]
EndFunc   ;==>__LogLevelToString

;Function: _LogClose
;
;Parameters:
;   $oSelf - Object reference.
Func _LogClose($oSelf)
	If ($oSelf .logHandle <> -1) Then
		FileClose($oSelf.logHandle)
	EndIf
	$oSelf.logHandle = -1
	#forceref $oSelf
EndFunc   ;==>_LogClose

;Function: _LogFormatDefault
;
;Parameters:
;	$iLevel - Int. The log level.
;	$sMessage -String. The message to log.
;
;Returns:
;	String. The  message with the default format.
Func _LogFormatDefault($sLevel, $sMessage)
	If (IsArray($sMessage)) Then
		$sMessage = _ArrayToString($sMessage)
	EndIf
	Return "[" & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " " & $sLevel & "] " & $sMessage
EndFunc   ;==>_LogFormatDefault
#EndRegion Methods
