import 'package:fixbee_partner/models/view_model.dart';

class LoginModel extends ViewModel{
  bool loading = false;
  String token;
  bool exist=false;
  String errorText;
}