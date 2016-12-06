;dashboardScreen.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; This object represents the Dashboard screen of the AUT (activity .Screen1)

;Function: DashboardScreen
;
;Parameters:
;	$oDevice- Object. An UiDevice instance.
;
;Returns:
;   Object. An DashboardScreen instance.
Func DashboardScreen($oDevice)
	Local $oClassObject = _AutoItObject_Class()
	$oClassObject.Create()

	;Methods
	With $oClassObject
		.AddMethod("pressInputsScreen", "_PressInputsScreen")
		.AddMethod("waitForScreen", "_WaitForScreen")
	EndWith

	;Properties
	With $oClassObject
		.AddProperty("oDevice", $ELSCOPE_PRIVATE, $oDevice)
		.AddProperty("buttonInputs", $ELSCOPE_PRIVATE, "Inputs Screen")
		.AddProperty("textTitle", $ELSCOPE_PRIVATE, "ImperiusGeorge")
	EndWith

	Return $oClassObject.Object
EndFunc   ;==>DashboardScreen

#Region Methods
;Function: _PressInputsScreen
;Presses the "Inputs Screen" button.
;
;Parameters:
;   $oSelf - Object reference.
;
;Returns:
;	Object. A InputsScreen instance.
Func _PressInputsScreen($oSelf)
	$oSelf.oDevice.click($oSelf.buttonInputs)
	Return InputsScreen($oSelf.oDevice)
EndFunc   ;==>_PressInputsScreen

;Function: _WaitForScreen
;Wait for the title of this screen.
;
;Parameters:
;   $oSelf - Object reference.
Func _WaitForScreen($oSelf)
	$oSelf.oDevice.waitForTextExist($oSelf.textTitle)
EndFunc   ;==>_WaitForScreen
#EndRegion Methods