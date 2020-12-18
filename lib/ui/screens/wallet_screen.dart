import 'dart:developer';
import 'package:fixbee_partner/blocs/wallet_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:string_validator/string_validator.dart';
import '../../Constants.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _addAmountFormKey = GlobalKey<FormState>();
  final _withdrawAmountFormKey = GlobalKey<FormState>();
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
  String email =
      (DataStore?.me?.emailAddress == null) ? '' : DataStore.me.emailAddress;

  Box<String> _BEENAME;
  _openHive() async{
    _BEENAME = Hive.box<String>("BEE");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openHive();
    _bloc = WalletBloc(WalletModel());
    setState(() {
      walletAmountInpaise=int.parse(_BEENAME.get("myWallet"));
      if (walletAmountInpaise != null) {
        walletAmount = (walletAmountInpaise / 100).toDouble();
      }
    });
    _bloc.fire(WalletEvent.fetchBankAccountsForWithdrawal, onHandled: (e, m) {
      selectedAccountNumber = m.bankAccountList[0].bankAccountNumber;
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  fetchWalletAmountOnError(){
    _bloc.fire(WalletEvent.fetchWalletAmount, onHandled: (e, m) {
      _BEENAME.put("myWallet", m.amount.toString());
      walletAmountInpaise = m.amount;
      if (walletAmountInpaise != null) {
        walletAmount = (walletAmountInpaise / 100).toDouble();
      }
    });
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
    log(response.signature.toString(), name: "SIGNATURE");
    log(response.paymentId.toString(), name: "PAYMENTID");

    _bloc.fire(WalletEvent.processWalletDeposit, message: {
//      'orderID': response.orderId,
      'paymentID': response.paymentId,
      'paymentSignature': response.signature
    }, onHandled: (e, m) {
      if (m.isProcessed) {
        _bloc.fire(WalletEvent.fetchWalletAmountAfterTransaction,
            onHandled: (e, m) {
              _BEENAME.put("myWallet", m.amount.toString());
              walletAmountInpaise=int.parse(_BEENAME.get("myWallet"));
              if (walletAmountInpaise != null) {
                walletAmount = (walletAmountInpaise / 100).toDouble();
              }
          _showPaymentSuccessDialog();
        });
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log(response.message.toString(), name: "FAILURE");
    _showPaymentFailureDialog(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName.toString(), name: "ExternalWalletDeposit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return GestureDetector(
        onDoubleTap: (){
          fetchWalletAmountOnError();
        },
        child: SafeArea(
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
                            Spacer(),
                            (viewModel.whileFetchingWalletAmount)
                                ? SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor:
                                          PrimaryColors.backgroundColor,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                    (viewModel.whileFetchingWalletAmount)
                        ? Container()
                        : Column(
                            children: [
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
                                    padding:
                                        const EdgeInsets.fromLTRB(40, 10, 0, 40),
                                    child: Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                          color: PrimaryColors.backgroundColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 38, 8, 8),
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/rupee.png"),
                                              height: 35,
                                              width: 25,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 30, 8, 8),
                                            child: Text(
                                              (walletAmount == null)
                                                  ? "0.0"
                                                  : "$walletAmount",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: double.parse((walletAmount
                                                              .toString()
                                                              .length *
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 60, 8, 8),
                                            child: Text(
                                              "INR",
                                              style:
                                                  TextStyle(color: Colors.yellow),
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
                                    backgroundColor:
                                        PrimaryColors.backgroundColor,
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
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Spacer(),
                                  RaisedButton(
                                    color:PrimaryColors.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    elevation: 6,
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                          child: Text(
                                        "WITHDRAWAL",
                                        style: TextStyle(
                                            color: Colors.white),
                                      )),
                                    ),
                                    onPressed: () {
                                      int selectedRadio = 0;
                                      if (viewModel.numberOfAccounts != 0) {
                                        selectedAccountNumber = viewModel
                                            .bankAccountList[0].bankAccountNumber;
                                        selectedAccountID = viewModel
                                            .bankAccountList[0].accountID;
                                        print(selectedAccountID +
                                            selectedAccountID);
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              insetPadding: EdgeInsets.all(10),
                                              child:
                                                  (viewModel.numberOfAccounts ==
                                                          0)
                                                      ? Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Oops! No Accounts Linked",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .sentiment_very_dissatisfied,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : ListView(
                                                          shrinkWrap: true,
                                                          children: [
                                                            StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: PrimaryColors
                                                                            .backgroundColor,
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                                Radius.circular(15.0)),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        child: (viewModel.bankAccountList.length ==
                                                                                0)
                                                                            ? Text(
                                                                                "No Bank Accounts Linked",
                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))
                                                                            : (viewModel.bankAccountList.length == 1)
                                                                                ? Text("Confirm this account", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))
                                                                                : Text(
                                                                                    "Choose an account for withdrawal",
                                                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: viewModel.bankAccountList.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                                                                    child: Text(
                                                                                      "Select account ${index + 1}",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Radio(
                                                                                    value: index,
                                                                                    activeColor: PrimaryColors.backgroundColor,
                                                                                    groupValue: selectedRadio,
                                                                                    onChanged: (val) {
                                                                                      selectedAccountID = viewModel.bankAccountList[index].accountID;
                                                                                      setState(() => selectedRadio = val);
                                                                                      if (selectedRadio == 1) {
                                                                                        selectedAccountNumber = viewModel.bankAccountList[index].bankAccountNumber;
                                                                                        selectedAccountID = viewModel.bankAccountList[index].accountID.toString();
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              AvailableAccounts(
                                                                                accountHoldersName: viewModel.bankAccountList[index].accountHoldersName,
                                                                                accountNumber: viewModel.bankAccountList[index].bankAccountNumber,
                                                                                verified: viewModel.bankAccountList[index]. accountVerified,
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
                                                                          elevation:
                                                                              4,
                                                                          color: PrimaryColors
                                                                              .backgroundColor,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              "Next",
                                                                              style:
                                                                                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          onPressed: (viewModel.bankAccountList.length !=
                                                                                  0)
                                                                              ? () {
                                                                                  print(selectedAccountNumber);
                                                                                  Navigator.pop(context);
                                                                                  _showPaymentWithdrawalModalSheet(
                                                                                    context,
                                                                                  );
                                                                                }
                                                                              : null,
                                                                        ),
                                                                        Container(
                                                                          color: PrimaryColors
                                                                              .backgroundColor,
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        RaisedButton(
                                                                          elevation:
                                                                              4,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              "Cancel",
                                                                              style:
                                                                                  TextStyle(color: PrimaryColors.backgroundColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(
                                                                                context);
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
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          )
                  ],
                ),
              ),

              //Divider(height: 10, thickness: 5,),
            ],
          ),
        ),
      );
    }));
  }

  _showAddToWalletModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: PrimaryColors.backgroundcolorlight,
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                          child: Text(
                            "ENTER DEPOSIT AMOUNT",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: Form(
                            key: _addAmountFormKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim().isNotEmpty) {
                                  if (!isNumeric(value))
                                    return 'Enter a valid amount!';
                                }
                                if (value.isEmpty) {
                                  return 'Enter any amount';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: PrimaryColors.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              decoration: InputDecoration(
                                  hintText:
                                      "Eg: " + Constants.rupeeSign + "500",
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  border: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.green))),
                              controller: walletDepositAmountController,
                              keyboardType: TextInputType.number,
                            ),
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
                              if (_addAmountFormKey.currentState.validate()) {
                                Navigator.pop(context);
                                int depositAmount = int.parse(
                                    walletDepositAmountController.text);
                                _bloc.fire(WalletEvent.createWalletDeposit,
                                    message: {'Amount': depositAmount * 100},
                                    onHandled: (e, m) {
                                  log(m.paymentID, name: "paymentID");
                                  var depositOptions = {
                                    'key': Constants.RAZORPAY_KEY,
                                    'order_id': "${m.paymentID}",
                                    'name': 'FIXBEE',
                                    'description': 'Wallet Deposit',
                                    'prefill': {
                                      'contact':
                                          '${DataStore.me.phoneNumber}' ??
                                              '1234567890',
                                      'email': "$email"
                                    }
                                  };
                                  _razorpay.open(depositOptions);
                                });
                                print(depositAmount * 100);

                                walletDepositAmountController.clear();
                              }
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
                      (_bloc.latestViewModel.whileWithDrawingAmount)
                          ? LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: PrimaryColors.backgroundColor,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: PrimaryColors.backgroundColor,
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
                            // borderRadius:
                            //     BorderRadius.all(Radius.circular(15.0)),
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
                            child: Form(
                              key: _withdrawAmountFormKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.trim().isNotEmpty) {
                                    if (!isNumeric(value))
                                      return 'Enter a valid amount!';
                                    else if (walletAmountInpaise -
                                            (int.parse(value) * 100) <
                                        Constants.MINIMUM_WALLET_AMOUNT * 100)
                                      return 'Withdrawal amount exceeds threshold!';
                                  } else if (value.isEmpty) {
                                    return 'Enter any amount!';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: PrimaryColors.backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                decoration: InputDecoration(
                                    // hintText: "Eg: 500",
                                    errorStyle: TextStyle(color: Colors.red),
                                    border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.green))),
                                controller: walletWithdrawAmountController,
                                keyboardType: TextInputType.number,
                              ),
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
                              if (_withdrawAmountFormKey.currentState
                                  .validate()) {
                                String withdrawAmount =
                                    walletWithdrawAmountController.text
                                        .toString();
                                int amount = int.parse(withdrawAmount) * 100;
                                _bloc.fire(WalletEvent.withdrawAmount,
                                    message: {
                                      'amount': amount,
                                      'accountId': selectedAccountID
                                    }, onHandled: (e, m) {
                                  log("Requested for Withdrawal $amount  from $selectedAccountID",
                                      name: "WITHDRAW");
                                  Navigator.pop(context);
                                  _bloc.fire(
                                      WalletEvent
                                          .fetchWalletAmountAfterTransaction,
                                      onHandled: (e, m) {
                                        _BEENAME.put("myWallet", m.amount.toString());
                                        walletAmountInpaise=int.parse(_BEENAME.get("myWallet"));
                                        if (walletAmountInpaise != null) {
                                          walletAmount = (walletAmountInpaise / 100).toDouble();
                                        }
                                    _showPaymentSuccessDialog();
                                  });
                                });
                                walletWithdrawAmountController.clear();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "WITHDRAW",
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
                              walletWithdrawAmountController.clear();
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
          FlutterRingtonePlayer.playNotification();
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              height: 250,
              width: 250,
              child: FlareActor(
                "assets/animations/cms_remix.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled",
              ),
            ),
          );
        });
  }

  _showPaymentFailureDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message.toString() + "!",
              style: TextStyle(
                  color: PrimaryColors.backgroundColor,
                  fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
