import 'package:flutter/material.dart';
import '../../core/base/base_singleton.dart';
import '../models/navbar_model.dart';

class NavbarViewModel extends ChangeNotifier with BaseSingleton {
  int currentIndex = 0;

  final List<NavbarModel> _items = [
    NavbarModel(
      icon: Icons.article,
      label: "Todos",
    ),
    NavbarModel(
      icon: Icons.task,
      label: "Done Todos",
    ),
  ];

  List<NavbarModel> get items => _items;

  final List<Widget> _views = [
    const Scaffold(),
    const Scaffold(),
  ];

  List<Widget> get views => _views;

  void onItemTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
