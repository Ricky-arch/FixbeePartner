import 'package:fixbee_partner/Constants.dart';
import 'package:flutter/material.dart';

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
        width: 60,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image(image: AssetImage("assets/images/beep.png",),height: 50, width: 50,),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PrimaryColors.backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: PrimaryColors.backgroundColor,
                  blurRadius: _animation.value,
                  spreadRadius: _animation.value)
            ]),
      ),
    );
  }
}
