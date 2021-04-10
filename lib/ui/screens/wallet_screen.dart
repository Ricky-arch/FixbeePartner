import 'dart:developer';
import 'package:fixbee_partner/blocs/wallet_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/wallet_event.dart';
import 'package:fixbee_partner/models/wallet_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
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
  static String selectedVPA;
  static String selectedVpaId;
  bool isButtonEnabled = false;
  WalletBloc _bloc;
  final String wallet = "400.00";
  double walletAmount = 00;
  bool _showLoader = false;

  int walletAmountInpaise = 00;
  Razorpay _razorpay = Razorpay();
  String email =
      (DataStore?.me?.emailAddress == null) ? '' : DataStore.me.emailAddress;
  bool showPaymentButtons = false;

  Box<String> _BEENAME;
  _openHive() async {
    _BEENAME = Hive.box<String>("BEE");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openHive();
    _bloc = WalletBloc(WalletModel());

    _bloc.fire(WalletEvent.fetchBankAccountsForWithdrawal, onHandled: (e, m) {
      if (m.bankAccountList.length != 0)
        selectedAccountNumber = m.bankAccountList[0].bankAccountNumber;
    });

    if (_BEENAME.get('myWallet') == null) {
      _bloc.fire(WalletEvent.fetchWalletAmount, onHandled: (e, m) {
        walletAmountInpaise = m.amount;
        if (walletAmountInpaise != null) {
          walletAmount = (walletAmountInpaise / 100).toDouble();
          _BEENAME.put('myWallet', walletAmountInpaise.toString());
        }
      });
    } else {
      walletAmountInpaise = int.parse(_BEENAME.get('myWallet'));
      walletAmount = (walletAmountInpaise / 100).toDouble();
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  fetchWalletAmountOnError() {
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
    _bloc.fire(WalletEvent.fetchWalletAmount, onHandled: (e, m) {
      _BEENAME.put("myWallet", m.amount.toString());
      setState(() {
        walletAmountInpaise = m.amount;
        walletAmount = (walletAmountInpaise) / 100;
      });
    });
    _showPaymentSuccessDialog();
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
    return Scaffold(body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20),
                      child: Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Your  ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                TextSpan(
                                  text: "Wallet \u20B9",
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          (viewModel.whileFetchingWalletAmount)
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CustomCircularProgressIndicator())
                              : GestureDetector(
                                  onTap: () {
                                    fetchWalletAmountOnError();
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                )
                        ],
                      ),
                    ),
                    (viewModel.isProcessed)
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: PrimaryColors.backgroundColor,
                          )
                        : SizedBox(),
                    (viewModel.validatingAvailability)
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: PrimaryColors.backgroundColor,
                          )
                        : SizedBox(),
                    (viewModel.whileWithDrawingAmount)
                        ? LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: PrimaryColors.backgroundColor,
                          )
                        : SizedBox(),
                    (viewModel.whileFetchingWalletAmount)
                        ? Container()
                        : Column(
                            children: [
                              SizedBox(height: 6),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12, 8, 12),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Current Balance :",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.more_horiz,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Stack(children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 0, 40),
                                    child: Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 30, 8, 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        8.0, 38, 8, 8),
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/images/rupee.png"),
                                                      height: 35,
                                                      width: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    (walletAmount == null)
                                                        ? "0.0"
                                                        : "$walletAmount",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: double.parse((walletAmount
                                                                    .toString()
                                                                    .length *
                                                                (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    (walletAmount
                                                                            .toString()
                                                                            .length *
                                                                        7)))
                                                            .toString())),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                        Theme.of(context).canvasColor,
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Theme.of(context).primaryColor,
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
                                children: <Widget>[
                                  Spacer(),
                                  RaisedButton(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    elevation: 6,
                                    child: Container(
                                      height: 35,
                                      width: 100,
                                      child: Center(
                                          child: Text(
                                        "WITHDRAWAL",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    onPressed: () {
                                      _bloc.fire(WalletEvent.fetchWalletAmount,
                                          onHandled: (e, m) {
                                        _bloc
                                            .fire(WalletEvent.checkAvailability,
                                                onHandled: (e, m) {
                                          showPaymentButtons =
                                              m.availableForWithdrawal;
                                          if (!showPaymentButtons)
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .accentColor,
                                                    content: Text(
                                                      'Can not withdraw if you are in an active Order',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor),
                                                    )));
                                        });
                                      });

                                      if (showPaymentButtons == true)
                                        setState(() {
                                          showPaymentButtons = false;
                                        });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              (showPaymentButtons)
                                  ? Row(
                                      children: <Widget>[
                                        Spacer(),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          color: PrimaryColors
                                              .backgroundcolorlight,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Container(
                                            child: Center(
                                                child: Text(
                                              "VPA/UPI",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            )),
                                          ),
                                          onPressed: () {
                                            int selectedRadio = 0;
                                            if (viewModel.vpaList.length != 0) {
                                              selectedVPA =
                                                  viewModel.vpaList[0].address;
                                              selectedAccountID =
                                                  viewModel.vpaList[0].id;
                                            }
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .canvasColor,
                                                    insetPadding:
                                                        EdgeInsets.all(10),
                                                    child:
                                                        (viewModel.vpaList
                                                                    .length ==
                                                                0)
                                                            ? Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "Oops! No VPA/UPI Added",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).accentColor,
                                                                            fontSize: 16),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .sentiment_very_dissatisfied,
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                children: [
                                                                  StatefulBuilder(
                                                                    builder: (BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            setState) {
                                                                      return Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).cardColor,
                                                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: (viewModel.vpaList.length == 1)
                                                                                  ? Text("Confirm VPA/UPI", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).hintColor))
                                                                                  : Text(
                                                                                      "Choose VPA/UPI",
                                                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).hintColor),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              scrollDirection: Axis.vertical,
                                                                              itemCount: viewModel.vpaList.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                return Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                                                                          child: Text(
                                                                                            "Select VPA/UPI:",
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                                                                          ),
                                                                                        ),
                                                                                        Spacer(),
                                                                                        Radio(
                                                                                          value: index,
                                                                                          activeColor: Theme.of(context).accentColor,
                                                                                          groupValue: selectedRadio,
                                                                                          onChanged: (val) {
                                                                                            setState(() => selectedRadio = val);
                                                                                            selectedVpaId = viewModel.vpaList[index].id;
                                                                                            if (viewModel.vpaList.length == 1) {
                                                                                              selectedVPA = viewModel.vpaList[0].address;
                                                                                              selectedVpaId = viewModel.vpaList[0].id.toString();
                                                                                            } else {
                                                                                              selectedVPA = viewModel.vpaList[selectedRadio].address;
                                                                                              selectedVpaId = viewModel.vpaList[selectedRadio].id.toString();
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    AvailableAccounts(
                                                                                      accountHoldersName: viewModel.vpaList[index].address,
                                                                                      accountNumber: viewModel.vpaList[index].address,
                                                                                      isBankAccount: false,
                                                                                      addressIndex: index + 1,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              }),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              RaisedButton(
                                                                                elevation: 4,
                                                                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                                                color: Theme.of(context).primaryColor,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    "Next",
                                                                                    style: TextStyle(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                onPressed: (viewModel.vpaList.length != 0)
                                                                                    ? () {
                                                                                        if (viewModel.vpaList.length == 1) {
                                                                                          selectedVPA = viewModel.vpaList[0].address;
                                                                                          selectedVpaId = viewModel.vpaList[0].id;
                                                                                        }

                                                                                        Navigator.pop(context);
                                                                                        _showPaymentWithdrawalModalSheet(selectedVPA, selectedVpaId);
                                                                                      }
                                                                                    : null,
                                                                              ),
                                                                              Container(
                                                                                color: Theme.of(context).accentColor,
                                                                                height: 20,
                                                                                width: 2,
                                                                              ),
                                                                              RaisedButton(
                                                                                elevation: 4,
                                                                                color: Theme.of(context).primaryColor,
                                                                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    "Cancel",
                                                                                    style: TextStyle(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
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
                                  : SizedBox(),
                              SizedBox(height: 15),
                              (showPaymentButtons)
                                  ? Row(
                                      children: <Widget>[
                                        Spacer(),
                                        OutlineButton(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          color: Theme.of(context).canvasColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Container(
                                            child: Center(
                                                child: Text(
                                              "Bank-transfer",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          onPressed: () {
                                            int selectedRadio = 0;
                                            if (viewModel.numberOfAccounts !=
                                                0) {
                                              selectedAccountNumber = viewModel
                                                  .bankAccountList[0]
                                                  .bankAccountNumber;
                                              selectedAccountID = viewModel
                                                  .bankAccountList[0].accountID;
                                            }
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .canvasColor,
                                                    insetPadding:
                                                        EdgeInsets.all(10),
                                                    child: (viewModel
                                                                .numberOfAccounts ==
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
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .sentiment_very_dissatisfied,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .canvasColor,
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
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Theme.of(context).cardColor,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15.0)),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: (viewModel.bankAccountList.length == 1)
                                                                              ? Text("Confirm this account", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor))
                                                                              : Text(
                                                                                  "Choose an account for withdrawal",
                                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
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
                                                                                      activeColor: Theme.of(context).accentColor,
                                                                                      groupValue: selectedRadio,
                                                                                      onChanged: (val) {
                                                                                        setState(() => selectedRadio = val);
                                                                                        selectedAccountID = viewModel.bankAccountList[index].accountID;

                                                                                        if (viewModel.bankAccountList.length == 1) {
                                                                                          selectedAccountNumber = viewModel.bankAccountList[0].bankAccountNumber;
                                                                                          selectedAccountID = viewModel.bankAccountList[0].accountID.toString();
                                                                                        } else {
                                                                                          selectedAccountNumber = viewModel.bankAccountList[selectedRadio].bankAccountNumber;
                                                                                          selectedAccountID = viewModel.bankAccountList[selectedRadio].accountID.toString();
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                AvailableAccounts(
                                                                                  accountHoldersName: viewModel.bankAccountList[index].accountHoldersName,
                                                                                  accountNumber: viewModel.bankAccountList[index].bankAccountNumber,
                                                                                  isBankAccount: true,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          RaisedButton(
                                                                            elevation:
                                                                                4,
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            shape:
                                                                                new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "Next",
                                                                                style: TextStyle(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            onPressed: (viewModel.bankAccountList.length != 0)
                                                                                ? () {
                                                                                    if (viewModel.bankAccountList.length == 1) {
                                                                                      selectedAccountNumber = viewModel.bankAccountList[0].bankAccountNumber;
                                                                                      selectedAccountID = viewModel.bankAccountList[0].accountID.toString();
                                                                                    }
                                                                                    Navigator.pop(context);
                                                                                    _showPaymentWithdrawalModalSheet(selectedAccountNumber, selectedAccountID);
                                                                                  }
                                                                                : null,
                                                                          ),
                                                                          Container(
                                                                            color:
                                                                                Theme.of(context).accentColor,
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          RaisedButton(
                                                                            elevation:
                                                                                4,
                                                                            shape:
                                                                                new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "Cancel",
                                                                                style: TextStyle(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
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
                                  : SizedBox(),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Theme.of(context).cardColor),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 8),
                            child: Text(
                              "ENTER DEPOSIT AMOUNT",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                Constants.rupeeSign,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                // width: MediaQuery.of(context).size.width-50,
                                child: Form(
                                  key: _addAmountFormKey,
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).accentColor,
                                    validator: (value) {
                                      if (value.trim().isNotEmpty) {
                                        if (!isNumeric(value))
                                          return 'Enter a valid amount!';
                                        if (int.parse(value) <
                                            DataStore
                                                .metaData.minimumWalletDeposit)
                                          return 'Minimum deposit amount is ${DataStore.metaData.minimumWalletDeposit}';
                                      }
                                      if (value.isEmpty) {
                                        return 'Enter any amount';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText:
                                          "Eg: " + Constants.rupeeSign + "500",
                                      fillColor: Theme.of(context).cardColor,
                                      filled: true,
                                      errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    controller: walletDepositAmountController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            textColor: Colors.white,
                            onPressed: () {
                              if (_addAmountFormKey.currentState.validate()) {
                                Navigator.pop(context);
                                int depositAmount = int.parse(
                                    walletDepositAmountController.text);
                                _bloc.fire(WalletEvent.createWalletDeposit,
                                    message: {'Amount': depositAmount * 100},
                                    onHandled: (e, m) {
                                  var depositOptions = {
                                    'key': Constants.RAZORPAY_KEY,
                                    'order_id': "${m.paymentID}",
                                    'name': 'FIXBEE',
                                    'description': 'Wallet Deposit',
                                    'prefill': {
                                      'contact':
                                          '${DataStore.me.phoneNumber}' ??
                                              '1234567890',
                                      // 'email':
                                      //     '${DataStore.me.emailAddress}' ?? ''
                                    }
                                  };
                                  _razorpay.open(depositOptions);
                                });

                                walletDepositAmountController.clear();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          OutlineButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            borderSide: BorderSide(
                                width: 2, color: Theme.of(context).accentColor),
                            textColor: PrimaryColors.backgroundColor,
                            onPressed: () {
                              walletDepositAmountController.clear();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
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

  _showPaymentWithdrawalModalSheet(address, id) {
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
                                color: Theme.of(context).cardColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Selected Account:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                address,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Enter Amount for Withdrawal:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                Constants.rupeeSign,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                // width: MediaQuery.of(context).size.width-50,
                                child: Form(
                                  key: _withdrawAmountFormKey,
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).accentColor,
                                    validator: (value) {
                                      if (value.trim().isNotEmpty) {
                                        if (!isNumeric(value))
                                          return 'Enter a valid amount!';
                                        if (int.parse(value) * 100 >
                                            int.parse(
                                                    _BEENAME.get('myWallet')) -
                                                DataStore.metaData
                                                        .minimumWalletAmount *
                                                    100)
                                          return 'Minimum wallet amount is ${DataStore.metaData.minimumWalletAmount}';
                                      }
                                      if (value.isEmpty) {
                                        return 'Enter any amount';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Eg: " + Constants.rupeeSign + "500",
                                      fillColor: Theme.of(context).cardColor,
                                      filled: true,
                                      errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    controller: walletWithdrawAmountController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            textColor: Theme.of(context).canvasColor,
                            onPressed: () {
                              if (_withdrawAmountFormKey.currentState
                                  .validate()) {
                                Navigator.pop(context);
                                String withdrawAmount =
                                    walletWithdrawAmountController.text
                                        .toString();
                                int amount = int.parse(withdrawAmount) * 100;
                                _bloc.fire(WalletEvent.withdrawAmount,
                                    message: {
                                      'amount': amount,
                                      'accountId': id
                                    }, onHandled: (e, m) {
                                  _bloc.fire(
                                      WalletEvent
                                          .fetchWalletAmountAfterTransaction,
                                      onHandled: (e, m) {
                                    _BEENAME.put(
                                        "myWallet", m.amount.toString());
                                    walletAmountInpaise =
                                        int.parse(_BEENAME.get("myWallet"));
                                    if (walletAmountInpaise != null) {
                                      walletAmount = (walletAmountInpaise / 100)
                                          .toDouble();
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
                                "Withdraw",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          OutlineButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            borderSide: BorderSide(
                                width: 2, color: Theme.of(context).accentColor),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              walletWithdrawAmountController.clear();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Cancel",
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
        barrierDismissible: true,
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
