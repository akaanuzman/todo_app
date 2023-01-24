import 'package:animate_do/animate_do.dart';
import 'package:async_button/async_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../features/components/circle_avatar/circle_avatar_inside_icon.dart';
import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/button/special_async_button.dart';
import '../../../uikit/decoration/special_container_decoration.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';
import 'package:uuid/uuid.dart';

import '../../models/todo_model.dart';
import '../../viewmodels/todo_view_model.dart';

class AddOrEditTodoView extends StatelessWidget with BaseSingleton {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final bool isEdit;
  final TodoModel? todoModel;

  AddOrEditTodoView({
    super.key,
    this.isEdit = false,
    this.todoModel,
  });

  void get isEditPageLoadData {
    if (todoModel != null && isEdit) {
      _titleController.text = "${todoModel?.title}";
      _subtitleController.text = "${todoModel?.subtitle}";
    }
  }

  _operations(
    AsyncButtonStateController btnStateController,
    BuildContext context,
  ) async {
    btnStateController.update(ButtonState.loading);
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final pv = Provider.of<TodoViewModel>(context, listen: false);
      if (isEdit) {
        await _editTodo(btnStateController, pv);
      } else {
        await _addTodo(btnStateController, pv);
      }
    } else {
      btnStateController.update(ButtonState.failure);
    }
  }

  _editTodo(
    AsyncButtonStateController btnStateController,
    TodoViewModel pv,
  ) async {
    int statusCode = await pv.updateTodo(
      todoId: "${todoModel?.id}",
      obj: {
        "title": _titleController.text,
        "subtitle": _subtitleController.text
      },
    );
    statusCode == 200
        ? btnStateController.update(ButtonState.success)
        : btnStateController.update(ButtonState.failure);
  }

  _addTodo(
    AsyncButtonStateController btnStateController,
    TodoViewModel pv,
  ) async {
    var uuid = const Uuid();
    Map<String, dynamic> obj = {
      "id": uuid.v1(),
      "isActive": true,
      "isDone": false,
      "title": _titleController.text,
      "subtitle": _subtitleController.text,
      "createdAt": Timestamp.now(),
    };
    int statusCode = await pv.addTodo(obj: obj);
    statusCode == 200
        ? btnStateController.update(ButtonState.success)
        : btnStateController.update(ButtonState.failure);
  }

  @override
  Widget build(BuildContext context) {
    isEditPageLoadData;
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context),
      ),
      body: FadeInLeft(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: context.padding2x,
            children: [
              _descriptionsSection(context),
              context.emptySizedHeightBox3x,
              _fieldsAndAddTodoButtonContainer(context)
            ],
          ),
        ),
      ),
    );
  }

  FadeInRight _appBarTitle(BuildContext context) {
    return FadeInRight(
      child: Text(
        isEdit
            ? AppLocalizations.of(context)!.editTodoAppBar
            : AppLocalizations.of(context)!.addTodo,
      ),
    );
  }

  Container _descriptionsSection(BuildContext context) {
    return Container(
      padding: context.padding2x,
      decoration: SpecialContainerDecoration(context: context),
      child: Row(
        children: [
          _icon(context),
          context.emptySizedWidthBox3x,
          _todoDescriptions(context),
        ],
      ),
    );
  }

  Widget _icon(BuildContext context) {
    return CircleAvatarInsideIcon(
      icon: isEdit ? Icons.update : Icons.question_mark,
    );
  }

  Expanded _todoDescriptions(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: context.crossAxisAStart,
        children: [
          _todoDescription(context),
          context.emptySizedHeightBox1x,
          _todoDescriptionV2(context),
        ],
      ),
    );
  }

  Text _todoDescription(BuildContext context) {
    return Text(
      isEdit
          ? AppLocalizations.of(context)!.editTodoTitle
          : AppLocalizations.of(context)!.addTodoTitle,
      style: context.textTheme.subtitle1!.copyWith(
        fontWeight: context.fw700,
      ),
    );
  }

  Text _todoDescriptionV2(BuildContext context) {
    return Text(
      isEdit
          ? AppLocalizations.of(context)!.editTodoSubtitle
          : AppLocalizations.of(context)!.addTodoSubtitle,
      style: context.textTheme.subtitle2!.copyWith(
        color: colors.black.withOpacity(0.8),
      ),
      textAlign: context.taCenter,
    );
  }

  Container _fieldsAndAddTodoButtonContainer(BuildContext context) {
    return Container(
      padding: context.padding4x,
      decoration: SpecialContainerDecoration(context: context),
      child: Column(
        crossAxisAlignment: context.crossAxisAStart,
        children: [
          _todoTitleField(context),
          context.emptySizedHeightBox3x,
          _todoSubtitleField(context),
          context.emptySizedHeightBox3x,
          _addNewTodoButton(context)
        ],
      ),
    );
  }

  DefaultTextFormField _todoTitleField(BuildContext context) {
    bool filled = true;
    return DefaultTextFormField(
      filled: filled,
      fillColor: colors.grey1,
      context: context,
      labelText: AppLocalizations.of(context)!.todoTitleLabel,
      controller: _titleController,
      validator: (title) => validators.titleCheck(title),
    );
  }

  DefaultTextFormField _todoSubtitleField(BuildContext context) {
    bool filled = true;
    return DefaultTextFormField(
      filled: filled,
      fillColor: colors.grey1,
      context: context,
      labelText: AppLocalizations.of(context)!.todoSubtitleLabel,
      controller: _subtitleController,
      validator: (subtitle) => validators.subtitleCheck(subtitle),
    );
  }

  Widget _addNewTodoButton(BuildContext context) {
    bool isHasIcon = true;
    return SizedBox(
      width: context.maxFinite,
      child: SpecialAsyncButton(
        onTap: (btnStateController) async =>
            await _operations(btnStateController, context),
        buttonLabel: isEdit
            ? AppLocalizations.of(context)!.editTodoButton
            : AppLocalizations.of(context)!.addNewTodoButton,
        borderRadius: context.borderRadius3x,
        padding: context.padding2x,
        isHasIcon: isHasIcon,
        icon: isEdit ? Icons.edit : Icons.add,
      ),
    );
  }
}
