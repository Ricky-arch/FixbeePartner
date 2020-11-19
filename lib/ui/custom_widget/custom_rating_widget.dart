import 'package:fixbee_partner/blocs/rating_bloc.dart';
import 'package:fixbee_partner/events/rating_event.dart';
import 'package:fixbee_partner/models/rating_model.dart';
import 'package:fixbee_partner/ui/custom_widget/smiley_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Constants.dart';
import '../../bloc.dart';

class CustomRatingWidget extends StatefulWidget {
  final String userName;

  final String userID;

  const CustomRatingWidget({Key key, this.userName, this.userID})
      : super(key: key);

  @override
  _CustomRatingWidgetState createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  double _rating = 5.0;
  String _currentAnimation = '5+';
  SmileyController _smileyController = SmileyController();
  TextEditingController shortReview = TextEditingController();
  Bloc _bloc;
  @override
  void initState() {
    _bloc = RatingBloc(RatingModel());
    super.initState();
  }

  @override
  void dispose() {
    shortReview.clear();
    shortReview.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _onChanged(double value) {
    if (_rating == value) return;

    setState(() {
      var direction = _rating < value ? '+' : '-';
      _rating = value;
      _currentAnimation = '${value.round()}$direction';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
      return Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Slider(
                    inactiveColor: PrimaryColors.yellowColor,
                    activeColor: PrimaryColors.backgroundColor,
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: _onChanged,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Rate user ${widget.userName}: ",
                          style: TextStyle(
                              color: PrimaryColors.backgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '$_rating',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "\u2605",
                          style: TextStyle(color: Colors.amber, fontSize: 22))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add an short review?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: TextFormField(
                      cursorColor: PrimaryColors.backgroundColor,
                      controller: shortReview,
                      decoration: InputDecoration(
                          hintText: "Write here...",
                          filled: true,
                          fillColor: PrimaryColors.backgroundcolorlight),
                      maxLines: null,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        color: PrimaryColors.yellowColor.withOpacity(.5),
                        onPressed: () {
                          _bloc.fire(RatingEvent.addRatingEvent, message: {
                            "accountID": widget.userID,
                            "Score": _rating.toInt(),
                            "Review": shortReview.text.toString()
                          }, onHandled: (e,m){
                            Navigator.of(context).pop();
                          });

                        },
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: Container(
                height: MediaQuery.of(context).size.width / 3.2,
                width: MediaQuery.of(context).size.width / 3.2,
                child: FlareActor(
                  "assets/animations/happiness_emoji.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  controller: _smileyController,
                  animation: _currentAnimation,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
