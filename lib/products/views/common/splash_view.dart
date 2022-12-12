import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../viewmodels/splash_view_model.dart';
import '../auth/login_view.dart';
import 'navbar_view.dart';

class SplashView extends StatelessWidget with BaseSingleton {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final pv = Provider.of<SplashViewModel>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: pv.getToken,
        builder: (_, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.waiting:
              return _body(context);
            default:
              if (snapShot.hasData && snapShot.data != null) {
                return !snapShot.data! ? LoginView() : const NavbarView();
              }
              return _body(context);
          }
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    bool shrinkWrap = true;
    return Center(
      child: ListView(
        shrinkWrap: shrinkWrap,
        children: [
          _icon(context),
          context.emptySizedHeightBox1x,
          _title(context)
        ],
      ),
    );
  }

  FadeInLeft _icon(BuildContext context) {
    return FadeInLeft(
      child: Icon(
        Icons.article,
        size: context.dynamicWidth(0.2),
      ),
    );
  }

  FadeInRight _title(BuildContext context) {
    return FadeInRight(
      child: Center(
        child: Text(
          constants.appTitle,
          style: context.textTheme.headline5,
        ),
      ),
    );
  }
}
