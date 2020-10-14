import 'dart:ui';

import 'package:flutter/material.dart';

//JOB_COMPLETED

class Constants{
  static const String HOST_IP="192.168.29.3:8081";
  static const String PROTOCOL="http";
  static const WS_PROTOCOL='ws';
  static const googleApiKey='AIzaSyBOtIGTYgsxiCKVDAXWy9ZPU0rUPr2P8sI';
  static const googleSessionToken='12345';
  static const fields='name,formatted_address,geometry';
  static const PING_TIMEOUT=5;
  static const RAZORPAY_KEY='rzp_test_CCbjVk8vqcb00P';
}
class EndPoints{
  static const LOGIN="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/login";
  static const REQUEST_OTP="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/request";
  static const REGISTER="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/register";
  static const GRAPHQL="${Constants.PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const GRAPHQL_WS="${Constants.WS_PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const DOCUMENT="${Constants.PROTOCOL}://${Constants.HOST_IP}/document";
  static const INFO="${Constants.PROTOCOL}://${Constants.HOST_IP}/info";
}

class SharedPrefKeys{
  static const TOKEN='token@bee';
  static const  ORDER='ORDER';
}
class PrimaryColors{
  static Color backgroundColor = Color.fromRGBO(0, 7, 17, 9);
  static Color yellowColor=Color. fromRGBO(255, 255, 0, 1);
  static Color whiteColor= Colors.white;
}
