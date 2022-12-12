// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/utils/navigation_service.dart';
import 'package:todo_app/products/models/todo_model.dart';

import '../../core/helpers/token.dart';

class TodoViewModel extends ChangeNotifier with BaseSingleton {
  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;
  List<TodoModel> _doneTodoList = [];
  List<TodoModel> get doneTodoList => _doneTodoList;
  List<TodoModel> _searchList = [];
  List<TodoModel> get searchList => _searchList;
    List<TodoModel> _doneTodoSearchList = [];
  List<TodoModel> get doneTodoSearchList => _doneTodoSearchList;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final BuildContext context = NavigationService.navigatorKey.currentContext!;

  Future<void> get getTodos async {
    String? userId = await Token.readToken("user");

    if (userId != null) {
      try {
        CollectionReference userRef = _fireStore.collection("User");
        var todos = userRef.doc(userId).collection("todos");
        var response = await todos.get();
        _todoList = response.docs
            .map(
              (e) => TodoModel.fromJson(e.data()),
            )
            .toList();
        _doneTodoList = _todoList.where((element) {
          return element.isDone!;
        }).toList();
        _todoList = _todoList.where((element) {
          return !element.isDone!;
        }).toList();
        _doneTodoList.sort((a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            return b.createdAt!.compareTo(a.createdAt!);
          } else {
            return b.createdAt!.compareTo(a.createdAt ?? Timestamp.now());
          }
        });
        _todoList.sort((a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            return b.createdAt!.compareTo(a.createdAt!);
          } else {
            return b.createdAt!.compareTo(a.createdAt ?? Timestamp.now());
          }
        });
      } catch (error) {
        print(error);
        _todoList = [];
      }
      notifyListeners();
    }
  }

  Future<int> addTodo({required Map<String, dynamic> obj}) async {
    String? userId = await Token.readToken("user");
    if (userId != null) {
      try {
        CollectionReference userRef = _fireStore.collection("User");
        var todos = userRef.doc(userId).collection("todos").doc(obj["id"]);
        await todos.set(obj);
        await getTodos;
        uiGlobals.showSnackBar(
          content: AppLocalizations.of(context)!.addTodoSuccess,
          context: context,
        );
        Navigator.pop(context);
        return 200;
      } catch (e) {
        uiGlobals.showSnackBar(
          content: e.toString(),
          context: context,
        );
        return 400;
      }
    }
    return 500;
  }

  Future<int> updateTodo({
    required String todoId,
    required Map<String, dynamic> obj,
  }) async {
    String? userId = await Token.readToken("user");
    if (userId != null) {
      try {
        CollectionReference userRef = _fireStore.collection("User");
        var todo = userRef.doc(userId).collection("todos").doc(todoId);
        await todo.update(obj);
        await getTodos;
        uiGlobals.showSnackBar(
          content: AppLocalizations.of(context)!.updateTodoSuccess,
          context: context,
        );
        Navigator.pop(context);
        return 200;
      } catch (e) {
        uiGlobals.showSnackBar(
          content: e.toString(),
          context: context,
        );
        return 400;
      }
    }
    return 500;
  }

  Future<void> deleteTodo({required String todoId}) async {
    String? userId = await Token.readToken("user");
    if (userId != null) {
      try {
        CollectionReference userRef = _fireStore.collection("User");
        var todo = userRef.doc(userId).collection("todos").doc(todoId);
        await todo.delete();
        await getTodos;
        Navigator.pop(context);
        uiGlobals.showSnackBar(
          content: AppLocalizations.of(context)!.deleteTodoSuccess,
          context: context,
        );
      } catch (e) {
        uiGlobals.showSnackBar(
          content: e.toString(),
          context: context,
        );
      }
    }
  }

  void searchTodo(String query) {
    if (query.isNotEmpty) {
      final suggestions = todoList.where((todo) {
        final todoTitle = todo.title?.toLowerCase();
        final todoSubtitle = todo.subtitle?.toLowerCase();
        final input = query.toLowerCase();
        if (todoTitle != null && todoSubtitle != null) {
          return todoTitle.contains(input) || todoSubtitle.contains(input);
        }
        return false;
      }).toList();
      _searchList = suggestions;
    }
    notifyListeners();
  }

    void searchDoneTodo(String query) {
   
    if (query.isNotEmpty) {
      final suggestions = doneTodoList.where((todo) {
        final todoTitle = todo.title?.toLowerCase();
        final todoSubtitle = todo.subtitle?.toLowerCase();
        final input = query.toLowerCase();
        if (todoTitle != null && todoSubtitle != null) {
          return todoTitle.contains(input) || todoSubtitle.contains(input);
        }
        return false;
      }).toList();
      _doneTodoSearchList = suggestions;
         for (var  element in _doneTodoSearchList) {
        print(element.title);
      }
    }
    notifyListeners();
  }
}
