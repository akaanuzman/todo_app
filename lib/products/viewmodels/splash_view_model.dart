import 'package:flutter/material.dart';

import '../../core/helpers/token.dart';

class SplashViewModel extends ChangeNotifier {
  bool _status = false;
  bool get status => _status;

  Future<bool> get getToken async {
    final result = await Token.readToken("user");
    if (result != null) {
      _status = true;
      notifyListeners();
      return _status;
    } else {
      return _status;
    }
  }
}
