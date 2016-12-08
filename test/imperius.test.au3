#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <../imperius.au3>

Global Enum $IP, $PORT, $DEVICEID, $SERVERPATH, $TIMEOUT
Global $aParams[5] = ["127.0.0.1", 3007, "123456", "C:\folder\" & $IMPERIUSSERVERJAR, 15000]

#Region Suite
Local $oTestSuite = newTestSuite("Imperius")
$oTestSuite.ci = True
$oTestSuite.addTest(TestImperiusServerGetters())
$oTestSuite.addTest(TestUIDeviceGetters())
$oTestSuite.addTest(TestLoggerLevels())
$oTestSuite.addTest(TestLoggerFile())
$oTestSuite.finish()
#EndRegion Suite

#Region Tests
Func TestImperiusServerGetters()
	Local $sMsg = "This [%s] getter should be equal to [%s]"
	Local $sURL = 'http://' & $aParams[$IP] & ':' & $aParams[$PORT] & '/'

	Local $oTest = newTest("ImperiusServerGetters")
	Local $oImperius = ImperiusServer($aParams[$IP], $aParams[$PORT], $aParams[$DEVICEID], $aParams[$SERVERPATH], $aParams[$TIMEOUT])

	With $oTest
		.assertEquals(StringFormat($sMsg, "getIP", $aParams[$IP]), $oImperius.getIP(), $aParams[$IP])
		.assertEquals(StringFormat($sMsg, "getPort", $aParams[$PORT]), $oImperius.getPort(), $aParams[$PORT])
		.assertEquals(StringFormat($sMsg, "getServerPath", $aParams[$SERVERPATH]), $oImperius.getServerPath(), $aParams[$SERVERPATH])
		.assertEquals(StringFormat($sMsg, "getTimeout", $aParams[$TIMEOUT]), $oImperius.getTimeout(), $aParams[$TIMEOUT])
		.assertEquals(StringFormat($sMsg, "getUrl", $sURL), $sURL, $oImperius.getUrl())
		.assertEquals(StringFormat($sMsg, "getDeviceID", $aParams[$DEVICEID]), $aParams[$DEVICEID], $oImperius.getDeviceID())
		.assertTrue(StringFormat($sMsg, "getDevice", "UiDevice"), IsObj($oImperius.getDevice()))
		.assertTrue(StringFormat($sMsg, "getAdb", "ADB"), IsObj($oImperius.getAdb()))
		.assertTrue(StringFormat($sMsg, "getLogger", "Logger"), IsObj($oImperius.getLogger()))
	EndWith
	$oImperius = 0

	Local $oImperiusDefault = ImperiusServer(Default, Default, Default, $aParams[$SERVERPATH, Default)
	With $oTest
		.assertEquals(StringFormat($sMsg, "getIP", "localhost"), $oImperiusDefault.getIP(), "localhost")
		.assertEquals(StringFormat($sMsg, "getPort", 7120), $oImperiusDefault.getPort(), 7120)
		.assertEquals(StringFormat($sMsg, "getDeviceID", ""), "", $oImperiusDefault.getDeviceID())
		.assertEquals(StringFormat($sMsg, "getTimeout", 30000), $oImperiusDefault.getTimeout(), 30000)
	EndWith
	$oImperiusDefault = 0
	Return $oTest
EndFunc   ;==>TestImperiusServerGetters


Func TestUIDeviceGetters()
	Local $sMsg = "This [%s] getter should be equal to [%s]"
	Local $oTest = newTest("UiDeviceGetters")
	Local $oImperius = ImperiusServer(Default, Default, $aParams[$DEVICEID])
	Local $oDevice = $oImperius.getDevice()

	With $oTest
		.assertEquals(StringFormat($sMsg, "getDeviceID", $aParams[$DEVICEID]), $aParams[$DEVICEID], $oDevice.getDeviceID())
		.assertTrue(StringFormat($sMsg, "getServer", "Imperius"), IsObj($oDevice.getServer()))
	EndWith
	$oImperius = 0
	$oDevice = 0
	Return $oTest
EndFunc   ;==>TestUIDeviceGetters

Func TestLoggerLevels()
	Local $sMsg = "Actual level should be equal to [%s]"
	Local Const $LEVELSTRING[6] = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
	Local $sDefaultLevel = "INFO"
	Local $oTest = newTest("Logger")
	Local $oLogger = Logger()

	$oTest.assertEquals(StringFormat($sMsg, $sDefaultLevel), $sDefaultLevel, $oLogger.getLevel())
	$oLogger.setLevel($LOG_TRACE)
	$oTest.assertEquals(StringFormat($sMsg, $LEVELSTRING[$LOG_TRACE]), $LEVELSTRING[$LOG_TRACE], $oLogger.getLevel())
	$oLogger.setLevel($LOG_DEBUG)
	$oTest.assertEquals(StringFormat($sMsg, $LEVELSTRING[$LOG_DEBUG]), $LEVELSTRING[$LOG_DEBUG], $oLogger.getLevel())
	$oLogger.setLevel($LOG_INFO)
	$oTest.assertEquals(StringFormat($sMsg, $sDefaultLevel), $sDefaultLevel, $oLogger.getLevel())
	$oLogger.setLevel($LOG_WARN)
	$oTest.assertEquals(StringFormat($sMsg, $LEVELSTRING[$LOG_WARN]), $LEVELSTRING[$LOG_WARN], $oLogger.getLevel())
	$oLogger.setLevel($LOG_ERROR)
	$oTest.assertEquals(StringFormat($sMsg, $LEVELSTRING[$LOG_ERROR]), $LEVELSTRING[$LOG_ERROR], $oLogger.getLevel())
	$oLogger.setLevel($LOG_FATAL)
	$oTest.assertEquals(StringFormat($sMsg, $LEVELSTRING[$LOG_FATAL]), $LEVELSTRING[$LOG_FATAL], $oLogger.getLevel())
	$oLogger = 0
	Return $oTest
EndFunc   ;==>TestLoggerLevels


Func TestLoggerFile()
	Local $sMsg = "Actual level should be equal to [%s]"
	Local Const $LEVELSTRING[6] = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
	Local $sFileLog = "log.txt"
	Local $sDefaultLevel = "INFO"
	Local $oTest = newTest("Logger")
	Local $oLogger = Logger($sFileLog)

	With $oLogger
		.setLevel($LOG_TRACE)
		.trace("TRACE")
		.setLevel($LOG_DEBUG)
		.debug("DEBUG")
		.setLevel($LOG_INFO)
		.info("INFO")
		.setLevel($LOG_WARN)
		.warn("WARN")
		.setLevel($LOG_ERROR)
		.error("ERROR")
		.setLevel($LOG_FATAL)
		.fatal("FATAL")
	EndWith

	$oTest.assertTrue("The file [" & $sFileLog & "] exists", FileExists($sFileLog))
	$oTest.assertTrue("The file [" & $sFileLog & "] size should be > 0", FileGetSize($sFileLog) > 0)
	$oLogger = 0
	FileDelete($sFileLog)
	Return $oTest
EndFunc   ;==>TestLoggerFile
#EndRegion Tests