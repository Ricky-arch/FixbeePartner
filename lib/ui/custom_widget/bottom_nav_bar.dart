import 'package:fixbee_partner/models/navigation_item.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onPageSelected;

  const BottomNavBar({this.onPageSelected});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with AutomaticKeepAliveClientMixin{
  Color backgroundColor = Colors.white;
  int selectedItem = 0;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.home,), Text("Home")),
    NavigationItem(Icon(Icons.event), Text("History")),
    NavigationItem(Icon(Icons.monetization_on), Text("Wallet")),
    NavigationItem(Icon(Icons.person_outline), Text("Profile")),

  ];


  Widget buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: isSelected
          ? EdgeInsets.only(left: 16, right: 16)
          : EdgeInsets.only(left: 8, right: 8),
      width: isSelected ? 125 : 50,
      height: double.maxFinite,
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.amber,
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
                    size: 24, color: isSelected ? backgroundColor : Colors.amber),
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

//0xff03a9f4
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5),
      ], color: Colors.white),
      //color: Colors.teal,
      width: MediaQuery.of(context).size.width,
      height: 50,
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
