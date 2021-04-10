import 'package:fixbee_partner/Constants.dart';
import 'package:fixbee_partner/models/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onPageSelected;

  const BottomNavBar({this.onPageSelected});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with AutomaticKeepAliveClientMixin {
  Color backgroundColor = PrimaryColors.backgroundColor;
  int selectedItem = 0;
  List<BottomNavigationItem> items = [
    BottomNavigationItem(
        Icon(
          Icons.dashboard,
        ),
        Text(
          "Home",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
    BottomNavigationItem(
        Icon(LineAwesomeIcons.history),
        Text(
          "Log",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
    BottomNavigationItem(
        Icon(LineAwesomeIcons.indian_rupee_sign),
        Text(
          "Wallet",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
    BottomNavigationItem(
        Icon(Icons.person_outline),
        Text(
          "Profile",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )),
  ];

  Widget buildItem(BottomNavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: isSelected
          ? EdgeInsets.only(left: 16, right: 16)
          : EdgeInsets.only(left: 8, right: 8),
      width: isSelected ? 125 : 50,
      height: double.maxFinite,
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                    size: 24,
                    color: isSelected ? backgroundColor : Colors.yellow),
                child: item.icon,
              ),
              isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DefaultTextStyle.merge(
                          child: item.title,
                          style: TextStyle(color: backgroundColor)),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5),
      ], color: PrimaryColors.backgroundColor),
      //color: Colors.teal,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 12,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            var itemIndex = items.indexOf(item);
            return GestureDetector(
              onTap: () {
                widget.onPageSelected(itemIndex);
                setState(() {
                  selectedItem = itemIndex;
                });
              },
              child: buildItem(item, selectedItem == itemIndex),
            );
          }).toList()),
    );
  }
}
