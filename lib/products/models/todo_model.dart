import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  bool? isActive;
  bool? isDone;
  String? subtitle;
  String? title;
  Timestamp? createdAt;

  TodoModel(
      {this.id,
      this.isActive,
      this.isDone,
      this.subtitle,
      this.title,
      this.createdAt});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    isDone = json['isDone'];
    subtitle = json['subtitle'];
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isActive'] = isActive;
    data['isDone'] = isDone;
    data['subtitle'] = subtitle;
    data['title'] = title;
    data['createdAt'] = createdAt;
    return data;
  }
}
