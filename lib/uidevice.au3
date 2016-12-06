;uidevice.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; UiDevice provides access to state information about the device.
; You can also use this class to simulate user actions on the device,
; such as click over a widget or pressing the Home and Menu buttons.

;Function: UiDevice
;
;Parameters:
;   $oServer - Objetc An ImperiusServer instance.
;	$sDevice- String. The device serial id.Default is empty.
;	$oLogger - Object. A Looger instance. Defualt is empty.
;
;Returns:
;   Object. An UiDevice instance.
Func UiDevice($oServer, $sDeviceId = "", $oLogger = "")
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("getDeviceID", "_GetDeviceID")
		.AddMethod("getServer", "_GetServer")
		.AddMethod("click", "_Click")
		.AddMethod("clickAndWait", "_ClickAndWait")
		.AddMethod("clickBiggestButton", "_ClickBiggestButton")
		.AddMethod("enterText", "_EnterText")
		.AddMethod("waitUntilPartialTextExist", "_WaitUntilPartialTextExist")
		.AddMethod("waitForTextExist", "_WaitForTextExist")
		.AddMethod("waitUntilViewWithExactTextExists", "_WaitUntilViewWithExactTextExists")
		.AddMethod("swipeRelative", "_SwipeRelative")
		.AddMethod("delay", "_Delay")
		.AddMethod("openNotificationBar", "_OpenNotificationBar")
		.AddMethod("getScreenshot", "_GetScreenshot")
		.AddMethod("getCurrentTopActivity", "_GetCurrentTopActivity")
		.AddMethod("getDump", "_GetDump")
		.AddMethod("getActivityName", "_GetActivityName")
		.AddMethod("getDeviceName", "_GetDeviceName")
		.AddMethod("getVersion", "_GetVersion")
		.AddMethod("getDeviceVersion", "_GetDeviceVersion")
		.AddMethod("getDeviceManufacturer", "_GetDeviceManufacturer")
		.AddMethod("getDeviceModel", "_GetDeviceModel")
		.AddMethod("getPackages", "_GetPackages")
		.AddMethod("launchBrowser", "_LaunchBrowser")
		.AddMethod("launchDeepLink", "_LaunchDeepLink")
		.AddMethod("startActivity", "_StartActivity")
		.AddMethod("clearPackage", "_ClearPackage")
		.AddMethod("stopPackage", "_StopPackage")
		.AddMethod("sendKeyEvent", "_SendKeyEvent")
		.AddMethod("pressPower", "_PressPower")
		.AddMethod("pressBack", "_PressBack")
		.AddMethod("pressHome", "_PressHome")
		.AddMethod("pressMenu", "_PressMenu")
		.AddMethod("pressTab", "_PressTab")
		.AddMethod("pressEnter", "_PressEnter")
		.AddMethod("pressAppMenu", "_PressAppMenu")
		.AddMethod("tap", "_Tap")
		.AddMethod("longPress", "_LongPress")
		.AddMethod("setBatteryLevel", "_SetBatteryLevel")
		.AddMethod("setBatteryStatus", "_SetBatteryStatus")
		.AddMethod("batteryReset", "_BatteryReset")
		.AddMethod("writeServerLog", "_WriteServerLog")
		.AddMethod("getServerLog", "_GetServerLog")
		.AddMethod("clearServerLog", "_ClearServerLog")
		.AddMethod("shell", "_Shell")
		.AddMethod("stop", "_Stop")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("deviceID", $ELSCOPE_PRIVATE, $sDeviceId)
		.AddProperty("lastMethod", $ELSCOPE_PRIVATE, "")
		.AddProperty("oServer", $ELSCOPE_PRIVATE, $oServer)
		.AddProperty("oLogger", $ELSCOPE_PRIVATE, $oLogger)
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>UiDevice

#Region Getters
;Function: _GetDeviceID
;Gets the serial device.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;   String. The serial device.
Func _GetDeviceID($oSelf)
	Return $oSelf.deviceID
EndFunc   ;==>_GetDeviceID

;Function: _GetServer
;Gets the ImperiusServer instance.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;  String. The ImperiusServer instance.
Func _GetServer($oSelf)
	Return $oSelf.oServer
EndFunc   ;==>_GetServer
#EndRegion Getters

