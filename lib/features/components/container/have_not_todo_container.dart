import 'package:flutter/material.dart';
import '../../../core/extensions/ui_extensions.dart';

import '../../../uikit/decoration/special_container_decoration.dart';
import '../circle_avatar/circle_avatar_inside_icon.dart';

class HaveNotTodoContainer extends StatelessWidget {
  final String title;
  const HaveNotTodoContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: SpecialContainerDecoration(context: context),
      padding: context.padding4x,
      margin: context.padding2x,
      child: Row(
        children: [
          const CircleAvatarInsideIcon(icon: Icons.mood),
          context.emptySizedWidthBox3x,
          Expanded(
            child: Text(
              title,
              textAlign: context.taCenter,
              style: context.textTheme.subtitle1!
                  .copyWith(fontWeight: context.fw700),
            ),
          ),
        ],
      ),
    );
  }
}
