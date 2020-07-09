import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/ui/screens/bank_details.dart';
import 'package:fixbee_partner/ui/screens/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: PrimaryColors.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: Colors.yellow,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            'Chota Bheem',
            style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(kSpacingUnit.w * 2),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 1),
        ],
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        profileInfo,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        //backgroundColor: Data.backgroundColor,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
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
      body: Column(
        children: <Widget>[
          header,
          Expanded(
            child: ListView(
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user_shield,
                  text: 'Update Profile',
                  task: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return UpdateProfile();
                    }));
                  },
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Help & Support',
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
                  text: 'Invite a Friend',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: 'Logout',
                  hasNavigation: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
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
    return Container(
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
              ? GestureDetector(
                  child: Icon(
                    LineAwesomeIcons.angle_right,
                    size: kSpacingUnit.w * 2.5,
                    color: Colors.yellow,
                  ),
                  onTap: task,
                )
              : SizedBox()
        ],
      ),
    );
  }
}
