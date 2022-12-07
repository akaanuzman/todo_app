import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/extensions/ui_extensions.dart';

import '../../../uikit/button/special_button.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';

class RegisterView extends StatelessWidget with BaseSingleton {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInLeft(
          child: Text(AppLocalizations.of(context)!.registerAppBar),
        ),
      ),
      body: FadeInRight(
        child: _body(context),
      ),
    );
  }

  Center _body(BuildContext context) {
    bool shrinkWrap = true;
    return Center(
      child: ListView(
        padding: context.padding4x,
        shrinkWrap: shrinkWrap,
        children: [
          Icon(
            Icons.person,
            size: context.dynamicWidth(0.2),
          ),
          context.emptySizedHeightBox8x,
          _titleSubtitle(context),
          context.emptySizedHeightBox4x,
          _emailField(context),
          context.emptySizedHeightBox2x,
          _passwordField(context),
          context.emptySizedHeightBox2x,
          _againPasswordField(context),
          context.emptySizedHeightBox2x,
          _signUpButton(context)
        ],
      ),
    );
  }

  Column _titleSubtitle(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.registerTitle,
          style: context.textTheme.headline5,
        ),
        context.emptySizedHeightBox1x,
        Text(
          AppLocalizations.of(context)!.registerSubtitle,
          style: context.textTheme.subtitle1,
        ),
      ],
    );
  }

  DefaultTextFormField _emailField(BuildContext context) {
    bool filled = true;
    return DefaultTextFormField(
      context: context,
      filled: filled,
      fillColor: colors.white,
      prefixIcon: icons.email,
      labelText: AppLocalizations.of(context)!.emailLabel,
      hintText: AppLocalizations.of(context)!.emailHint,
      keyboardType: context.keyboardEmailAddress,
    );
  }

  DefaultTextFormField _passwordField(BuildContext context) {
    bool filled = true;
    bool obscureText = true;
    return DefaultTextFormField(
      context: context,
      filled: filled,
      fillColor: colors.white,
      obscureText: obscureText,
      prefixIcon: icons.lock,
      labelText: AppLocalizations.of(context)!.passwordLabel,
      hintText: AppLocalizations.of(context)!.passwordHint,
      keyboardType: context.keyboardVisiblePassword,
    );
  }

  DefaultTextFormField _againPasswordField(BuildContext context) {
    bool filled = true;
    bool obscureText = true;
    return DefaultTextFormField(
      context: context,
      filled: filled,
      fillColor: colors.white,
      obscureText: obscureText,
      prefixIcon: icons.lock,
      labelText: AppLocalizations.of(context)!.passwordLabel,
      hintText: AppLocalizations.of(context)!.passwordHint2,
      keyboardType: context.keyboardVisiblePassword,
    );
  }

  SpecialButton _signUpButton(BuildContext context) {
    bool isHasIcon = true;
    return SpecialButton(
      padding: context.padding2x,
      buttonLabel: AppLocalizations.of(context)!.signUpButton,
      borderRadius: context.borderRadius4x,
      isHasIcon: isHasIcon,
      icon: Icons.done,
      onTap: () {},
    );
  }
}
