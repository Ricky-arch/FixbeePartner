class Constants{
  static const String HOST_IP="192.168.43.216";
  static const String PROTOCOL="http";
  static const WS_PROTOCOL='ws';
}
class EndPoints{
  static const LOGIN="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/login";
  static const REQUEST_OTP="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/request";
  static const REGISTER="${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/register";
  static const GRAPHQL="${Constants.PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const GRAPHQL_WS="${Constants.WS_PROTOCOL}://${Constants.HOST_IP}/graphql";
}

class SharedPrefKeys{
  static const TOKEN='token@bee';
}