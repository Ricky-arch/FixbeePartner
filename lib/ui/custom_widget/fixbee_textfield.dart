import 'package:flutter/material.dart';
class FixbeeTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final Future<void> Function(String text) submit;
  final bool editable;
  final String initialText;
  final bool notSet;
  final Color color;
  final String buttonText;
  final void Function() onTapButton;

  const FixbeeTextField({
    Key key,
    @required this.icon,
    @required this.label,
    this.submit,
    this.editable = false,
    this.initialText = '',
    this.notSet = true,
    this.color,
    this.buttonText,
    this.onTapButton,
  }) : super(key: key);
  @override
  _FixbeeTextFieldState createState() => _FixbeeTextFieldState();
}

class _FixbeeTextFieldState extends State<FixbeeTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _editable = false;
  bool _loading = false;
  bool _notSet;
  bool _sideButtonUpdate = false;

  @override
  void initState() {
    _notSet = widget.notSet;
    _controller.text = widget.initialText;
    if (_notSet) {
      _controller.text = 'Not set';
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                right: 0.024 * MediaQuery.of(context).size.width),
            child: Icon(
              widget.icon,
              size: 0.052 * MediaQuery.of(context).size.width,
              color: widget.color ?? Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.label.toUpperCase(),
                            style: TextStyle(
                              fontSize:
                              0.025 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w500,
                              color: widget.color ??
                                  Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 0.002 * MediaQuery.of(context).size.height,
                          ),
                          widget.editable
                              ? EditableText(
                            onEditingComplete: () async {
                              setState(() {
                                _editable = false;
                                _loading = true;
                              });
                              _sideButtonUpdate = false;
                              await widget.submit(_controller.text);
                              setState(() {
                                _loading = false;
                              });
                            },
                            readOnly: !_editable || _notSet,
                            showSelectionHandles: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              fontSize: 0.036 *
                                  MediaQuery.of(context).size.width,
                              color: _notSet
                                  ? Colors.white.withOpacity(0.38)
                                  : Colors.white.withOpacity(0.80),
                            ),
                            controller: _controller,
                            backgroundCursorColor: Colors.pink,
                            focusNode: _focusNode,
                            cursorColor: Theme.of(context).primaryColor,
                          )
                              : Text(
                            widget.initialText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              fontSize: 0.036 *
                                  MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(0.80),
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.buttonText != null
                        ? Padding(
                      padding: EdgeInsets.all(
                        0.009 * MediaQuery.of(context).size.width,
                      ),
                      child: InkWell(
                        onTap: widget.onTapButton,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.color,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              0.009 * MediaQuery.of(context).size.width,
                            ),
                            child: Text(
                              widget.buttonText,
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 0.031 *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : (widget.editable
                        ? Padding(
                      padding: EdgeInsets.only(
                        left:
                        0.018 * MediaQuery.of(context).size.width,
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (_sideButtonUpdate) {
                            setState(() {
                              _editable = false;
                              _loading = true;
                            });
                            _sideButtonUpdate = false;
                            await widget.submit(_controller.text);
                            setState(() {
                              _loading = false;
                            });
                            FocusScope.of(context)
                                .requestFocus(FocusNode());
                            _sideButtonUpdate = false;
                          } else {
                            if (_notSet) {
                              _controller.clear();
                            }
                            setState(() {
                              _notSet = false;
                              _editable = true;
                            });
                            _sideButtonUpdate = true;
                            _focusNode.requestFocus();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _loading
                                  ? Colors.green
                                  : (_sideButtonUpdate
                                  ? Colors.red
                                  : Theme.of(context)
                                  .primaryColor),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              0.009 *
                                  MediaQuery.of(context).size.width,
                            ),
                            child: Text(
                              _loading
                                  ? 'UPDATING...'
                                  : (!_editable ? 'EDIT' : 'UPDATE'),
                              style: TextStyle(
                                fontWeight: _sideButtonUpdate
                                    ? FontWeight.w500
                                    : null,
                                color: _loading
                                    ? Colors.green
                                    : (_sideButtonUpdate
                                    ? Colors.red
                                    : Theme.of(context)
                                    .primaryColor),
                                fontSize: 0.031 *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : SizedBox()),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 0.008 * MediaQuery.of(context).size.height,
                    bottom: 0.004 * MediaQuery.of(context).size.height,
                  ),
                  child: Container(
                    height: 0.5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}