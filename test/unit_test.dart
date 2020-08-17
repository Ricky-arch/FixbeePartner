import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Fun',
    () {
    int a=12345678;
    String validOtp="$a";
    validOtp=validOtp.substring(1,7);
    a= int.parse(validOtp);
    print(a);

    },
  );
}
