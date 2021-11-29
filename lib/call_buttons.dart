import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Toggle microphone button on call page.
///
/// Returns Material button.
/// Required [onClick] function to toggle microphone on call page.
/// Required [_status] bool to track current microphone status on call page.
class ToggleCallButtons extends StatelessWidget {
  ToggleCallButtons(
      {required this.onClick,
      required this.enabledColor,
      required this.iconOn,
      this.key,
      this.status = true,
      this.toggleColor,
      this.iconOff});

  ///
  final Key? key;

  /// Variable need to toggle microphone on call page.
  final bool status;

  /// Function need to toggle microphone on call page.
  final Function onClick;

  /// Variable used to define color which used when status is true
  final Color enabledColor;

  /// Variable used to define color which used when status is false
  final Color? toggleColor;

  /// Variable used to define icon which used when status is true
  final String iconOn;

  /// Variable used to define icon which used when status is false
  final String? iconOff;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: (status) ? enabledColor : toggleColor,
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
            height: 28,
            child: (status)
                ? SvgPicture.asset(iconOn)
                : SvgPicture.asset(iconOff!),
          ),
        ),
      ),
    );
  }
}
