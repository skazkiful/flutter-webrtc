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
      required this.color,
      required this.icon,
      this.key});

  ///
  final Key? key;

  /// Function need to toggle microphone on call page.
  final Function onClick;

  /// Variable used to define color
  final Color color;

  /// Variable used to define icon
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: color,
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
            child: SvgPicture.asset(icon),
          ),
        ),
      ),
    );
  }
}
