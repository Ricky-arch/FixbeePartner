import 'package:fixbee_partner/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomPanel extends StatelessWidget {
  final String title, value;

  const CustomPanel({Key key, this.title, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 12),
      child: Theme(
        data: Theme.of(context)
            .copyWith(textSelectionColor: FixbeeColors.kCardColorLighter),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: SelectableText(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SelectableText(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
