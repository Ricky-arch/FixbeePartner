import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/blocs/custom_profile_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/custom_profile_event.dart';
import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/models/custom_profile_model.dart';
import 'package:fixbee_partner/ui/custom_widget/display_picture.dart';
import 'package:fixbee_partner/ui/screens/bank_details.dart';
import 'package:fixbee_partner/ui/screens/splash_screen.dart';
import 'package:fixbee_partner/ui/screens/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fixbee_partner/ui/screens/verification_documents.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSpacingUnit = 10;
const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);
final kTitleTextStyle = TextStyle(
  color: Colors.yellow,
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);
final kCaptionTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
    fontWeight: FontWeight.w100,
    color: Colors.black);
final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: PrimaryColors.backgroundColor,
);
final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
);

class CustomProfile extends StatefulWidget {
  @override
  _CustomProfileState createState() => _CustomProfileState();
}

class _CustomProfileState extends State<CustomProfile> {
  CustomProfileBloc _bloc;
  @override
  void initState() {
    _bloc = CustomProfileBloc(CustomProfileModel());
    _bloc.fire(CustomProfileEvent.downloadDp);
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
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  Route route = MaterialPageRoute(builder: (context) => SplashScreen());
                  Navigator.pushReplacement(context, route);
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          //backgroundColor: Data.backgroundColor,
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
                            child: Image.asset(
                              "assets/custom_icons/bee.png",
                              fit: BoxFit.cover,
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Profile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                    fontSize: 22)),
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
                        SizedBox(height: kSpacingUnit.w * 1),
                        Text(
                          DataStore.me.firstName +
                              " " +
                              DataStore.me.middleName +
                              " " +
                              DataStore.me.lastName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(kSpacingUnit.w * 2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: kSpacingUnit.w * 1),
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
                      task: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return UpdateProfile();
                        }));
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
                      text: 'Invite a Friend',
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.alternate_sign_out,
                      text: 'Logout',
                      hasNavigation: false,
                      task: _showLogoutDialogBox
                    ),
                  ],
                ),
              )
            ],
          );
        }));

  }

  onImagePicked(String path) {
    _bloc.fire(CustomProfileEvent.updateDp,
        message: {"path": "$path", "file": "partnerDP"});
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
