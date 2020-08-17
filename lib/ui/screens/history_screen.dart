import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(

                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                titleSpacing: 0,
                backgroundColor: Colors.white,
                elevation: 3,
                title: Container(
                  height: 50,
                  color: PrimaryColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.event,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 40),
                            Center(
                                child: Text(
                              "History",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(indicatorColor: Colors.black, tabs: [
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(LineAwesomeIcons.amazon_pay_credit_card),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          'TRANSACTION',
                          style: TextStyle(
                              color: PrimaryColors.backgroundColor,
                              fontSize: MediaQuery.of(context).size.width / 30),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(LineAwesomeIcons.play_circle),
                        SizedBox(
                          height: 1,
                        ),
                        Text('ACTIVE',
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30)),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(LineAwesomeIcons.pause_circle),
                        SizedBox(
                          height: 1,
                        ),
                        Text('REJECTED',
                            style: TextStyle(
                                color: PrimaryColors.backgroundColor,
                                fontSize:
                                    MediaQuery.of(context).size.width / 30)),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SliverFillRemaining(
                  child: TabBarView(
                children: <Widget>[
                  Tab(
                    child: Text('TRANSACTIONS',
                        style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child:
                        Text('ACTIVE', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child:
                        Text('REJECTED', style: TextStyle(color: Colors.black)),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
