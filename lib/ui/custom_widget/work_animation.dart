import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkAnimation extends StatefulWidget {
  @override
  _WorkAnimationState createState() => _WorkAnimationState();
}

class _WorkAnimationState extends State<WorkAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset("assets/logo/bee_outline.svg",height: 50,width: 50,color: PrimaryColors.whiteColor,),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PrimaryColors.backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: PrimaryColors.yellowColor,
                  blurRadius: _animation.value,
                  spreadRadius: _animation.value)
            ]),
      ),
    );
  }
}
