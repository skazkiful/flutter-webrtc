import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// End call button on call page.
///
/// Return Material button.
/// [OnTap] returns [_onClick] function to end call on call page.
class EndCallButton extends StatelessWidget {
  /// Function required and will initialize end call on call page.
  Function _onClick;
  EndCallButton({required Function onClick}): _onClick = onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: Color(0xFF990000),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () async {
          _onClick();
        },
        child: Container(
          alignment: Alignment.center,
          height: 55,
          width: 55,
          child: Container(
            child: SvgPicture.asset(
                'assets/end-call.svg'),
            width: 28,
          ),
        ),
      ),
    );
  }
}
