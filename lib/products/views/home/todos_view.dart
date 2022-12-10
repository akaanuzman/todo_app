import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/base/base_singleton.dart';
import '../../../core/extensions/ui_extensions.dart';
import '../../../uikit/decoration/special_container_decoration.dart';
import '../../../uikit/textformfield/default_text_form_field.dart';

class TodosView extends StatelessWidget with BaseSingleton {
  const TodosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context),
      ),
      body: FadeInLeft(
        child: ListView(
          padding: context.padding2x,
          shrinkWrap: true,
          children: [
            _searchField(context),
            context.emptySizedHeightBox3x,
            _todos(context)
          ],
        ),
      ),
    );
  }

  FadeInRight _appBarTitle(BuildContext context) {
    return FadeInRight(
      child: Text(AppLocalizations.of(context)!.todosAppBar),
    );
  }

  DefaultTextFormField _searchField(BuildContext context) {
    bool filled = true;
    return DefaultTextFormField(
      context: context,
      filled: filled,
      fillColor: colors.white,
      labelText: AppLocalizations.of(context)!.searchTodo,
      prefixIcon: icons.search,
    );
  }

  ListView _todos(BuildContext context) {
    bool shrinkWrap = true;
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      // TODO: ADD CORE STRUCTURE
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _todo(context);
      },
      separatorBuilder: (_, __) => context.emptySizedHeightBox3x,
      itemCount: 50,
    );
  }

  Container _todo(BuildContext context) {
    return Container(
      padding: context.padding2x,
      decoration: SpecialContainerDecoration(context: context),
      child: ListTile(
        leading: _todoLeading(context),
        title: _todoTitle(context),
        subtitle: _todoSubtitle(context),
        trailing: icons.right,
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

  Text _todoTitle(BuildContext context) {
    return Text(
      "Todo Name",
      style: context.textTheme.subtitle1!.copyWith(fontWeight: context.fw700),
    );
  }

  Text _todoSubtitle(BuildContext context) {
    return Text(
      "Todo subtitle",
      style: context.textTheme.subtitle2!.copyWith(
        color: colors.black.withOpacity(0.7),
      ),
    );
  }
}
