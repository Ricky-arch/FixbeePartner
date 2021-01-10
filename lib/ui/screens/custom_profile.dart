import 'dart:developer';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/custom_profile_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/custom_profile_event.dart';
import 'package:fixbee_partner/models/custom_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/display_picture.dart';
import 'package:fixbee_partner/ui/screens/bank_details.dart';
import 'package:fixbee_partner/ui/screens/customize_service.dart';
import 'package:fixbee_partner/ui/screens/logout.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/ui/screens/update_profile.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSpacingUnit = 10;
const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);
final kTitleTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w600,
);

class CustomProfile extends StatefulWidget {
  @override
  _CustomProfileState createState() => _CustomProfileState();
}

class _CustomProfileState extends State<CustomProfile> {
  String firstname;
  String middlename;
  String lastname, n = "";
  CustomProfileBloc _bloc;
  bool verifiedBee;

  Box<String> _BEENAME;
  _openHive() async {
    _BEENAME = Hive.box<String>("BEE");
  }


  @override
  void initState() {
    _openHive();
    verifiedBee = _BEENAME.get("myDocumentVerification") == "true";
    print(_BEENAME.length.toString() + "LLL");
    print(_BEENAME.get("myName"));
    _bloc = CustomProfileBloc(CustomProfileModel());
    _bloc.fire(CustomProfileEvent.downloadDp, onHandled: (e, m) {
      _BEENAME.put("dpUrl", m.imageUrl);
    });
    _bloc.fire(CustomProfileEvent.checkForVerifiedAccount);
    firstname = DataStore.me.firstName;
    middlename = DataStore.me.middleName ?? "";
    lastname = DataStore.me.lastName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    // closeHiveBox();
    super.dispose();
  }


  _showLogoutDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to log out?"),
            actions: [
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              ),
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () async {
                  _bloc.fire(CustomProfileEvent.deactivateBee,
                      onHandled: (e, m) {
                    clearPreferences();
                    CustomGraphQLClient.instance.invalidateWSClient();
                    CustomGraphQLClient.instance.invalidateClient();
                    //closeHiveBox();
                    Route route =
                        MaterialPageRoute(builder: (context) => SplashScreen());
                    //Navigator.push(context, route);
                     Navigator.pushAndRemoveUntil(context, route, (e) => false);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }

  clearPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  closeHiveBox() async {
    //await Hive.close();
    await Hive.deleteBoxFromDisk("BEE");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(414, 896), allowFontScaling: false);

    return Scaffold(
      backgroundColor: PrimaryColors.backgroundcolorlight,
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'PROFILE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                    ],
                  ),
                ))
          ],
        ),
      ),
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: kSpacingUnit.w * 3),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ValueListenableBuilder(
                        valueListenable: _BEENAME.listenable(),
                        builder: (context, box, widget) {
                          return Container(
                            height: kSpacingUnit.w * 10,
                            width: kSpacingUnit.w * 10,
                            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: PrimaryColors.backgroundColor,
                                    width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Stack(
                                children: <Widget>[
                                  DisplayPicture(
                                    onImagePicked: onImagePicked,
                                    imageURl: _BEENAME.get("dpUrl"),
                                    loading: false,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: kSpacingUnit.w * 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _BEENAME.listenable(),
                            builder: (context, box, widget) {
                              return Text(
                                _BEENAME.get("myName"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      ScreenUtil().setSp(kSpacingUnit.w * 2),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          (verifiedBee)
                              ? Icon(Icons.check_circle,
                                  color: Colors.blue,
                                  size: ScreenUtil().setSp(
                                    kSpacingUnit.w * 3,
                                  ))
                              : SizedBox(),
                        ],
                      ),

                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Rated 4.5 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  ScreenUtil().setSp(kSpacingUnit.w * 1.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "\u2605",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: ScreenUtil().setSp(kSpacingUnit.w * 2),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ]),
                      ),
//                        Text(
//                          "Rated 4.5 \u2605",
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: ScreenUtil().setSp(kSpacingUnit.w*1.7),
//                            fontWeight: FontWeight.w600,
//                          ),
//                        ),
                      SizedBox(height: kSpacingUnit.w * 3),
                    ],
                  ),
                ),
                SizedBox(width: kSpacingUnit.w * 3),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ProfileListItem(
                    icon: LineAwesomeIcons.user_shield,
                    text: 'Update Personal',
                    task: () async {
                      String updated = await Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) {
                        return UpdateProfile();
                      }));
                      if (updated ==
                          "CHANGED TO PERSONAL ADDED SUCCESSFULLY!") {
                        _onProfileUpdatedDialogBox(updated);
                        setState(() {
                          firstname = DataStore.me.firstName;
                          middlename = DataStore.me.middleName ?? "";
                          lastname = DataStore.me.lastName ?? "";
                        });
                        log(updated, name: "UPDATED");
                      }
                    },
                  ),
                  ProfileListItem(
                    icon: LineAwesomeIcons.folder,
                    text: 'Upload Verification Documents',
                    task: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return VerificationDocuments();
                      }));
                    },
                  ),
                  ProfileListItem(
                    icon: LineAwesomeIcons.cog,
                    text: 'Update bank details',
                    task: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return BankDetails();
                      }));
                    },
                  ),
                  ProfileListItem(
                    icon: LineAwesomeIcons.user_plus,
                    text: 'Customize Selected Services',
                    task: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return CustomizeService();
                      }));
                    },
                  ),
                  ProfileListItem(
                      icon: LineAwesomeIcons.alternate_sign_out,
                      text: 'Logout',
                      hasNavigation: false,
                      task: _showLogoutDialogBox),
                ],
              ),
            )
          ],
        );
      }),
      //   floatingActionButton: FloatingActionButton(
      //     child: Text("Tap"),
      //     onPressed: (){
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (ctx) {
      //             return ServiceSelectionScreen();
      //           }));
      //
      //     },
      //   ),
    );
  }

  onImagePicked(String path) {
    _bloc.fire(CustomProfileEvent.updateDp,
        message: {"path": "$path", "file": "partnerDP"}, onHandled: (e, m) {
      _BEENAME.put("dpUrl", m.imageUrl);
    });
  }

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  _onProfileUpdatedDialogBox(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              maxLines: null,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              RaisedButton(
                color: PrimaryColors.backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              )
            ],
          );
        });
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final Function task;

  const ProfileListItem(
      {Key key, this.icon, this.text, this.hasNavigation = true, this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: task,
      child: Container(
        height: kSpacingUnit.w * 5.5,
        margin: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 4,
        ).copyWith(
          bottom: kSpacingUnit.w * 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
          color: PrimaryColors.backgroundColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: kSpacingUnit.w * 2.5,
              color: Colors.yellow,
            ),
            SizedBox(width: kSpacingUnit.w * 1.5),
            Text(
              this.text,
              style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            (this.hasNavigation)
                ? Icon(
                    LineAwesomeIcons.angle_right,
                    size: kSpacingUnit.w * 2.5,
                    color: Colors.yellow,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
