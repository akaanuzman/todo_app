// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/products/models/todo_model.dart';

import '../../core/helpers/token.dart';

class TodoViewModel extends ChangeNotifier {
  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;
  List<TodoModel> _searchList = [];
  List<TodoModel> get searchList => _searchList;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> get getTodos async {
    String? userId = await Token.readToken("user");

    if (userId != null) {
      CollectionReference userRef = _fireStore.collection("User");
      var todos = userRef.doc(userId).collection("todos");
      try {
        var response = await todos.get();
        _todoList = response.docs
            .map(
              (e) => TodoModel.fromJson(e.data()),
            )
            .toList();
      } catch (error) {
        print(error);
        _todoList = [];
      }
      notifyListeners();
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
}
