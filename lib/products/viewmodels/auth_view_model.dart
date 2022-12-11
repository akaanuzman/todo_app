// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/enums/alert_enum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/core/utils/navigation_service.dart';

import '../views/common/navbar_view.dart';

class AuthViewModel with BaseSingleton {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final BuildContext context = NavigationService.navigatorKey.currentContext!;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      uiGlobals.showAlertDialog(
        context: context,
        alertEnum: AlertEnum.SUCCESS,
        contentTitle: AppLocalizations.of(context)!.loginSuccess,
        contentSubtitle: AppLocalizations.of(context)!.loginSuccessContent,
        buttonLabel: AppLocalizations.of(context)!.okButton,
        onTap: () {
          return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavbarView(),
            ),
            (route) => false,
          );
        },
      );
      return response.user;
    } catch (err) {
      String errStr = err.toString();
      int startIndex = errStr.indexOf("]") + 1;
      String errMessage = errStr.substring(startIndex, errStr.length - 1);
      uiGlobals.showAlertDialog(
        context: context,
        alertEnum: AlertEnum.ERROR,
        contentTitle: AppLocalizations.of(context)!.loginFailed,
        contentSubtitle: errMessage.toString(),
        buttonLabel: AppLocalizations.of(context)!.okButton,
      );
    }
    return null;
  }

  Future<Object?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String errMessage = "";
    try {
      var response = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((err) {
        String errStr = err.toString();
        int startIndex = errStr.indexOf("]") + 1;
        errMessage = errStr.substring(startIndex, errStr.length - 1);
        throw err;
      });

      if (response.user != null) {
        try {
          await _fireStore.collection("User").doc(response.user!.uid).set(
            {
              "email": email,
            },
          );
        } catch (err) {
          uiGlobals.showAlertDialog(
            context: context,
            alertEnum: AlertEnum.ERROR,
            contentTitle: AppLocalizations.of(context)!.registerFailed,
            contentSubtitle: err.toString(),
            buttonLabel: AppLocalizations.of(context)!.okButton,
          );
        }
      }
    } catch (e) {
      uiGlobals.showAlertDialog(
        context: context,
        alertEnum: AlertEnum.ERROR,
        contentTitle: AppLocalizations.of(context)!.registerFailed,
        contentSubtitle: errMessage,
        buttonLabel: AppLocalizations.of(context)!.okButton,
      );
      return e;
    }
    return null;
  }

  Future<void> get logout async {
    await _firebaseAuth.signOut();
  }
}
