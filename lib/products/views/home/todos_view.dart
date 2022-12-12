// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/products/views/home/add_or_edit_todo_view.dart';
import '../../../core/base/base_singleton.dart';
import '../../../core/enums/alert_enum.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/decoration/special_container_decoration.dart';
import '../../../uikit/skeleton/skeleton_list.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';
import '../../models/todo_model.dart';
import '../../viewmodels/todo_view_model.dart';

class TodosView extends StatelessWidget with BaseSingleton {
  final _todoController = TextEditingController();
  TodosView({super.key});

  _goToEditTodoPage(BuildContext context, TodoModel todo) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddOrEditTodoView(
            isEdit: true,
            todoModel: todo,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pv = Provider.of<TodoViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context),
      ),
      body: FutureBuilder(
        future: pv.getTodos,
        builder: (_,snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SkeletonList();
            default:
              return Consumer<TodoViewModel>(
                builder: (context, pv, _) {
                  bool shrinkWrap = true;
                  return FadeInLeft(
                    child: pv.todoList.isEmpty
                        ? Container(
                            decoration:
                                SpecialContainerDecoration(context: context),
                            padding: context.padding4x,
                            margin: context.padding2x,
                            child: Row(
                              children: [
                                // TODO: MAKE COMPONENT
                                SizedBox(
                                  width: context.dynamicWidth(0.2),
                                  height: context.dynamicWidth(0.2),
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.mood,
                                      size: context.dynamicWidth(0.15),
                                    ),
                                  ),
                                ),
                                context.emptySizedWidthBox3x,
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.haveNotTodo,
                                    textAlign: context.taCenter,
                                    style: context.textTheme.subtitle1!
                                        .copyWith(fontWeight: context.fw700),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            padding: context.padding2x,
                            shrinkWrap: shrinkWrap,
                            children: [
                              _searchField(context, pv),
                              context.emptySizedHeightBox3x,
                              _todos(context, pv)
                            ],
                          ),
                  );
                },
              );
          }
        },
      ),
    );
  }

  FadeInRight _appBarTitle(BuildContext context) {
    return FadeInRight(
      child: Text(AppLocalizations.of(context)!.todosAppBar),
    );
  }

  DefaultTextFormField _searchField(BuildContext context, TodoViewModel pv) {
    bool filled = true;
    return DefaultTextFormField(
      context: context,
      filled: filled,
      fillColor: colors.white,
      labelText: AppLocalizations.of(context)!.searchTodo,
      prefixIcon: icons.search,
      controller: _todoController,
      onChanged: pv.searchTodo,
    );
  }

  Widget _todos(BuildContext context, TodoViewModel pv) {
    bool shrinkWrap = true;
    int todoLength = pv.todoList.length;
    if (_todoController.text.isNotEmpty) {
      todoLength = pv.searchList.length;
    }
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      // TODO: ADD CORE STRUCTURE
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        TodoModel todo = pv.todoList[index];
        if (_todoController.text.isNotEmpty) {
          todo = pv.searchList[index];
        }
        return _todo(context, todo, pv);
      },
      separatorBuilder: (_, __) => context.emptySizedHeightBox3x,
      itemCount: todoLength,
    );
  }

  Widget _todo(BuildContext context, TodoModel todo, TodoViewModel pv) {
    String title = "${todo.title}";
    String subtitle = "${todo.subtitle}";
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _goToEditTodoPage(context, todo),
            backgroundColor: colors.blueAccent,
            foregroundColor: colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (context) {
              uiGlobals.showAlertDialog(
                  context: context,
                  alertEnum: AlertEnum.AREUSURE,
                  contentTitle: AppLocalizations.of(context)!.areYouSure,
                  contentSubtitle:
                      AppLocalizations.of(context)!.deleteTodoContent,
                  buttonLabel: AppLocalizations.of(context)!.noButton,
                  secondButtonLabel: AppLocalizations.of(context)!.yesButton,
                  secondActionOnTap: () async {
                    await pv.deleteTodo(todoId: "${todo.id}");
                  });
            },
            backgroundColor: colors.redAccent,
            foregroundColor: colors.white,
            icon: Icons.delete,
          ),
          SlidableAction(
            onPressed: (context) {
              uiGlobals.showAlertDialog(
                context: context,
                alertEnum: AlertEnum.AREUSURE,
                contentTitle: AppLocalizations.of(context)!.areYouSure,
                contentSubtitle: AppLocalizations.of(context)!.doneTodoContent,
                buttonLabel: AppLocalizations.of(context)!.noButton,
                secondButtonLabel: AppLocalizations.of(context)!.yesButton,
                secondActionOnTap: () async {
                  await pv.updateTodo(
                    todoId: "${todo.id}",
                    obj: {"isDone": true},
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
            backgroundColor: colors.greenAccent4,
            foregroundColor: colors.white,
            icon: Icons.done,
          ),
        ],
      ),
      child: Container(
        padding: context.padding2x,
        decoration: SpecialContainerDecoration(context: context),
        child: ListTile(
          leading: _todoLeading(context),
          title: _todoTitle(context, title),
          subtitle: _todoSubtitle(context, subtitle),
          trailing: icons.right,
        ),
      ),
    );
  }

  SizedBox _todoLeading(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 62,
      child: CircleAvatar(
        backgroundColor: context.randomColor,
        child: Icon(
          Icons.rocket_launch,
          color: colors.white,
          size: 32,
        ),
      ),
    );
  }

  Text _todoTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.subtitle1!.copyWith(fontWeight: context.fw700),
    );
  }

  Text _todoSubtitle(BuildContext context, String subtitle) {
    return Text(
      subtitle,
      style: context.textTheme.subtitle2!.copyWith(
        color: colors.black.withOpacity(0.7),
      ),
    );
  }
}
