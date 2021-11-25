import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Toggle microphone button on call page.
///
/// Returns Material button.
/// Required [_onClick] function to toggle microphone on call page.
/// Required [_status] bool to track current microphone status on call page.
class ToggleAudioButton extends StatelessWidget {
  /// Variable need to toggle microphone on call page.
  final bool _status;

  /// Function need to toggle microphone on call page.
  final Function _onClick;
  ToggleAudioButton({required Function onClick, required bool status})
      : _status = status,
        _onClick = onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: (_status) ? Color(0xFFD9D9D9) : Color(0xFF6C6C6C),
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
            child: (_status)
                ? SvgPicture.asset('assets/mic-off.svg')
                : SvgPicture.asset('assets/mic-on.svg'),
            width: 28,
          ),
        ),
      ),
    );
  }
}
