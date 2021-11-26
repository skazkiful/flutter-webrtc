import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// End call button on call page.
///
/// Return Material button.
/// [OnTap] returns [onClick] function to end call on call page.
class EndCallButton extends StatelessWidget {
  /// Function required and will initialize end call on call page.
  final Function onClick;
  EndCallButton({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: Color(0xFF990000),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () async {
          onClick();
        },
        child: Container(
          alignment: Alignment.center,
          height: 55,
          width: 55,
          child: Container(
            child: SvgPicture.asset('assets/end-call.svg'),
            width: 28,
          ),
        ),
      ),
    );
  }
}
