#include <../../imperius.au3>

;Local $sDeviceId = "" If multiple emulator/device instances are running, you must specify a serial device id.
Local $oImperius = ImperiusServer("127.0.0.1", 3007)
Local $oLogger = $oImperius.getLogger()
Local $oDevice = $oImperius.getDevice()
$oImperius.start() ;Start the ImperiusGeorge server on the device.

With $oDevice
	.pressBack()
	.pressHome()
	.pressTab()
	.pressAppMenu()
	.pressEnter()
	.sendKeyEvents($KEYCODE_CAMERA); You can find all key code definitions at android.keys.constants.au3
EndWith

$oImperius.stop()
$oImperius = 0