import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Toggle video button on call page.
///
/// Returns Material button.
/// Required [_onClick] function to toggle camera on call page.
/// Required [_status] bool to track current camera status on call page.
class ToggleVideoButton extends StatelessWidget {
  /// Variable need to track current camera status on call page.
  bool _status;
  /// Function need to toggle camera on call page.
  Function _onClick;
  ToggleVideoButton({required Function onClick, required bool status}): _status = status, _onClick = onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: (_status)
          ? Color(0xFFD9D9D9)
          : Color(0xFF6C6C6C),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          _onClick();
        },
        child: Container(
          alignment: Alignment.center,
          height: 55,
          width: 55,
          child: Container(
            child: (_status)
                ? SvgPicture.asset(
                'assets/video-off.svg')
                : SvgPicture.asset(
                'assets/video-on.svg'),
            width: 28,
          ),
        ),
      ),
    );
  }
}

