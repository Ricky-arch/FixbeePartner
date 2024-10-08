import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class TransactionType extends StatefulWidget {
  final Function setTransactionType;

  const TransactionType({Key key, this.setTransactionType}) : super(key: key);
  @override
  _TransactionTypeState createState() => _TransactionTypeState();
}

class _TransactionTypeState extends State<TransactionType> {
  List<String> types = ['Credit', 'Debit', 'Transfer', 'Salary', 'All'];
  String type = 'Credit';
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'TYPE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                child: GestureDetector(
                  onTap: () {
                    widget.setTransactionType(type);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4),
                        child: Container(
                          height: 35,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: _value,
                                items: [
                                  DropdownMenuItem(
                                    child: Text(
                                      "Credit",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      "Debit",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                      child: Text(
                                        "Transfer",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 3),
                                  DropdownMenuItem(
                                      child: Text(
                                        "Salary",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 4),
                                  DropdownMenuItem(
                                      child: Text(
                                        'All',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 5)
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                    type = types[value - 1];
                                  });
                                  widget.setTransactionType(type);
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
