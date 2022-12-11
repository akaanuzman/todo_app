import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/extensions/ui_extensions.dart';

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
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Icon(
            Icons.article,
            size: context.dynamicWidth(0.2),
          ),
          context.emptySizedHeightBox1x,
          Center(
            child: Text(
              constants.appTitle,
              style: context.textTheme.headline5,
            ),
          )
        ],
      ),
    );
  }
}
