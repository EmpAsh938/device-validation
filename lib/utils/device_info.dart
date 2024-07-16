import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final NetworkInfo networkInfo = NetworkInfo();
  final deviceData = <String, dynamic>{};

  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceData['deviceId'] = androidInfo.id;
      deviceData['model'] = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceData['deviceId'] = iosInfo.identifierForVendor;
      deviceData['model'] = iosInfo.utsname.machine;
    }

    final wifiName =
        await networkInfo.getWifiName(); // For example, "NetworkName"
    final wifiBSSID =
        await networkInfo.getWifiBSSID(); // MAC address of the router
    final wifiIP = await networkInfo.getWifiIP(); // Device IP address

    deviceData['wifiName'] = wifiName;
    deviceData['wifiBSSID'] = wifiBSSID;
    deviceData['wifiIP'] = wifiIP;
  } catch (e) {
    throw Exception('Failed to get device info');
  }

  return deviceData;
}
