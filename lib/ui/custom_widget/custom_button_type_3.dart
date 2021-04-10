import 'package:flutter/material.dart';

import '../../Constants.dart';

class CustomButtonType3 extends StatelessWidget {
  final bool isBankAccount;
  final Function doSomething;

  const CustomButtonType3({Key key, this.doSomething, this.isBankAccount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return addButton(isBankAccount, doSomething);
  }
}

Widget addButton(bool isBankAccount, Function doSomething) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: RaisedButton(
          onPressed: doSomething,
          color: PrimaryColors.backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Text(
            (isBankAccount) ? "Add Bank Account" : "Add VPA/UPI",
            style: TextStyle(color: PrimaryColors.whiteColor),
          ),
        ),
      ),
    ],
  );
}
