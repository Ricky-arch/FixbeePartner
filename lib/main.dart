// @dart=2.9
import 'dart:io';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

createChannel() async {
  const MethodChannel _channel =
      MethodChannel('fixbee.in/order_notification_channel');
  Map<String, String> channelMap = {
    "id": "order_channel",
    "name": "Order",
    "description": "Order notification",
  };
  try {
    await _channel.invokeMethod('createNotificationChannel', channelMap);
  } on PlatformException catch (e) {
    print(e);
  }
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: PrimaryColors.backgroundColor,
      statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await createChannel();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            MaterialApp(
              title: "Fixbee Partner",
              themeMode: ThemeMode.dark,
              darkTheme: FixbeeThemes.darkTheme,
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ),
          ));
}
