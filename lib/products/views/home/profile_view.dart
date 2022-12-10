import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/extensions/ui_extensions.dart';
import 'package:todo_app/features/components/container/todo_info_container.dart';
import 'package:todo_app/uikit/button/special_button.dart';
import 'package:todo_app/uikit/decoration/special_container_decoration.dart';

import '../../../core/enums/alert_enum.dart';
import '../../viewmodels/navbar_view_model.dart';
import '../common/navbar_view.dart';

class ProfileView extends StatelessWidget with BaseSingleton {
  const ProfileView({super.key});

  _goToTodoPage(
    BuildContext context,
    int currentIndex,
  ) {
    final pv = Provider.of<NavbarViewModel>(context, listen: false);
    pv.currentIndex = currentIndex;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const NavbarView(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInRight(
          child: Text(AppLocalizations.of(context)!.myProfile),
        ),
      ),
      body: FadeInLeft(
        child: ListView(
          padding: context.padding2x,
          children: [_profileContainer(context)],
        ),
      ),
    );
  }

  Container _profileContainer(BuildContext context) {
    return Container(
      decoration: SpecialContainerDecoration(context: context),
      padding: context.padding4x,
      child: Column(
        crossAxisAlignment: context.crossAxisAStart,
        children: [
          _myDetailsAndLogoutButton(context),
          context.emptySizedHeightBox3x,
          _todosContainer(context),
          context.emptySizedHeightBox3x,
          _doneTodoContainer(context),
          context.emptySizedHeightBox3x,
        ],
      ),
    );
  }

  Row _myDetailsAndLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: context.mainAxisASpaceBetween,
      children: [
        _myDetails(context),
        _logoutButton(context),
      ],
    );
  }

  Row _myDetails(BuildContext context) {
    return Row(
      children: [
        icons.person,
        context.emptySizedWidthBox3x,
        Text(
          AppLocalizations.of(context)!.myDetails,
          style:
              context.textTheme.subtitle1!.copyWith(fontWeight: context.fw700),
        ),
      ],
    );
  }

  SpecialButton _logoutButton(BuildContext context) {
    bool isHasIcon = true;
    return SpecialButton(
      onTap: () {
        uiGlobals.showAlertDialog(
            context: context,
            alertEnum: AlertEnum.AREUSURE,
            contentTitle: AppLocalizations.of(context)!.areYouSure,
            contentSubtitle: AppLocalizations.of(context)!.logoutAlertContent,
            buttonLabel: AppLocalizations.of(context)!.yesButton,
            secondButtonLabel: AppLocalizations.of(context)!.noButton);
      },
      borderRadius: context.borderRadius2x,
      buttonLabel: AppLocalizations.of(context)!.logoutButton,
      isHasIcon: isHasIcon,
      icon: Icons.logout,
    );
  }

  TodoInfoContainer _todosContainer(BuildContext context) {
    return TodoInfoContainer(
      title: "You have created x todos.",
      icon: Icons.article,
      onTapSeeAllButton: () => _goToTodoPage(context, 0),
    );
  }

  TodoInfoContainer _doneTodoContainer(BuildContext context) {
    return TodoInfoContainer(
      title: "You have complated x todos.",
      icon: Icons.task,
      onTapSeeAllButton: () => _goToTodoPage(context, 1),
    );
  }
}
