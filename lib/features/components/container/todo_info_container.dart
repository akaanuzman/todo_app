import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/decoration/special_container_decoration.dart';

class TodoInfoContainer extends StatelessWidget with BaseSingleton {
  final String title;
  final VoidCallback? onTapSeeAllButton;
  final IconData icon;
  const TodoInfoContainer({
    super.key,
    required this.title,
    required this.icon,
    this.onTapSeeAllButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _todoContainer(context),
    );
  }

  Container _todoContainer(BuildContext context) {
    return Container(
      padding: context.padding2x,
      decoration: SpecialContainerDecoration(
        context: context,
        color: colors.grey1,
      ),
      child: Column(
        children: [
          context.emptySizedHeightBox1x,
          _icon(context),
          context.emptySizedHeightBox1x,
          _title(context),
          _seeAllButton(context)
        ],
      ),
    );
  }

  Icon _icon(BuildContext context) {
    return Icon(
      icon,
      size: context.dynamicWidth(0.15),
    );
  }

  Text _title(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.subtitle1!.copyWith(fontWeight: context.fw700),
    );
  }

  TextButton _seeAllButton(BuildContext context) {
    return TextButton(
      onPressed: onTapSeeAllButton,
      child: Text(AppLocalizations.of(context)!.seeAllButton),
    );
  }
}
