import 'package:animate_do/animate_do.dart';
import 'package:async_button/async_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/base/base_singleton.dart';
import 'package:todo_app/core/extensions/ui_extensions.dart';
import 'package:todo_app/uikit/button/special_async_button.dart';
import 'package:todo_app/uikit/button/special_button.dart';
import 'package:todo_app/uikit/decoration/special_container_decoration.dart';
import 'package:todo_app/uikit/textformfield/default_text_form_field.dart';
import 'package:uuid/uuid.dart';

import '../../viewmodels/todo_view_model.dart';

class AddTodoView extends StatelessWidget with BaseSingleton {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Text(AppLocalizations.of(context)!.addTodo),
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

  SizedBox _icon(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.2),
      height: context.dynamicWidth(0.2),
      child: CircleAvatar(
        child: Icon(
          Icons.question_mark,
          size: context.dynamicWidth(0.15),
        ),
      ),
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
      AppLocalizations.of(context)!.addTodoTitle,
      style: context.textTheme.subtitle1!.copyWith(
        fontWeight: context.fw700,
      ),
    );
  }

  Text _todoDescriptionV2(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.addTodoSubtitle,
      style: context.textTheme.subtitle2!.copyWith(
        color: colors.black.withOpacity(0.8),
      ),
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
        onTap: (btnStateController) async {
          btnStateController.update(ButtonState.loading);
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            final pv = Provider.of<TodoViewModel>(context, listen: false);
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
          } else {
            btnStateController.update(ButtonState.failure);
          }
        },
        buttonLabel: AppLocalizations.of(context)!.addNewTodoButton,
        borderRadius: context.borderRadius3x,
        padding: context.padding2x,
        isHasIcon: isHasIcon,
        icon: Icons.add,
      ),
    );
  }

  // SizedBox _addNewTodoButton(BuildContext context) {
  //   bool isHasIcon = true;
  //   return SizedBox(
  //     width: context.maxFinite,
  //     child: SpecialButton(
  //       buttonLabel: AppLocalizations.of(context)!.addNewTodoButton,
  //       borderRadius: context.borderRadius3x,
  //       padding: context.padding2x,
  //       isHasIcon: isHasIcon,
  //       icon: Icons.add,
  //       onTap: () async {
  //         _formKey.currentState!.save();
  //         if (_formKey.currentState!.validate()) {
  //           final pv = Provider.of<TodoViewModel>(context, listen: false);
  //           var uuid = const Uuid();
  //           Map<String, dynamic> obj = {
  //             "id": uuid.v1(),
  //             "isActive": true,
  //             "isDone": false,
  //             "title": _titleController.text,
  //             "subtitle": _subtitleController.text,
  //             "createdAt": Timestamp.now(),
  //           };
  //           await pv.addTodo(obj: obj);
  //         } else {

  //         }
  //       },
  //     ),
  //   );
  // }
}
