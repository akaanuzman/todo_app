import 'package:flutter/material.dart';
import '../../../core/extensions/ui_extensions.dart';

class CircleAvatarInsideIcon extends StatelessWidget {
  final IconData icon;
  const CircleAvatarInsideIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.2),
      height: context.dynamicWidth(0.2),
      child: CircleAvatar(
        child: Icon(
          icon,
          size: context.dynamicWidth(0.15),
        ),
      ),
    );
  }
}
