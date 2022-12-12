import 'package:flutter/material.dart';
import '../../core/extensions/ui_extensions.dart';
import '../../core/utils/navigation_service.dart';

class NavbarModel extends BottomNavigationBarItem {
  NavbarModel({
    Key? key,
    required IconData icon,
    required String label,
  }) : super(
          icon: Padding(
            padding: _padding,
            child: Icon(icon),
          ),
          label: label,
        );

  static EdgeInsets get _padding {
    var context = NavigationService.navigatorKey.currentContext!;
    double val3x = context.val3x;
    double val1x = context.val1x;
    return EdgeInsets.fromLTRB(
      val3x,
      val3x,
      val3x,
      val1x,
    );
  }
}
