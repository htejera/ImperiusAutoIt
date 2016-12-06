;inputsScreen.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; This object represents the InputsScreen screen of the AUT (activity .InputsScreen)

;Function: InputsScreen
;
;Parameters:
;	$oDevice- Object. An UiDevice instance.
;
;Returns:
;   Object. An InputsScreen instance.
Func InputsScreen($oDevice)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("writeName", "_WriteName")
		.AddMethod("writePassword", "_WritePassword")
		.AddMethod("pressAdd", "_PressAdd")
		.AddMethod("back", "_Back")
		.AddMethod("waitForReady", "_WaitForReady")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("oDevice", $ELSCOPE_PRIVATE, $oDevice)
		.AddProperty("inputName", $ELSCOPE_PRIVATE, 0)
		.AddProperty("inputPassword", $ELSCOPE_PRIVATE, 1)
		.AddProperty("buttonAdd", $ELSCOPE_PRIVATE, "Add")
		.AddProperty("buttonBack", $ELSCOPE_PRIVATE, "Back")
		.AddProperty("textReady", $ELSCOPE_PRIVATE, "Ready")
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>InputsScreen

#Region Methods
;Function: _WriteName
;Enter the given text in the "Name" input.
;
;Parameters:
;   $oSelf - Object reference.
;	$sName - String. The name.
Func _WriteName($oSelf, $sName)
	$oSelf.oDevice.enterText($oSelf.inputName, $sName)
EndFunc   ;==>_WriteName

;Function: _WritePassword
;Enter the given text in the "Password" input.
;
;Parameters:
;   $oSelf - Object reference.
;	$sPassword - String. The password.
Func _WritePassword($oSelf, $sPassword)
	$oSelf.oDevice.enterText($oSelf.inputPassword, $sPassword)
EndFunc   ;==>_WritePassword

;Function: _PressAdd
;Presses the Add button.
;
;Parameters:
;   $oSelf - Object reference.
Func _PressAdd($oSelf)
	$oSelf.oDevice.click($oSelf.buttonAdd)
EndFunc   ;==>_PressAdd

;Function: _Back
;Presses the Back button.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;	Object. A DashboardScreen instance.
Func _Back($oSelf)
	$oSelf.oDevice.click($oSelf.buttonBack)
	Return DashboardScreen($oSelf.oDevice)
EndFunc   ;==>_Back

;Function: _WaitForReady
;
;Parameters:
;   $oSelf - Object reference.
Func _WaitForReady($oSelf)
	$oSelf.oDevice.waitForTextExist($oSelf.textReady)
EndFunc   ;==>_WaitForReady
#EndRegion Methods