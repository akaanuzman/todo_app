import 'package:flutter/material.dart';
import '../views/home/done_todos_view.dart';
import '../views/home/profile_view.dart';
import '../views/home/todos_view.dart';
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
    NavbarModel(
      icon: Icons.person,
      label: "Profile",
    ),
  ];

  List<NavbarModel> get items => _items;

  final List<Widget> _views = [
    TodosView(),
    DoneTodosView(),
    const ProfileView()
  ];

  List<Widget> get views => _views;

  void onItemTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