#Region UIActionsMethods
;Function: _Click
;Perform a click over an element with the given text.
;
;Parameters:
;   $oSelf - Object reference.
;  	$sText  - String. The element text.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _Click($oSelf, $sText)
	Local $sMethod = "clickIfExactExists"
	Local $sParam = '["' & $sText & '"]'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_Click

;Function: _ClickAndWait
;Click and wait for new window if this text item exists.
;
;Parameters:
;   $oSelf - Object reference.
;  	$sText  - String. The element text.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _ClickAndWait($oSelf, $sText)
	Local $sMethod = "clickAndWaitForNewWindow"
	Local $sParam = '["' & $sText & '"]'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_ClickAndWait

;Function: _ClickBiggestButton
;Click the biggest button on the screen.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _ClickBiggestButton($oSelf)
	Local $sMethod = "clickBiggestButton"
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod)
	Return _ResponseOK($oSelf, $sResponse)
EndFunc   ;==>_ClickBiggestButton

;Function: _EnterTex
;Enter a given text into an input field.
;
;Parameters:
;   $oSelf - Object reference.
;   $iIndex - Int. The input index.
;   $sText -  String. The text to enter.
Func _EnterText($oSelf, $iIndex, $sText)
	Local $sMethod = "enterText"
	Local $sParam = '[' & $iIndex & ', "' & $sText & '"]'
	_ExecuteUIHelp($oSelf, $sMethod, $sParam)
EndFunc   ;==>_EnterText

;Function: _WaitUntilPartialTextExist
;Waits for a component to become visible with the partial given text.
;
;Parameters:
;   $oSelf - Object reference.
;   $sText - String. The element text.
;  $iTimeout -  Int. Milliseconds to wait before giving up and failing the command.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _WaitUntilPartialTextExist($oSelf, $sText, $iTimeout)
	Local $sMethod = "waitUntilViewWithPartialTextExists"
	Local $sParam = '["' & $sText & '", ' & $iTimeout & ']'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_WaitUntilPartialTextExist

;Function: _WaitForTextExist
;Waits for a component to become visible with the exact given text.
;Uses the default timeout in the server connection instance.
;
;Parameters:
;   $oSelf - Object reference.
;   $sText - String. The element text.
;
;Returns:
;  Boolean Success: True Failure: False.
Func _WaitForTextExist($oSelf, $sText)
	Return _WaitUntilExactTextExists($oSelf, $sText, $oSelf.getServer().getTimeout())
EndFunc   ;==>_WaitForTextExist

;Function: _WaitUntilExactTextExists
;Waits for a component to become visible with the exact given text.
;
;Parameters:
;   $oSelf - Object reference.
;   $sText - String. The element text.
;   $iTimeout -  Int. Milliseconds to wait before giving up and failing the command.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _WaitUntilExactTextExists($oSelf, $sText, $iTimeout)
	Local $sMethod = "waitUntilExactTextExists"
	Local $sParam = '[["' & $sText & '"], ' & $iTimeout & ']'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_WaitUntilExactTextExists

;Function: _WaitUntilViewWithExactTextExists
;Waits for a component view to become visible with the exact given text.
;
;Parameters:
;   $oSelf - Object reference.
;   $sText - String. The element text.
;   $iTimeout -  Int. Milliseconds to wait before giving up and failing the command.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _WaitUntilViewWithExactTextExists($oSelf, $sText, $iTimeout)
	Local $sMethod = "waitUntilViewWithExactTextExists"
	Local $sParam = '["' & $sText & '", ' & $iTimeout & ']'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_WaitUntilViewWithExactTextExists

;Function: _SwipeRelative
;Swipes relative to the device screen size (0,0 top left, 1,1 bottom right).
;
;Parameters:
;   $oSelf - Object reference.
;   $iX - Int. x coordinate.
;   $iY - Int. y coordinate.
;   $iXend - Int. x end coordinate.
;   $iYend - Int.  y end coordinate.
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _SwipeRelative($oSelf, $iX, $iY, $iXend, $iYend)
	Local $sMethod = "swipeRelative"
	Local $sParam = '[' & $iX & ',' & $iY & ',' & $iXend & ',' & $iYend & ']'
	Local $sResponse = _ExecuteUIHelp($oSelf, $sMethod, $sParam)
	Local $bResult = _ResponseOK($oSelf, $sResponse)
	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_SwipeRelative

