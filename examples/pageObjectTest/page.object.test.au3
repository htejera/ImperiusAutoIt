;page.object.test.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; Simple test that show the page object design best practice in order to minimize code duplication, make tests more readable,
; reduce the cost of modification, and improve maintainability.
;See:
; <http://martinfowler.com/bliki/PageObject.html>

#include <../../imperius.au3>
#include <dashboardScreen.au3>
#include <inputsScreen.au3>

;Application Under Test data.
Local $sAUTPath = "../ImperiusGeorge.apk"
Local $sPackage = "appinventor.ai_henrytejera.ImperiusGeorge"
Local $sActivity = ".Screen1"

;Local $sDeviceId = "" If multiple emulator/device instances are running, you must specify a serial device id.
Local $oImperius = ImperiusServer("127.0.0.1", 3007)
Local $oLogger = $oImperius.getLogger()
Local $oDevice = $oImperius.getDevice()
$oImperius.start() ;Start the ImperiusGeorge server on the device.

;Install the application under test through the ADB client.
$oImperius.getAdb().install($sAUTPath)
$oDevice.startActivity($sPackage, $sActivity)

Local $oDashboardScreen = DashboardScreen($oDevice)
$oDashboardScreen.waitForScreen()
Local $oInputsScreen = $oDashboardScreen.pressInputsScreen()

With $oInputsScreen
	.writeName("Imperius")
	.writePassword("Password")
	.pressAdd()
	.waitForReady()
	.back()
EndWith

$oDevice.clearPackage($sPackage)
$oImperius.getAdb().uninstall($sPackage)

$oImperius.stop()
$oImperius = 0