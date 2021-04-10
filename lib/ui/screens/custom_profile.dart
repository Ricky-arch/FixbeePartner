import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/custom_profile_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/custom_profile_event.dart';
import 'package:fixbee_partner/models/custom_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/display_picture.dart';
import 'package:fixbee_partner/ui/screens/account_transaction.dart';
import 'package:fixbee_partner/ui/screens/customize_service.dart';
import 'package:fixbee_partner/ui/screens/registration.dart';
import 'package:fixbee_partner/ui/screens/support.dart';
import 'package:fixbee_partner/ui/screens/profile_update.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/ui/screens/transaction_account.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_service_selection_screen.dart';
import 'login.dart';

const kSpacingUnit = 10;
const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);
final kTitleTextStyle = TextStyle(
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
  var myRating;
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

    _bloc = CustomProfileBloc(CustomProfileModel());
    _bloc.fire(CustomProfileEvent.downloadDp, onHandled: (e, m) {
      _BEENAME.put("dpUrl", m.imageUrl);
      DataStore.me.dpUrl = m.imageUrl;
    });
    //_bloc.fire(CustomProfileEvent.checkForVerifiedAccount);
    firstname = DataStore.me.firstName;
    middlename = DataStore.me.middleName ?? "";
    lastname = DataStore.me.lastName ?? "";

    _getRating();
    super.initState();
  }

  _getRating() async {
    myRating = _BEENAME.get('myRating');
    if (myRating == null) {
      myRating = await _bloc.getRating();
      _BEENAME.put("myRating", myRating.toString());
    }
    _BEENAME.put("myRating", myRating.toString());

    return myRating;
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
            backgroundColor: Theme.of(context).canvasColor,
            content: Text(
              "Do you want to log out?",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            actions: [
              RaisedButton(
                color: Theme.of(context).canvasColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              RaisedButton(
                color: Theme.of(context).canvasColor,
                onPressed: () async {
                  _bloc.fire(CustomProfileEvent.deactivateBee,
                      onHandled: (e, m) {
                    clearPreferences();
                    CustomGraphQLClient.instance.invalidateWSClient();
                    CustomGraphQLClient.instance.invalidateClient();
                    //closeHiveBox();
                    Route route =
                        MaterialPageRoute(builder: (context) => SplashScreen());
                    Navigator.pushAndRemoveUntil(context, route, (e) => false);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "YES",
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
    await Hive.deleteBoxFromDisk("BEE");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(414, 896), allowFontScaling: false);
    return Scaffold(
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return Column(
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return Support();
                          }));
                        },
                        icon: Icon(
                          Icons.widgets_rounded,
                          color: Theme.of(context).canvasColor,
                          size: 20,
                        ),
                      )),
                ),
              ],
            ),
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
                                    color: PrimaryColors.whiteColor, width: 1)),
                            child: Stack(
                              children: <Widget>[
                                DisplayPicture(
                                  onImagePicked: onImagePicked,
                                  imageURl: _BEENAME.get("dpUrl"),
                                  loading: false,
                                  verified: verifiedBee,
                                  onVerifiedBee: (value) {
                                    if (value) _showSnackBar();
                                  },
                                ),
                              ],
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
                                  color: Theme.of(context).primaryColor,
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
                            text: (myRating.toString() == null)
                                ? 'Rating: 0'
                                : 'Rating: ' + myRating.toString(),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
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
                    icon: (verifiedBee)
                        ? LineAwesomeIcons.lock
                        : LineAwesomeIcons.user_shield,
                    text: 'Update Personal',
                    task: () async {
                      if (!verifiedBee)
                        String updated = await Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return ProfileUpdate();
                        }));
                      else
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Cannot update if you are a verified bee! Visit branch!')));
                    },
                  ),
                  ProfileListItem(
                    icon: (verifiedBee)
                        ? LineAwesomeIcons.lock
                        : LineAwesomeIcons.folder,
                    text: 'Upload Verification Documents',
                    task: () {
                      if (!verifiedBee)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return VerificationDocuments();
                        }));
                      else
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Cannot update if you are a verified bee! Visit branch!')));
                    },
                  ),
                  ProfileListItem(
                    icon: LineAwesomeIcons.cog,
                    text: 'Add Transaction Account',
                    task: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return AccountTransaction();
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
    );
  }

  onImagePicked(String path) {
    _bloc.fire(CustomProfileEvent.updateDp, message: {
      "path": "$path",
      "file": "partnerDP",
      'tags': Constants.DISPLAY_PICTURE_TAG
    }, onHandled: (e, m) {
      if (m.dpUploaded)
        _BEENAME.put("dpUrl", m.imageUrl);
      else
        _showMessageDialog(
            'Unable to upload display picture try reducing image size below 1-MB!');
    });
  }

  String getMyName(String first, middle, last) {
    String name = first;
    if (middle != "") name = name + " " + middle;
    if (last != "") name = name + " " + last;
    return name;
  }

  _showMessageDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4,
            backgroundColor: PrimaryColors.backgroundColor,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          );
        });
  }

  _showSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('Cannot update if you are a verified bee! Visit branch!')));
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
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: kSpacingUnit.w * 2.5,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(width: kSpacingUnit.w * 1.5),
            Text(
              this.text,
              style: kTitleTextStyle.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            (this.hasNavigation)
                ? Icon(
                    LineAwesomeIcons.angle_right,
                    size: kSpacingUnit.w * 2.5,
                    color: Theme.of(context).accentColor,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
