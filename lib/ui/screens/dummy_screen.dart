import 'dart:developer';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:fixbee_partner/Constants.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class DummyScreen extends StatefulWidget {


  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  String barcode="";
  // var qrText = '';
  // var flashState = flashOn;
  // var cameraState = frontCamera;
  // QRViewController controller;
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      log(barcode,name:"VALUE");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Tap"),
                onPressed: (){
                  scan();
                },
              ),
              // Expanded(
              //   flex: 4,
              //   child: QRView(
              //     key: qrKey,
              //     onQRViewCreated: _onQRViewCreated,
              //     overlay: QrScannerOverlayShape(
              //       borderColor: Colors.red,
              //       borderRadius: 10,
              //       borderLength: 30,
              //       borderWidth: 10,
              //       cutOutSize: 300,
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         Text('This is the result of scan: $qrText'),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: EdgeInsets.all(8),
              //               child: RaisedButton(
              //                 onPressed: () {
              //                   // if (controller != null) {
              //                   //   controller.toggleFlash();
              //                   //   if (_isFlashOn(flashState)) {
              //                   //     setState(() {
              //                   //       flashState = flashOff;
              //                   //     });
              //                   //   } else {
              //                   //     setState(() {
              //                   //       flashState = flashOn;
              //                   //     });
              //                   //   }
              //                   // }
              //                 },
              //                 // child:
              //                 // Text(flashState, style: TextStyle(fontSize: 20)),
              //               ),
              //             ),
              //             Container(
              //               margin: EdgeInsets.all(8),
              //               child: RaisedButton(
              //                 onPressed: () {
              //                   // if (controller != null) {
              //                   //   controller.flipCamera();
              //                   //   if (_isBackCamera(cameraState)) {
              //                   //     setState(() {
              //                   //       cameraState = frontCamera;
              //                   //     });
              //                   //   } else {
              //                   //     setState(() {
              //                   //       cameraState = backCamera;
              //                   //     });
              //                   //   }
              //                   // }
              //                 },
              //               //   child:
              //               //   Text(cameraState, style: TextStyle(fontSize: 20)),
              //               // ),
              //             )
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: EdgeInsets.all(8),
              //               child: RaisedButton(
              //                 onPressed: () {
              //                   // controller?.pauseCamera();
              //                 },
              //                 child: Text('pause', style: TextStyle(fontSize: 20)),
              //               ),
              //             ),
              //             Container(
              //               margin: EdgeInsets.all(8),
              //               child: RaisedButton(
              //                 onPressed: () {
              //                   // controller?.resumeCamera();
              //                 },
              //                 child: Text('resume', style: TextStyle(fontSize: 20)),
              //               ),
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // )

          // RaisedButton(
          //   child: Text("Tap"),
          //   onPressed: () {
          //     _showPaymentSuccessDialog();
          //   },
          // )
        ]));
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       qrText = scanData;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
  // _showPaymentSuccessDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(Constants.padding),
  //           ),
  //           backgroundColor: Colors.transparent,
  //           elevation: 0,
  //           child: CustomRatingWidget(),
  //         );
  //       });
  // }
}
