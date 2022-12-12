import 'package:flutter/material.dart';

import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/button/special_button.dart';

class AuthButton extends StatelessWidget with BaseSingleton {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  const AuthButton({
    super.key,
    required this.icon,
    required this.iconColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpecialButton(
      padding: context.padding2x,
      bgColor: colors.white,
      borderSide: BorderSide(color: colors.grey3),
      borderRadius: context.borderRadius2x,
      onTap: onTap,
      child: Icon(
        icon,
        color: iconColor,
        size: 32,
      ),
    );
  }
}
