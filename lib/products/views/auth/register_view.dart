// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:async_button/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/products/viewmodels/auth_view_model.dart';
import 'package:todo_app/products/views/auth/login_view.dart';
import 'package:todo_app/uikit/button/special_async_button.dart';

import '../../../core/base/base_singleton.dart';
import '../../../core/enums/alert_enum.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';

class RegisterView extends StatelessWidget with BaseSingleton {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordV2Controller = TextEditingController();
  RegisterView({super.key});

  Future<void> _registerOpretions(AsyncButtonStateController btnStateController,
      BuildContext context) async {
    btnStateController.update(ButtonState.loading);
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      AuthViewModel viewModel = AuthViewModel();
      final response = await viewModel.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );
      if (response == null) {
        btnStateController.update(ButtonState.success);
        uiGlobals.showAlertDialog(
          context: context,
          alertEnum: AlertEnum.SUCCESS,
          contentTitle: AppLocalizations.of(context)!.registeredSuccess,
          contentSubtitle:
              AppLocalizations.of(context)!.registeredSuccessContent,
          buttonLabel: AppLocalizations.of(context)!.okButton,
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ),
              (route) => false,
            );
          },
        );
      } else {
        btnStateController.update(ButtonState.failure);
      }
    } else {
      btnStateController.update(ButtonState.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context),
      ),
      body: FadeInRight(
        child: _body(context),
      ),
    );
  }

  FadeInLeft _appBarTitle(BuildContext context) {
    return FadeInLeft(
      child: Text(AppLocalizations.of(context)!.registerAppBar),
    );
  }

  Widget _body(BuildContext context) {
    bool shrinkWrap = true;
    return Form(
      key: _formKey,
      child: Center(
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
      hintText: AppLocalizations.of(context)!.passwordHint,
      keyboardType: context.keyboardVisiblePassword,
      controller: _passwordController,
      validator: (password) => validators.passwordCheck(password),
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
      controller: _passwordV2Controller,
      validator: (password) =>
          validators.twoPasswordCheck(password, _passwordController.text),
    );
  }

  SpecialAsyncButton _signUpButton(BuildContext context) {
    return SpecialAsyncButton(
      padding: context.padding2x,
      buttonLabel: AppLocalizations.of(context)!.signUpButton,
      borderRadius: context.borderRadius4x,
      onTap: (btnStateController) async =>
          await _registerOpretions(btnStateController, context),
      isHasIcon: true,
      icon: Icons.person_add,
    );
  }
}
