#include <../../imperius.au3>

;Local $sDeviceId = "" If multiple emulator/device instances are running, you must specify a serial device id.
Local $oImperius = ImperiusServer("127.0.0.1", 3007)
Local $oLogger = $oImperius.getLogger()
Local $oDevice = $oImperius.getDevice()
$oImperius.start() ;Start the ImperiusGeorge server on the device.

$oLogger.info("Dump: " & $oDevice.getDump() )
$oLogger.info("Top Activity: " & $oDevice.getCurrentTopActivity())
$oLogger.info("Activity Name: " & $oDevice.getActivityName())
$oLogger.info("Device Name: " & $oDevice.getDeviceName())
$oLogger.info("Device Version: " & $oDevice.getDeviceVersion())
$oLogger.info("Device Manufacturer: " & $oDevice.getDeviceManufacturer())
$oLogger.info("Device Model: " & $oDevice.getDeviceModel())
$oLogger.info("Packages: " & $oDevice.getPackages()[0])
$oDevice.getScreenshot("screen.png")

$oImperius.stop()
$oImperius = 0