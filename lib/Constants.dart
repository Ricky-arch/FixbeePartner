import 'dart:ui';

class Constants{
  static const String HOST_IP="192.168.43.204";
  static const String PROTOCOL="http";
  static const WS_PROTOCOL='ws';
  static const googleApiKey='AIzaSyBOtIGTYgsxiCKVDAXWy9ZPU0rUPr2P8sI';
  static const googleSessionToken='12345';
  static const fields='name,formatted_address,geometry';
}
class EndPoints{
  static const LOGIN="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/login";
  static const REQUEST_OTP="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/request";
  static const REGISTER="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/register";
  static const GRAPHQL="${Constants.PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const GRAPHQL_WS="${Constants.WS_PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const DOCUMENT="${Constants.PROTOCOL}://${Constants.HOST_IP}/document";
}

class SharedPrefKeys{
  static const TOKEN='token@bee';
}
class PrimaryColors{
  static Color backgroundColor = Color.fromRGBO(0, 7, 17, 9);
}