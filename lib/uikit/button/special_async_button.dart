import 'package:async_button/async_button.dart';
import 'package:flutter/material.dart';

import '../../core/base/base_singleton.dart';
import '../../core/extensions/ui_extensions.dart';

class SpecialAsyncButton extends StatelessWidget with BaseSingleton {
  final Future<void> Function(AsyncButtonStateController) onTap;
  final String buttonLabel;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final double? elevation;
  final BorderRadiusGeometry borderRadius;
  final Color? buttonLabelColor;
  final bool isHasIcon;
  final IconData icon;
  SpecialAsyncButton({
    super.key,
    required this.onTap,
    required this.buttonLabel,
    this.padding,
    this.bgColor,
    this.elevation,
    this.borderRadius = BorderRadius.zero,
    this.buttonLabelColor,
    this.isHasIcon = false,
    this.icon = Icons.abc,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: bgColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      loadingStyle: AsyncButtonStateStyle(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.amber,
        ),
        widget: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(
            color: colors.white,
          ),
        ),
      ),
      successStyle: AsyncButtonStateStyle(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.green,
          foregroundColor: colors.white,
        ),
        widget: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check),
            SizedBox(width: 4),
            Text('Success!')
          ],
        ),
      ),
      failureStyle: AsyncButtonStateStyle(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.redAccent,
          foregroundColor: colors.white,
        ),
        widget: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error),
            SizedBox(width: 4),
            Text('Error!'),
          ],
        ),
      ),
      child: isHasIcon
          ? Row(
              mainAxisAlignment: context.mainAxisACenter,
              children: [
                Icon(icon),
                context.emptySizedWidthBox2x,
                Text(
                  buttonLabel,
                  style: TextStyle(color: buttonLabelColor),
                ),
              ],
            )
          : Text(
              buttonLabel,
              style: TextStyle(color: buttonLabelColor),
            ),
    );
  }
}
