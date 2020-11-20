import 'dart:developer';
import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/custom_profile_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/custom_profile_event.dart';
import 'package:fixbee_partner/models/custom_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/display_picture.dart';
import 'package:fixbee_partner/ui/screens/bank_details.dart';
import 'package:fixbee_partner/ui/screens/customize_service.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/ui/screens/update_profile.dart';
import 'package:fixbee_partner/utils/custom_graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'billing_rating_screen.dart';

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
  String lastname;
  CustomProfileBloc _bloc;
  @override
  void initState() {
    _bloc = CustomProfileBloc(CustomProfileModel());
    _bloc.fire(CustomProfileEvent.downloadDp);
    _bloc.fire(CustomProfileEvent.checkForVerifiedAccount);
    firstname = DataStore.me.firstName;
    middlename = DataStore.me.middleName ?? "";
    lastname = DataStore.me.lastName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  _showLogoutDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure, you want to log out?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  CustomGraphQLClient.instance.invalidateWSClient();
                  CustomGraphQLClient.instance.invalidateClient();

                  Route route =
                      MaterialPageRoute(builder: (context) => SplashScreen());
                  Navigator.pushAndRemoveUntil(context, route, (e) => false);
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(414, 896), allowFontScaling: false);

    // ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    return Scaffold(
        backgroundColor: PrimaryColors.backgroundcolorlight,
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: Stack(
            children: <Widget>[
              Container(
                  decoration:
                      BoxDecoration(color: PrimaryColors.backgroundColor),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SvgPicture.asset(
                                "assets/logo/bee_outline.svg",
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
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
                      ),
                    ],
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
                        Container(
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
                                  imageURl: viewModel.imageUrl,
                                  loading: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: kSpacingUnit.w * 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getMyName(firstname, middlename, lastname),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    ScreenUtil().setSp(kSpacingUnit.w * 2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            (viewModel.verifiedAccount)
                                ? Icon(Icons.check_circle,
                                    color: Colors.blue,
                                    size: ScreenUtil().setSp(
                                      kSpacingUnit.w * 3,
                                    ))
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: kSpacingUnit.w * 1),
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
                                fontSize:
                                    ScreenUtil().setSp(kSpacingUnit.w * 2),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return VerificationDocuments();
                        }));
                      },
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.cog,
                      text: 'Update bank details',
                      task: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return BankDetails();
                        }));
                      },
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.user_plus,
                      text: 'Customize Selected Services',
                      task: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
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
      // floatingActionButton: FloatingActionButton(
      //   child: Text("Tap"),
      //   onPressed: (){
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (ctx) {
      //           return BillingRatingScreen(
      //             orderID: "5fb8050ec890200ec1be224c",
      //             userID: "5fabd5d1f8e3c71b8e056d3e",
      //           );
      //         }));
      //
      //   },
      // ),
    );

  }

  onImagePicked(String path) {
    _bloc.fire(CustomProfileEvent.updateDp,
        message: {"path": "$path", "file": "partnerDP"});
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
