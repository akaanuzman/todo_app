import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../features/components/container/have_not_todo_container.dart';
import '../../models/todo_model.dart';
import '../../../uikit/skeleton/skeleton_list.dart';
import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/decoration/special_container_decoration.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';
import '../../viewmodels/todo_view_model.dart';

class DoneTodosView extends StatelessWidget with BaseSingleton {
  final _todoController = TextEditingController();
  DoneTodosView({super.key});

  @override
  Widget build(BuildContext context) {
    final pv = Provider.of<TodoViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context),
      ),
      body: FadeInLeft(
        child: FutureBuilder(
          future: pv.getTodos,
          builder: (_, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SkeletonList();
              default:
                return Consumer<TodoViewModel>(
                  builder: (context, pv, _) {
                    return pv.doneTodoList.isEmpty
                        ? HaveNotTodoContainer(
                            title:
                                AppLocalizations.of(context)!.haveNotDoneTodo)
                        : ListView(
                            padding: context.padding2x,
                            shrinkWrap: true,
                            children: [
                              _searchField(context, pv),
                              context.emptySizedHeightBox3x,
                              _todos(context, pv)
                            ],
                          );
                  },
                );
            }
          },
        ),
      ),
    );
  }

  FadeInRight _appBarTitle(BuildContext context) {
    return FadeInRight(
      child: Text(AppLocalizations.of(context)!.doneTodosAppBar),
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
      onChanged: pv.searchDoneTodo,
    );
  }

  ListView _todos(BuildContext context, TodoViewModel pv) {
    bool shrinkWrap = true;
    int doneTodoLength = pv.doneTodoList.length;
    if (_todoController.text.isNotEmpty) {
      doneTodoLength = pv.doneTodoSearchList.length;
    }
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: context.neverScroll,
      itemBuilder: (context, index) {
        TodoModel todo = pv.doneTodoList[index];
        if (_todoController.text.isNotEmpty) {
          todo = pv.doneTodoSearchList[index];
        }
        return _todo(context, todo);
      },
      separatorBuilder: (_, __) => context.emptySizedHeightBox3x,
      itemCount: doneTodoLength,
    );
  }

  Container _todo(BuildContext context, TodoModel todo) {
    String title = "${todo.title}";
    String subtitle = "${todo.subtitle}";
    return Container(
      padding: context.padding2x,
      decoration: SpecialContainerDecoration(context: context),
      child: ListTile(
        leading: _todoLeading(context),
        title: _todoTitle(context, title),
        subtitle: _todoSubtitle(context, subtitle),
        trailing: icons.right,
      ),
    );
  }

  SizedBox _todoLeading(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 62,
      child: CircleAvatar(
        backgroundColor: colors.greenAccent7,
        child: Icon(
          Icons.done,
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
