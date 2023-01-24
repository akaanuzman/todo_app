import 'package:animate_do/animate_do.dart';
import 'package:async_button/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../../uikit/button/special_async_button.dart';
import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../core/helpers/token.dart';
import '../../../features/components/button/auth_button.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget with BaseSingleton {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginView({super.key});

  _login(AsyncButtonStateController btnStateController,
      BuildContext context) async {
    btnStateController.update(ButtonState.loading);
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      AuthViewModel viewModel = AuthViewModel();
      var user = await viewModel.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (user != null) {
        btnStateController.update(ButtonState.success);
        Token.saveToken(token: user.uid, key: "user");
      } else {
        btnStateController.update(ButtonState.failure);
      }
    } else {
      btnStateController.update(ButtonState.failure);
    }
  }

  _goToRegisterPage(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: FadeInRight(
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
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
      controller: _emailController,
      validator: (email) => validators.emailCheck(email),
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
      controller: _passwordController,
      validator: (password) => validators.passwordCheck(password),
    );
  }

  SpecialAsyncButton _signInButton(BuildContext context) {
    bool isHasIcon = true;
    return SpecialAsyncButton(
      onTap: (btnStateController) async =>
          await _login(btnStateController, context),
      buttonLabel: AppLocalizations.of(context)!.loginButton,
      borderRadius: context.borderRadius4x,
      padding: context.padding2x,
      isHasIcon: isHasIcon,
      icon: Icons.login,
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
