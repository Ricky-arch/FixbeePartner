import 'package:fixbee_partner/blocs/wallet_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:string_validator/string_validator.dart';

import '../../Constants.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController walletAmountController;
  bool isButtonEnabled = false;
  WalletBloc _bloc;
  final String wallet = "400.00";
  double walletAmount;
  int walletAmountInpaise;
  Razorpay _razorpay = Razorpay();
  String email = (DataStore.me.emailAddress == null)
      ? 'Tap to enter a valid mail'
      : DataStore.me.emailAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = WalletBloc(WalletModel());
    _bloc.fire(WalletEvent.fetchWalletAmount, onHandled: (e, m) {
      walletAmountInpaise = m.amount;
      walletAmount = (walletAmountInpaise / 100).toDouble();
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    // TODO: implement dispose
    super.dispose();
  }
  //rzp_test_CCbjVk8vqcb00P

  var options = {
    'key': 'rzp_test_CCbjVk8vqcb00P',
    'amount': 100,
    'name': 'FIXBEE',
    'description': 'Wallet Deposit',
    'prefill': {
      'contact': '${DataStore.me.phoneNumber}' ?? '8787200192',
      'email': (DataStore.me.emailAddress == null)
          ? 'Tap to enter a valid mail'
          : DataStore.me.emailAddress
    }
  };

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //_bloc.widget(onViewModelUpdated: (ctx, viewModel){}
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 60,
                    color: PrimaryColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/images/rupee.png"),
                            height: 35,
                            width: 25,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 40),
                          Center(
                              child: Text(
                            "Your Wallet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Current Balance :",
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: PrimaryColors.backgroundColor,
                            ),
                            onPressed: () {
                              print(walletAmount.toString());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Stack(children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 0, 40),
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                              color: PrimaryColors.backgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomLeft: Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 38, 8, 8),
                                child: Image(
                                  image: AssetImage("assets/images/rupee.png"),
                                  height: 35,
                                  width: 25,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 30, 8, 8),
                                child: Text(
                                  walletAmount.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: double.parse(
                                          (walletAmount.toString().length *
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      (walletAmount
                                                              .toString()
                                                              .length *
                                                          6)))
                                              .toString())),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0.0, 60, 8, 8),
                                child: Text(
                                  "INR",
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 270,
                      child: FloatingActionButton(
                        backgroundColor: PrimaryColors.backgroundColor,
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.yellow,
                          size: 60,
                        ),
                        onPressed: () {
                          _showPaymentAmountModalBottomSheet(context);
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: PrimaryColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 6,
                  child: Container(
                    height: 90,
                    width: 105,
                    child: Center(
                        child: Text(
                      "TRANSACTIONS",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 6,
                  child: Container(
                    height: 90,
                    width: 105,
                    child: Center(
                        child: Text(
                      "WITHDRAWAL",
                      style: TextStyle(color: PrimaryColors.backgroundColor),
                    )),
                  ),
                  onPressed: () {},
                ),
              ],
            )

            //Divider(height: 10, thickness: 5,),
          ],
        ),
      );
    }));
  }

  _showPaymentAmountModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.deepPurple),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Enter Amount:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: isAmountValid,
                            decoration: InputDecoration(
                                hintText: "Type Here",
                                errorStyle: TextStyle(color: Colors.red),
                                border: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.green))),
                            controller: walletAmountController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          OutlineButton(
                            borderSide:
                                BorderSide(width: 2, color: Colors.green),
                            textColor: Colors.deepPurple,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          OutlineButton(
                            borderSide:
                            BorderSide(width: 2, color: Colors.green),
                            textColor: Colors.deepPurple,
                            onPressed: isButtonEnabled?(){
                              _razorpay.open(options);
                            }:null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "ADD",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void isAmountValid(String value) {
    setState(() {
      if (isNumeric(value.toString())) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }
}