;Function: _Deleay
; Suspend execution for a specified period.
;
;Parameters:
;   $oSelf - Object reference.
;   $iTimeout - Int. The sleep time (millisecond).
Func _Delay($oSelf, $iTimeout)
	Local $sMethod = "delay"
	Local $sParam = '[' & $iTimeout & ']'
	_ExecuteUIHelp($oSelf, $sMethod, $sParam)
EndFunc   ;==>_Delay

;Function: _OpenNotificationBar
;Opens the Notification Bar.
;
;Parameters:
;   $oSelf - Object reference.
Func _OpenNotificationBar($oSelf)
	Local $sMethod = "openNotificationBar"
	_ExecuteUIHelp($oSelf, $sMethod)
EndFunc   ;==>_OpenNotificationBar

;Function: _GetScreenshot
;Take a screenshot and save to a PNG file.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sLocalFile - String.  The path to the destination (local) file (without the extension file).Defaul is @ScriptDir & "\screen.png".
;
;Returns:
;  Boolean Success: True Failure: False and set the value of the @error.
Func _GetScreenshot($oSelf, $sLocalFile = @ScriptDir & "\screen.png")
	Local $sMethod = "getScreenshot"
	Local $sRemoteScreenshot = _ExecuteUIHelp($oSelf, $sMethod)
	Local $bResult = _ResponseOK($oSelf, $sRemoteScreenshot)

	If ($bResult == False) Then
		Return SetError(@error, @extended, $bResult)
	EndIf

	$sRemoteScreenshot = StringReplace($sRemoteScreenshot, "\", "")
	$sRemoteScreenshot = StringReplace($sRemoteScreenshot, '"', '')
	$oSelf.getServer().getAdb().pull($sRemoteScreenshot, $sLocalFile)
	_Shell($oSelf, 'rm ' & $sRemoteScreenshot)
	Return True
EndFunc   ;==>_GetScreenshot

;Function: _GetCurrentTopActivity
;Gets the current top activity.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;  String. The current top activity.
Func _GetCurrentTopActivity($oSelf)
	Local $sMethod = "getCurrentTopActivity"
	Local $sResult = _ExecuteUIHelp($oSelf, $sMethod)
	Return StringReplace($sResult, '"', '')
EndFunc   ;==>_GetCurrentTopActivity

;Function: _GetActivityName
;Gets the current top activity.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; String. The current activity.
Func _GetActivityName($oSelf)
	Local $sMethod = "getActivityName"
	Local $sResult = _ExecuteUIHelp($oSelf, $sMethod)
	Return StringReplace($sResult, '"', '')
EndFunc   ;==>_GetActivityName

;Function: _GetDeviceName
;Gets the device name.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; String. The device name.
Func _GetDeviceName($oSelf)
	Local $sMethod = "getDeviceName"
	Return _ExecuteUIHelp($oSelf, $sMethod)
EndFunc   ;==>_GetDeviceName

;Function: _ClearPackage
;Clear application data.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String.The package.
;
;Returns:
; 	Boolean Success: True Failure: False and set the value of the @error.
Func _ClearPackage($oSelf, $sPackage)
	Local $sCommand = "pm clear " & $sPackage
	Local $sResponse = _Shell($oSelf, $sCommand)
	Return (StringInStr($sResponse, "Success") <> 0) ? True : SetError(2, 0, False)
EndFunc   ;==>_ClearPackage

;Function: _GetPackage
;Gets all installed packages.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String. The package.
;
;Returns:
; 	Array. All installed packages.
Func _GetPackages($oSelf)
	Local $sCommand = "pm list packages -f"
	Local $sResponse = _Shell($oSelf, $sCommand)
	Return __ParserPackages($sResponse)
EndFunc   ;==>_GetPackages

;Function: _SendKeyEvent
;Sends a KeyEvent.
;
;Parameters:
;   $oSelf - Object reference.
; 	$iKeycode - Int. An event code.
Func _SendKeyEvent($oSelf, $iKeycode)
	Local $sCommand = "input keyevent " & $iKeycode
	_Shell($oSelf, $sCommand)
EndFunc   ;==>_SendKeyEvent

;Function: _PressPower
;Sends the power button event to turn the device on or off.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressPower($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_POWER)
EndFunc   ;==>_PressPower

;Function: _PressBack
;Presses the Back button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressBack($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_BACK)
EndFunc   ;==>_PressBack

;Function: _PressMenu
;Presses the Menu button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressMenu($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_SOFT_LEFT)
EndFunc   ;==>_PressMenu

;Function: _PressHome
;Presses the Home button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressHome($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_HOME)
EndFunc   ;==>_PressHome

;Function: _PressTab
;Presses the Tab button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressTab($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_TAB)
EndFunc   ;==>_PressTab

;Function: _PressEnter
;Presses the Enter button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressEnter($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_ENTER)
EndFunc   ;==>_PressEnter

;Function: _PressAppMenu
;Presses the App Menu button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressAppMenu($oSelf)
	_SendKeyEvent($oSelf, $KEYCODE_MENU)
EndFunc   ;==>_PressAppMenu

;Function: _Tap
;
;Parameters:
;   $oSelf - Object reference.
;	$iX -Int. x-coordinate of the tap.
;	$iY -Int. y-coordinate of the tap.
Func _Tap($oSelf, $iX, $iY)
	_Shell($oSelf, "input tap " & $iX & " " & $iY)
EndFunc   ;==>_Tap

;Function: _LongPress
;
;Parameters:
;   $oSelf - Object reference.
;	$iX - Int. x-coordinate.
;	$iY - Int. y-coordinate.
Func _LongPress($oSelf, $iX, $iY)
	Local $iDuration = 250 ;(ms)
	_Shell($oSelf, "input swipe " & $iX & " " & $iY & " " & $iX & " " & $iY & " " & $iDuration)
EndFunc   ;==>_LongPress

;Function: _Shell
;Execute a shell command on the device.
;
;Parameters:
;   $oSelf - Object reference.
;	$sCommand   String The command to execute on the device.
;
;Returns:
; 	String .The command output.
Func _Shell($oSelf, $sCommand)
	Local $sMethod = "shell"
	Local $sParam = '["' & $sCommand & '"]'
	Return _ExecuteUIHelp($oSelf, $sMethod, $sParam)
EndFunc   ;==>_Shell

;Function: _ResponseOK
;Checks if the server response has an error.
;
;Parameters:
;   $oSelf - Object reference.
;	$sRespose  - String. The Imperius server response.
;
;Returns:
; 	Boolean.
Func _ResponseOK($oSelf, $sResponse)
	Local $aErrors[4]
	$aErrors[0] = "Error"
	$aErrors[1] = "AssertionError"
	$aErrors[2] = "NoSuchMethodError"
	$aErrors[3] = "UiObjectNotFoundException"

	For $i = 0 To UBound($aErrors) - 1
		If (StringInStr($sResponse, $aErrors[$i])) Then
			If (IsObj($oSelf.oLogger)) Then
				$oSelf.oLogger.error("[UiDevice] Response: " & $sResponse & " Error:" & $aErrors[$i])
			EndIf
			Return SetError(2, 0, False)
		EndIf
	Next
	Return True
EndFunc   ;==>_ResponseOK
#EndRegion UIActionsMethods

#Region GetPropMethods
;Function: _GetDeviceVersion
;Gets the device version.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; String. The android version (format: build.version.release).
Func _GetDeviceVersion($oSelf)
	Local $sCommand = "getprop ro.build.version.release"
	Return StringReplace(_Shell($oSelf, $sCommand), "\n", "")
EndFunc   ;==>_GetDeviceVersion

;Function: _GetDeviceManufacturer
;Gets the device manufacturer.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; String. The device manufacturer.
Func _GetDeviceManufacturer($oSelf)
	Local $sCommand = "getprop ro.product.manufacturer"
	Return StringReplace(_Shell($oSelf, $sCommand), "\n", "")
EndFunc   ;==>_GetDeviceManufacturer

;Function: _GetDeviceModel
;Gets the device model.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; String. The device model.
Func _GetDeviceModel($oSelf)
	Local $sCommand = "getprop ro.product.model"
	Return StringReplace(_Shell($oSelf, $sCommand), "\n", "")
EndFunc   ;==>_GetDeviceModel
#EndRegion GetPropMethods

#Region LogMethods
;Function: _WriteServerLog
;Writes in the the server log.
;
;Parameters:
;   $oSelf - Object reference.
;	$oText - String. The text to write.
Func _WriteServerLog($oSelf, $sText)
	Local $sMethod = "log"
	Local $sParam = '["' & $sText & '"]'
	_ExecuteUIHelp($oSelf, $sMethod, $sParam)
EndFunc   ;==>_WriteServerLog

;Function: _GetServerLog
;Gets the server execution logs.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; 	String. The server execution logs.
Func _GetServerLog($oSelf)
	Local $sMethod = "exportLogs"
	Return _ExecuteUIHelp($oSelf, $sMethod)
EndFunc   ;==>_GetServerLog

;Function: _ClearServerLog
;Clears the server execution logs.
;
;Parameters:
;   $oSelf - Object reference.
Func _ClearServerLog($oSelf)
	Local $sMethod = "clearLogs"
	_ExecuteUIHelp($oSelf, $sMethod)
EndFunc   ;==>_ClearServerLog
#EndRegion LogMethods

#Region BatteryMethods
;Function: _SetBatteryLevel
;Change the battery level.
;
;Parameters:
;   $oSelf - Object reference.
;	$iLevel - Int.Level of the battery. 0 to 100.
Func _SetBatteryLevel($oSelf, $iLevel)
	_Shell($oSelf, "dumpsys battery set level " & $iLevel)
EndFunc   ;==>_SetBatteryLevel

;Function: _SetBatteryStatus
;Change the battery status.
;
;Parameters:
;   $oSelf - Object reference.
;	$iLevel - Int.Status of the battery. Should be on of these:
;   - 1 = Unknown.
;	- 2 = Charging.
;	- 3 = Descharging.
;	- 4 = Not charging.
;	- 5 = Full.
Func _SetBatteryStatus($oSelf, $iStatus)
	_Shell($oSelf, "dumpsys battery set status " & $iStatus)
EndFunc   ;==>_SetBatteryStatus

;Function: _BatteryReset
;The first time you invoke one of SetBattery functions, the device stops getting information
;from real hardware. Hence, do not forget to finish your gambling executing this function in order to
;get our device back to earth.
;
;Parameters:
;   $oSelf - Object reference.
;	$iLevel - Int.Level of the battery. 0 to 100.
Func _BatteryReset($oSelf)
	_Shell($oSelf, "dumpsys battery reset")
EndFunc   ;==>_BatteryReset
#EndRegion BatteryMethods

#Region ActivityManagerMethods
;Function: _LaunchBrowser
;Launch the default browser at an URL.
;
;Parameters:
;   $oSelf - Object reference.
;   $sUrl  - String. The URL to open.
;
;Returns:
; 	Boolean Success: True Failure: False and set the value of the @error.
Func _LaunchBrowser($oSelf, $sUrl)
	Local $sCommand = "am start -a android.intent.action.VIEW -d " & $sUrl
	Local $sResponse = _Shell($oSelf, $sCommand)
	Return (StringInStr($sResponse, "Starting:") <> 0) ? True : SetError(2, 0, False)
EndFunc   ;==>_LaunchBrowser

;Function: _LaunchDeepLink
;You can use this mehtod to test that the intent filter URIs you specified for
;deep linking resolve to the correct app activity.
;See <https://developer.android.com/training/app-indexing/deep-linking.html>
;
;Parameters:
;   $oSelf - Object reference.
;   $sUrl  - String. The URL to open.
;	$sPackage - String. The app package.
;
;Returns:
; 	String. Success: The open activity. Failure: empty
Func _LaunchDeepLink($oSelf, $sUrl, $sPackage)
	Local $sCommand = "am start -W -a android.intent.action.VIEW -d " & $sUrl & " " & $sPackage
	Local $sResponse = StringReplace(_Shell($oSelf, $sCommand), "\n", "")
	Local $aActivity = StringRegExp($sResponse, "Activity:(?s)(.*?)ThisTime", 1)
	If @error Then Return ""
	Return $aActivity[0]
EndFunc   ;==>_LaunchDeepLink

;Function: _StartActivity
;Start an activity.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String. The package.
;	$sActivity  - String. The activity.
Func _StartActivity($oSelf, $sPackage, $sActivity)
	Local $sCommand = "am start " & $sPackage & "/" & $sActivity
	_Shell($oSelf, $sCommand)
EndFunc   ;==>_StartActivity

;Function: _StopPackage
;Force stop everything associated with the given package.
;
;Parameters:
;   $oSelf - Object reference.
; 	$sPackage - String. The package.
Func _StopPackage($oSelf, $sPackage)
	Local $sCommand = "am force-stop " & $sPackage
	_Shell($oSelf, $sCommand)
EndFunc   ;==>_StopPackage
#EndRegion ActivityManagerMethods

#Region UtilMethods
;Function: _GetVersion
;Gets the Imperius server version.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; 	String. The Imperius server version.
Func _GetVersion($oSelf)
	Local $sMethod = "version"
	Return _ExecuteUtil($oSelf, $sMethod)
EndFunc   ;==>_GetVersion

;Function: _GetDump
;Gets a dump of views.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
; 	String.  A dump of views.
Func _GetDump($oSelf)
	Local $sMethod = "dump"
	Return _ExecuteUtil($oSelf, $sMethod)
EndFunc   ;==>_GetDump

;Function: _Stop
;Terminating a server session.
;
;Parameters:
;   $oSelf - Object reference.
Func _Stop($oSelf)
	Local $sMethod = "terminate"
	_ExecuteUtil($oSelf, $sMethod)
EndFunc   ;==>_Stop
#EndRegion UtilMethods

#Region ParsersMethods
;TODO: Add Regular expresiones

;Function:  __ParserPackages
;Parse the _GetPackages return.
;
;Parameters:
;	$sPackages  - String. The _GetPackages return.
;
;Returns:
; 	Array. An array with the packages.
Func __ParserPackages($sPackages)
	$sPackages = StringReplace(StringReplace($sPackages, "\/", "/"), "package", "")
	$sPackages = StringReplace($sPackages, "\n", "")
	$sPackages = StringTrimLeft($sPackages, 1)
	Return StringSplit($sPackages, ":")
EndFunc   ;==>__ParserPackages
#EndRegion ParsersMethods

#Region ExecutorsMethods
;Function:  _ExecuteUIHelp
;Execute an UIHelp method.
;
;Parameters:
;   $oSelf - Object reference.
;	$sMethod  - String. The method name.Default is empty.
;	$sParam - String . Method parameters. Default is "[]".
;
;Returns:
; 	String.  The Imperius server response.
Func _ExecuteUIHelp($oSelf, $sMethod = "", $sParam = '[]')
	$oSelf.lastMethod = $sMethod
	Local $sUrl = $oSelf.getServer().getUrl() & 'execute'
	$sUrl = $sUrl & "?on=imperiusgeorge.UIHelp&method=" & $sMethod & "&args=" & $sParam
	Return _ExecuteGet($oSelf, $sUrl)
EndFunc   ;==>_ExecuteUIHelp

;Function:  _ExecuteUtil
;Execute an util method.
;
;Parameters:
;   $oSelf - Object reference.
;	$sMethod  - String. The method name.
;
;Returns:
; 	String.  The Imperius server response.
Func _ExecuteUtil($oSelf, $sMethod)
	$oSelf.lastMethod = $sMethod
	Local $sUrl = $oSelf.getServer().getUrl() & $sMethod
	Return _ExecuteGet($oSelf, $sUrl)
EndFunc   ;==>_ExecuteUtil

;Function:  _ExecuteGet
;Send a HTTP GET request to a URL.
;
;Parameters:
;   $oSelf - Object reference.
;	$sMethod  - String. The URL to query, including the get parameters.
;
;Returns:
; 	String. The Imperius server response.
Func _ExecuteGet($oSelf, $sUrl)
	Local $oErrorHandler = ObjEvent("AutoIt.Error", "_Err")
	Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	Local $sReceived = ""
	$oHTTP.Open("GET", $sUrl, False)
	$oHTTP.Send()

	$sReceived = $oHTTP.ResponseText
	Local $oStatusCode = $oHTTP.Status

	If $oStatusCode <> 200 Then
		;We need this last method check because a bug on the Server#Terminate method.
		;See: https://github.com/lookout/ImperiusGeorge/blob/master/src/imperiusgeorge/backend/Server.java#L46
		If ($oSelf.lastMethod <> "terminate") Then
			If (IsObj($oSelf.oLogger)) Then
				$oSelf.oLogger.error("[UiDevice] URL: " & $sUrl & " Status Code:" & $oStatusCode)
			EndIf
		EndIf
	Else
		If (IsObj($oSelf.oLogger)) Then
			$oSelf.oLogger.info("[UiDevice] URL: " & $sUrl & " Response: " & $sReceived)
		EndIf
	EndIf
	Return $sReceived
EndFunc   ;==>_ExecuteGet

Func _Err($oSelf, $oError)
	If (IsObj($oSelf.oLogger)) Then
		$oSelf.oLogger.error("[UiDevice] Line: " & $oError.scriptline & " Description :" & $oError.description)
	EndIf
EndFunc   ;==>_Err
#EndRegion ExecutorsMethods


