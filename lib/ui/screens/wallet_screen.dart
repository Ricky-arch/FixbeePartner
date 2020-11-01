import 'dart:developer';

import 'package:fixbee_partner/blocs/wallet_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
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
  TextEditingController walletDepositAmountController =
      new TextEditingController();
  TextEditingController walletWithdrawAmountController =
      new TextEditingController();
  bool checkBoxValue = false;
  static String selectedAccountID = "NOT_SELECTED";
  static String selectedAccountNumber;
  bool isButtonEnabled = false;
  WalletBloc _bloc;
  final String wallet = "400.00";
  double walletAmount = 0;
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
    _bloc.fire(WalletEvent.fetchBankAccountsForWithdrawal, onHandled: (e, m) {
      selectedAccountNumber = m.bankAccountList[0].bankAccountNumber;
    });
    _bloc.fire(WalletEvent.fetchWalletAmount, onHandled: (e, m) {
      walletAmountInpaise = m.amount;
      if (walletAmountInpaise != null) {
        walletAmount = (walletAmountInpaise / 100).toDouble();
      }
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    walletWithdrawAmountController.dispose();
    walletDepositAmountController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log(response.signature.toString(), name: "SUCCESS");
    _bloc.fire(WalletEvent.processWalletDeposit, message: {
      'paymentID': response.paymentId,
      'paymentSignature': response.signature
    }, onHandled: (e, m) {
      _showPaymentSuccessDialog();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log(response.message.toString(), name: "FAILURE");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName.toString(), name: "ExternalWalletDeposit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //_bloc.widget(onViewModelUpdated: (ctx, viewModel){}
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    color: PrimaryColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "\u20B9 WALLET",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
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
                                  (viewModel.amount == null)
                                      ? "0.0"
                                      : "${(viewModel.amount) / 100}",
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
                          _showAddToWalletModalBottomSheet(context);
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
                  onPressed: () {
                    int selectedRadio = 0;
                    if (viewModel.numberOfAccounts != 0) {
                      selectedAccountNumber =
                          viewModel.bankAccountList[0].bankAccountNumber;
                      selectedAccountID =
                          viewModel.bankAccountList[0].accountID;
                      print(selectedAccountID + selectedAccountID);
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            insetPadding: EdgeInsets.all(10),
                            child: (viewModel.numberOfAccounts == 0)
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Oops! No Accounts Linked",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView(
                                    shrinkWrap: true,
                                    children: [
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: PrimaryColors
                                                      .backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: (viewModel
                                                              .bankAccountList
                                                              .length ==
                                                          0)
                                                      ? Text(
                                                          "No Bank Accounts Linked",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white))
                                                      : (viewModel.bankAccountList
                                                                  .length ==
                                                              1)
                                                          ? Text(
                                                              "Confirm this account",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))
                                                          : Text(
                                                              "Choose an account for withdrawal",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: viewModel
                                                      .bankAccountList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      8.0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                "Select account ${index + 1}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Radio(
                                                              value: index,
                                                              activeColor:
                                                                  PrimaryColors
                                                                      .backgroundColor,
                                                              groupValue:
                                                                  selectedRadio,
                                                              onChanged: (val) {
                                                                selectedAccountID =
                                                                    viewModel
                                                                        .bankAccountList[
                                                                            index]
                                                                        .accountID;
                                                                setState(() =>
                                                                    selectedRadio =
                                                                        val);
                                                                if (selectedRadio ==
                                                                    1) {
                                                                  selectedAccountNumber = viewModel
                                                                      .bankAccountList[
                                                                          index]
                                                                      .bankAccountNumber;
                                                                  selectedAccountID = viewModel
                                                                      .bankAccountList[
                                                                          index]
                                                                      .accountID;
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        AvailableAccounts(
                                                          accountHoldersName: viewModel
                                                              .bankAccountList[
                                                                  index]
                                                              .accountHoldersName,
                                                          accountNumber: viewModel
                                                              .bankAccountList[
                                                                  index]
                                                              .bankAccountNumber,
                                                          verified: viewModel
                                                              .bankAccountList[
                                                                  index]
                                                              .accountVerified,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  RaisedButton(
                                                    elevation: 4,
                                                    color: PrimaryColors
                                                        .backgroundColor,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Next",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    onPressed: (viewModel
                                                                .bankAccountList
                                                                .length !=
                                                            0)
                                                        ? () {
                                                            print(
                                                                selectedAccountNumber);
                                                            Navigator.pop(
                                                                context);
                                                            _showPaymentWithdrawalModalSheet(
                                                              context,
                                                            );
                                                          }
                                                        : null,
                                                  ),
                                                  Container(
                                                    color: PrimaryColors
                                                        .backgroundColor,
                                                    height: 20,
                                                    width: 2,
                                                  ),
                                                  RaisedButton(
                                                    elevation: 4,
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: PrimaryColors
                                                                .backgroundColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          );
                        });
                  },
                ),
              ],
            )

            //Divider(height: 10, thickness: 5,),
          ],
        ),
      );
    }));
  }

  _showAddToWalletModalBottomSheet(context) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: PrimaryColors.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ENTER DEPOSIT AMOUNT:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: TextFormField(
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            decoration: InputDecoration(
                                hintText: "Eg: " + Constants.rupeeSign + "500",
                                errorStyle: TextStyle(color: Colors.red),
                                border: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.green))),
                            controller: walletDepositAmountController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: PrimaryColors.backgroundColor,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                              print(DataStore.me.phoneNumber.toString() +
                                  DataStore.me.emailAddress.toString() +
                                  "XXX");
                              int depositAmount =
                                  int.parse(walletDepositAmountController.text);
                              _bloc.fire(WalletEvent.createWalletDeposit,
                                  message: {'Amount': depositAmount * 100},
                                  onHandled: (e, m) {
                                log(m.paymentID, name: "paymentID");
                                var depositOptions = {
                                  'key': Constants.RAZORPAY_KEY,
                                  'id': "${_bloc.latestViewModel.paymentID}",
                                  'name': 'FIXBEE',
                                  'description': 'Wallet Deposit',
                                  'prefill': {
                                    'contact': '${DataStore.me.phoneNumber}' ??
                                        '1234567890',
                                    'email': (DataStore.me.emailAddress == null)
                                        ? 'Tap to enter a valid mail'
                                        : DataStore.me.emailAddress
                                  }
                                };
                                _razorpay.open(depositOptions);
                              });
                              print(depositAmount * 100);

                              walletDepositAmountController.clear();
                            },
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
                          OutlineButton(
                            borderSide: BorderSide(
                                width: 2, color: PrimaryColors.backgroundColor),
                            textColor: PrimaryColors.backgroundColor,
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

  _showPaymentWithdrawalModalSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: PrimaryColors.backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Selected Account:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                selectedAccountNumber,
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: PrimaryColors.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Enter Amount for Withdrawal:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: TextStyle(
                                  color: PrimaryColors.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              decoration: InputDecoration(
                                  hintText: "Eg: 500",
                                  errorStyle: TextStyle(color: Colors.red),
                                  border: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green))),
                              controller: walletWithdrawAmountController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: PrimaryColors.backgroundColor,
                            textColor: Colors.white,
                            onPressed: () {
                              print(selectedAccountNumber);
                              print(walletWithdrawAmountController.text);
                              _bloc.fire(WalletEvent.withdrawAmount, message: {
                                'amount': walletWithdrawAmountController.text,
                                'accountId': selectedAccountID
                              });
                              walletWithdrawAmountController.clear();
                            },
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
                          OutlineButton(
                            borderSide: BorderSide(
                                width: 2, color: PrimaryColors.backgroundColor),
                            textColor: PrimaryColors.backgroundColor,
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
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ));
        });
  }

  _showPaymentSuccessDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Payment Successful!",
              style: TextStyle(
                  color: PrimaryColors.backgroundColor,
                  fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
