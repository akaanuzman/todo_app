import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/extensions/ui_extensions.dart';
import 'package:todo_app/features/components/button/auth_button.dart';
import 'package:todo_app/uikit/button/special_button.dart';
import 'package:todo_app/uikit/textformfield/default_text_form_field.dart';

import '../common/navbar_view.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget with BaseSingleton {
  const LoginView({super.key});

  _login(BuildContext context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarView(),
        ),
        (route) => false,
      );

  _goToRegisterPage(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icons.waving_hand,
            size: context.dynamicWidth(0.2),
          ),
          context.emptySizedHeightBox8x,
          _titleSubtitle(context),
          context.emptySizedHeightBox4x,
          _emailField(context),
          context.emptySizedHeightBox2x,
          _passwordField(context),
          context.emptySizedHeightBox2x,
          _signInButton(context),
          context.emptySizedHeightBox4x,
          _authButtons(context),
          context.emptySizedHeightBox3x,
          _registerSection(context)
        ],
      ),
    );
  }

  Column _titleSubtitle(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.loginTitle,
          style: context.textTheme.headline5,
        ),
        context.emptySizedHeightBox1x,
        Text(
          AppLocalizations.of(context)!.loginSubtitle,
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
      keyboardType: context.keyboardVisiblePassword,
    );
  }

  SpecialButton _signInButton(BuildContext context) {
    bool isHasIcon = true;
    return SpecialButton(
      padding: context.padding2x,
      buttonLabel: AppLocalizations.of(context)!.loginButton,
      borderRadius: context.borderRadius4x,
      isHasIcon: isHasIcon,
      icon: Icons.login,
      onTap: () => _login(context),
    );
  }

  Row _authButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: context.mainAxisASpaceAround,
      children: [
        AuthButton(
          icon: Icons.apple,
          iconColor: colors.black,
          onTap: () {},
        ),
        AuthButton(
          icon: Icons.g_mobiledata,
          iconColor: colors.black,
          onTap: () {},
        ),
        AuthButton(
          icon: Icons.facebook,
          iconColor: colors.facebookColor,
          onTap: () {},
        ),
      ],
    );
  }

  Row _registerSection(BuildContext context) {
    return Row(
      mainAxisAlignment: context.mainAxisACenter,
      children: [
        Text(
          AppLocalizations.of(context)!.registerText,
          style: context.textTheme.subtitle1,
        ),
        TextButton(
          onPressed: () => _goToRegisterPage(context),
          child: Text(AppLocalizations.of(context)!.registerButton),
        )
      ],
    );
  }
}
