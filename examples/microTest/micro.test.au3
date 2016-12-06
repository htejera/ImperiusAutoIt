;micro.test.au3
;
;Author:
; henrytejera@gmail.com
;
;Description:
; This is a very simple test that use Micro Unit Testing Framework.

#include <../../imperius.au3>

#Region AUTData
Local $sAUTPath = "../ImperiusGeorge.apk"
Local $sPackage = "appinventor.ai_henrytejera.ImperiusGeorge"
Local $sActivity = ".Screen1"
#EndRegion AUTData

#Region BeforeAfter
Func BeforeSuite($oServer, $sAppPath, $sPackage)
	Local $oAdb = $oServer.getAdb()
	With $oAdb
		.uninstall($sPackage)
		.install($sAppPath)
	EndWith
EndFunc   ;==>BeforeSuite
#EndRegion BeforeAfter

#Region Suite
Local $oImperius = ImperiusServer("127.0.0.1", 3007)
Local $oDevice = $oImperius.getDevice()
$oImperius.start()
BeforeSuite($oImperius, $sAUTPath, $sPackage)
Local $oTestSuite = newTestSuite("Suite")
$oTestSuite.addTest(TestInputScreen($oDevice))
$oTestSuite.finish()
$oImperius.stop()
$oImperius = 0
#EndRegion Suite

#Region Tests
Func TestInputScreen($oDevice)
	Local $oTest = newTest("Test InputScreen")
	Local $sExpected = "Ready"
	With $oDevice
		.startActivity($sPackage, $sActivity)
		.waitForTextExist("AutoIt client")
		.clickAndWait("Inputs Screen")
		.enterText("0", "Imperius")
		.enterText("1", "Password")
		.click("Add")
		.getScreenshot("InputScreen.png")
	EndWith
	$oTest.assertTrue("Assert that the [" & $sExpected & "] text is present on the screen", $oDevice.waitForTextExist($sExpected))
	Return $oTest
EndFunc   ;==>TestInputScreen
#EndRegion Tests