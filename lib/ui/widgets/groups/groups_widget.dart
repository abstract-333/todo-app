import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/app/constants.dart';
import 'package:flutter_application_first/ui/widgets/group_alert_dialog/group_alert_dialog.dart';
import 'package:flutter_application_first/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupWidgetBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.watch(context)!.model;
    final bodyOfScaffold = model.groups.isEmpty
        ? const _EmptyPageTextWidget()
        : const _GroupsPageListWidget();
    final selectionEnabled = model.groupsSelectionEnabled;
    return Scaffold(
      backgroundColor: WidgetConstants.colorSecond.shade200,
      bottomNavigationBar:
          selectionEnabled ? _NavigationBarWidget(model: model) : null,
      body: bodyOfScaffold,
      appBar: AppBar(
          backgroundColor: WidgetConstants.colorSecond.shade200,
          actions: model.countOfSelectedGroups == 1
              ? [_RenameButtonWidget(model: model)]
              : null,
          title: selectionEnabled
              ? Text(
                  '${model.countOfSelectedGroups} Selected',
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.group_sharp, size: 30),
                    SizedBox(width: 5),
                    Text('Groups'),
                  ],
                )),
      floatingActionButton:
          !selectionEnabled ? _FloatingActionButtonAdd(model: model) : null,
    );
  }
}

class _EmptyPageTextWidget extends StatelessWidget {
  const _EmptyPageTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          'Press + to add a new group.',
          style: WidgetConstants.mainTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: WidgetConstants.colorSecond.shade600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _RenameButtonWidget extends StatelessWidget {
  const _RenameButtonWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => GroupsDialogWidget(
                  modelOfGroups: model,
                )),
        child: Text(
          'Rename',
          style: WidgetConstants.appBarTextStyle.copyWith(fontSize: 20),
        ));
  }
}

class _FloatingActionButtonAdd extends StatelessWidget {
  const _FloatingActionButtonAdd({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => GroupsDialogWidget(
                  modelOfGroups: model,
                )),
        child: const Icon(Icons.add));
  }
}

class _NavigationBarWidget extends StatelessWidget {
  const _NavigationBarWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ColoredBox(
        color: WidgetConstants.colorSecond.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CancelButtonWidget(model: model),
              const VerticalDivider(
                indent: 2,
                endIndent: 2,
                color: Colors.black,
                thickness: 1,
                width: 2,
              ),
              _DeleteButtonWidget(model: model)
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteButtonWidget extends StatelessWidget {
  const _DeleteButtonWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => model.deleteAllSelected(),
      icon: const Text(
        'Delete',
        style: WidgetConstants.textStyleNavigationBar,
      ),
      label: WidgetConstants.deleteIcon,
    );
  }
}

class _CancelButtonWidget extends StatelessWidget {
  const _CancelButtonWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => model.disableGroupsSelection(),
      child: const Padding(
        padding: EdgeInsets.all(3),
        child: Text(
          'Cancel',
          style: WidgetConstants.textStyleNavigationBar,
        ),
      ),
    );
  }
}

class _GroupsPageListWidget extends StatelessWidget {
  const _GroupsPageListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.builder(
      itemBuilder: ((BuildContext context, index) => _GroupListRowWidget(
            indexInList: index,
          )),
      itemCount: groupsCount,
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final colorOfBox = model.checkGroupSelected(indexInList)
        ? WidgetConstants.colorMain[50]
        : WidgetConstants.colorSecond[200];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorOfBox,
            borderRadius: WidgetConstants.radiusOfShapes,
            boxShadow: [
              BoxShadow(
                  color: WidgetConstants.colorSecond.shade400,
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                  spreadRadius: 1),
              const BoxShadow(
                  color: Colors.white,
                  blurRadius: 5,
                  offset: Offset(-4, -4),
                  spreadRadius: 1),
            ],
          ),
          child: _GroupsListRowOpenDeleteWIdget(
              indexInList: indexInList, model: model),
        ),
      ),
    );
  }
}

class _GroupsListRowOpenDeleteWIdget extends StatelessWidget {
  const _GroupsListRowOpenDeleteWIdget(
      {Key? key, required this.indexInList, required this.model})
      : super(key: key);

  final int indexInList;
  final GroupsWidgetModel model;

  @override
  Widget build(BuildContext context) {
    final icon = model.checkGroupSelected(indexInList)
        ? const Icon(
            Icons.check,
            color: WidgetConstants.colorMain,
          )
        : const SizedBox();
    final group = model.groups[indexInList];
    return ListTile(
        contentPadding: const EdgeInsets.all(8),
        onTap: () => model.groupsSelectionEnabled
            ? model.selectGroup(indexInList)
            : model.showTasks(context, indexInList),
        onLongPress: () {
          !model.groupsSelectionEnabled
              ? model.enableGroupsSelection(indexInList)
              : null;
        },
        title: Row(
          children: [
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                group.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            icon,
          ],
        ));
  }
}
