;simple.test.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; This is a very simple test.

#include <../../imperius.au3>

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
$oLogger.info("Dump:" & $oDevice.getDump() )
$oDevice.waitForTextExist("AutoIt client")
$oDevice.clickAndWait("Inputs Screen")
$oDevice.enterText("0", "Imperius")
$oDevice.enterText("1", "Password")
$oDevice.click("Add")
$oDevice.waitForTextExist("Ready")
$oDevice.getScreenshot("InputScreen.png")
$oDevice.pressBack()
$oDevice.click("Back")
$oDevice.clearPackage($sPackage)
$oImperius.getAdb().uninstall($sPackage)

$oImperius.stop()
$oImperius = 0