;imperius.server.au3
;
;Author:
; henrytejera@gmail.com

Global Const $IMPERIUSSERVERJAR = "imperiusserver.1.0.1.jar"

;Function: ImperiusServer
;An ImperiusServer connection data.
;
;Parameters:
;	$sIP - String. The Imperius server IP. Default is locahost.
;	$iPort - Int.  The Imperius server port. Default is 7120.
;	$sDeviceId - String. The serial deviceID. Can be empty if only have one device. Deafuls is "".
;	$sLocalServerPath - String. The full path to the test.jar. Default is @ScriptDir & "\imperiusserver.jar".
;	$iTimeout - Int. Timeout (miliseconds). Default is 30000.
;
;Returns:
;   Object. An ImperiusServer instance.
Func ImperiusServer($sIP = "localhost", $iPort = 7120, $sDeviceID = "", $sLocalServerPath = @ScriptDir & "\" & $IMPERIUSSERVERJAR, $iTimeout = 30000)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()
	Local $oDevice = ""
	Local $oLogger = Logger()
	$oLogger.setLevel($LOG_INFO)
	Local $oAdb = Adb($sDeviceID, $oLogger)

	;Methods
	With $oClassObject
		.AddMethod("getIP", "_GetIP")
		.AddMethod("getPort", "_GetPort")
		.AddMethod("getTimeout", "_GetTimeout")
		.AddMethod("getUrl", "_GetUrl")
		.AddMethod("getServerPath", "_GetServerPath")
		.AddMethod("getDeviceID", "__GetDeviceID")
		.AddMethod("getDevice", "_GetDevice")
		.AddMethod("getAdb", "_GetAdb")
		.AddMethod("getLogger", "_GetLogger")
		.AddMethod("start", "_StartServer")
		.AddMethod("stop", "_StopServer")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("ip", $ELSCOPE_PRIVATE, $sIP)
		.AddProperty("port", $ELSCOPE_PRIVATE, $iPort)
		.AddProperty("timeout", $ELSCOPE_PRIVATE, $iTimeout)
		.AddProperty("path", $ELSCOPE_PRIVATE, $sLocalServerPath)
		.AddProperty("deviceID", $ELSCOPE_PRIVATE, $sDeviceID)
		.AddProperty("remotePath", $ELSCOPE_PRIVATE, "/data/local/tmp/" & $IMPERIUSSERVERJAR)
		.AddProperty("oDevice", $ELSCOPE_PRIVATE, $oDevice)
		.AddProperty("oAdb", $ELSCOPE_PRIVATE, $oAdb)
		.AddProperty("oLogger", $ELSCOPE_PRIVATE, $oLogger)
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>ImperiusServer

#Region Getters
;Function: _GetIP
;Gets the server IP.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   String. The server IP.
Func _GetIP($oSelf)
	Return $oSelf.ip
EndFunc   ;==>_GetIP

;Function: _GetPort
;Gets the server Port.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   Int. The server port.
Func _GetPort($oSelf)
	Return $oSelf.port
EndFunc   ;==>_GetPort

;Function: _GetTimeout
;Gets the server timeout.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   Int. The server timeout (miliseconds).
Func _GetTimeout($oSelf)
	Return $oSelf.timeout
EndFunc   ;==>_GetTimeout

;Function: _GetURL
;Gets the URL.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   String. The server URL.
Func _GetUrl($oSelf)
	Return 'http://' & $oSelf.ip & ':' & $oSelf.port & '/'
EndFunc   ;==>_GetUrl

;Function: _GetServerPath
;Gets the local full path to the server JAR file.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   String. The server local full path.
Func _GetServerPath($oSelf)
	Return $oSelf.path
EndFunc   ;==>_GetServerPath

;Function: _GetDeviceID
;Gets the serial device.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   String. The serial device.
Func __GetDeviceID($oSelf)
	Return $oSelf.deviceID
EndFunc   ;==>_GetDeviceID

;Function: _GetDevice
;Gets the UiDevice instance.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   Object. An UiDevice instance.
Func _GetDevice($oSelf)
	If (IsString($oSelf.oDevice)) Then
		$oSelf.oDevice = UiDevice($oSelf, $oSelf.deviceID, $oSelf.oLogger)
	EndIf
	Return $oSelf.oDevice
EndFunc   ;==>_GetDevice

;Function: _GetAdb
;Gets the adb instance.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   Object. An Adb instance.
Func _GetAdb($oSelf)
	Return $oSelf.oAdb
EndFunc   ;==>_GetAdb

;Function: _GetLogger
;Gets the Logger instance.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   Object. A Logger instance.
Func _GetLogger($oSelf)
	Return $oSelf.oLogger
EndFunc   ;==>_GetLogger
#EndRegion Getters

#Region ServerManagement
;Function: _StartServer
;Start an Imperius server session on the device.
;
;Parameters:
;   $oSelf - Object reference.
Func _StartServer($oSelf)
	Local $iPort = $oSelf.port
	Local $sCommand = "uiautomator runtest " & $IMPERIUSSERVERJAR & " -c imperiusgeorge.TestServer -e port " & $iPort
	Local $oAdb = $oSelf.oAdb
	$oAdb.connect()

	If ($oAdb.fileExists($oSelf.remotePath) == False) Then
		$oAdb.push($oSelf.path, $oSelf.remotePath)
	EndIf

	With $oAdb
		.forward($iPort, $iPort)
		.shell($sCommand)
	EndWith
EndFunc   ;==>_StartServer

;Function: _StopServer
;Terminating a server session.
;
;Parameters:
;   $oSelf - Object reference.
Func _StopServer($oSelf)
	$oSelf.oDevice.stop()
EndFunc   ;==>_StopServer
#EndRegion ServerManagement
