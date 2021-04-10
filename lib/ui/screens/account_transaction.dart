import 'package:fixbee_partner/blocs/bank_details_bloc.dart';
import 'package:fixbee_partner/events/bank_details_event.dart';
import 'package:fixbee_partner/models/bank_details_model.dart';
import 'package:fixbee_partner/ui/custom_widget/available_accounts.dart';
import 'package:fixbee_partner/ui/custom_widget/bank_account_withdrawl.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/fund_account_widget.dart';
import 'package:fixbee_partner/ui/custom_widget/vpa_withdrawal.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

class AccountTransaction extends StatefulWidget {
  @override
  _AccountTransactionState createState() => _AccountTransactionState();
}

class _AccountTransactionState extends State<AccountTransaction> {
  BankDetailsBloc _bloc;
  TextEditingController _bankAccountNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _accountHoldersName = TextEditingController();
  TextEditingController _vpaController = TextEditingController();
  final _bankKey = GlobalKey<FormState>();
  final _vpaKey = GlobalKey<FormState>();
  bool _bankValidate = false;
  bool _vpaValidate = false;

  @override
  void initState() {
    _bloc = BankDetailsBloc(BankDetailsModel());
    _bloc.fire(BankDetailsEvent.fetchAvailableAccounts);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              titleSpacing: 0,
              elevation: 3,
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 12, 12, 0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Your  ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        TextSpan(
                          text:
                          "Transaction Accounts",
                          style: TextStyle(
                              fontSize: 26,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 3,
                            color: Theme.of(context).accentColor,
                          ),
                          insets: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5)),
                      tabs: [
                        Tab(
                          child: Text(
                            'BANK-ACCOUNTS',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'VPA',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            SliverFillRemaining(
                child: _bloc.widget(onViewModelUpdated: (context, viewModel) {
              return TabBarView(children: [
                Tab(
                    child: (viewModel.fetchingBankAccounts)
                        ? CustomCircularProgressIndicator()
                        : (viewModel.bankAccountList.length == 0)
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  addButton(false),
                                  Spacer(),
                                  Text('No Bank Account added!'),
                                  Spacer(),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: FundAccountWidget(
                                        isBankAccount: true,
                                        list: viewModel.bankAccountList),
                                  ),
                                  addButton(true)
                                ],
                              )),
                Tab(
                    child: (viewModel.fetchingBankAccounts)
                        ? CustomCircularProgressIndicator()
                        : (viewModel.vpaList.length == 0)
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  addButton(false),
                                  Spacer(),
                                  Text('No VPA added!'),
                                  Spacer(),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: FundAccountWidget(
                                        isBankAccount: false,
                                        list: viewModel.vpaList),
                                  ),
                                  addButton(false)
                                ],
                              )),
              ]);
            }))
          ],
        ),
      ),
    ));
  }

  Widget addButton(bool isBankAccount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: RaisedButton(
            onPressed: () {
              newAccountForm(isBankAccount);
            },
            color: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Text(
              (isBankAccount) ? "Add Bank Account" : "Add VPA/UPI",
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
          ),
        ),
      ],
    );
  }

  newAccountForm(bool isBankAccount) {
    if (!isBankAccount)
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VpaWithdrawal(
          addVpa: (value) {
            if (value.isNotEmpty) {
              _bloc.fire(BankDetailsEvent.addVpaAddress,
                  message: {'vpa': value.trim()}, onHandled: (e, m) {
                if (m.vpaAdded) {
                  _showMessageDialog('Vpa Added Successfully!');
                  VpaModel newVpa = VpaModel();
                  newVpa.address = value;
                  _bloc.vPas.insert(0, newVpa);
                } else
                  _showMessageDialog('Unable to add VPA');
              });
            }
          },
        );
      }));
    else
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BankAccountWithdrawal(
          bankDetails: (value) {
            if (value.isNotEmpty) {
              _bloc.fire(BankDetailsEvent.addBankAccount, message: {
                'accountHoldersName': value['accountHolderName'],
                'accountNumber': value['accountNumber'],
                'ifscCode': value['ifsc']
              }, onHandled: (e, m) {
                if (m.bankAccountAdded) {
                  _showMessageDialog('Bank Account Added Successfully');
                  BankModel bm = BankModel();
                  bm.bankAccountNumber = value['accountNumber'];
                  bm.accountHoldersName = value['accountHolderName'];
                  bm.ifscCode = value['ifsc'];
                  _bloc.bankAccounts.insert(0, bm);
                } else
                  _showMessageDialog('Unable to add Bank Account');
              });
            }
          },
        );
      }));
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
            ),
          );
        });
  }
}
