import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DummyScreen extends StatefulWidget {
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  bool checkBoxValue = false;
  int selectedRadio;
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    selectedRadio = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.tealAccent)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Facial " + "\u20B930",
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.tealAccent),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "STATUS",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                      child: Text(
                        "SAURAV SUTRADHAR",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                      child: Divider(
                        color: Colors.tealAccent,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.yellow.withOpacity(.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SEE MORE",
                                  style: TextStyle(
                                      fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text("Date time"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
