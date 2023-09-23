import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/app/constants.dart';
import 'package:flutter_application_first/ui/widgets/group_alert_dialog/group_alert_dialog_model.dart';
import 'package:flutter_application_first/ui/widgets/groups/groups_widget_model.dart';

class GroupsDialogWidget extends StatefulWidget {
  const GroupsDialogWidget({Key? key, required this.modelOfGroups})
      : super(key: key);
  final GroupsWidgetModel modelOfGroups;
  @override
  State<GroupsDialogWidget> createState() => _GroupsDialogWidgetState();
}

class _GroupsDialogWidgetState extends State<GroupsDialogWidget> {
  final _modelOfAlertDialog = GroupAlertDialogModel();
  @override
  Widget build(BuildContext context) {
    return GroupAlertDialogModelProvider(
        groupAlertDialogModel: _modelOfAlertDialog,
        groupsWidgetModel: widget.modelOfGroups,
        child: const AddGroupDialogWidget());
  }
}

class AddGroupDialogWidget extends StatelessWidget {
  const AddGroupDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      shape: WidgetConstants.shapeOfWidgets,
      title: Center(child: Text('Enter group name:')),
      titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
      children: [_GroupFormWidgetBody()],
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modelOfGroups =
        GroupAlertDialogModelProvider.watch(context)?.groupsWidgetModel;
    final modelOfAlert =
        GroupAlertDialogModelProvider.watch(context)?.groupAlertDialogModel;
    final int? selectedGroup = modelOfGroups?.selectedGroup();

    return Column(children: [
      const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: _GroupNameWidget(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: WidgetConstants.colorMain),
                onPressed: Navigator.of(context, rootNavigator: true).pop,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Cancel',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                )),
            ElevatedButton(
                onPressed: () {
                  GroupAlertDialogModelProvider.watch(context)
                      ?.groupAlertDialogModel
                      .saveRenameGroup(context, groupIndex: selectedGroup);

                  modelOfGroups?.disableGroupsSelection();
                  modelOfAlert?.exitDialogWindow(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.done),
                )),
          ],
        ),
      ),
    ]);
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final modelOfAlert =
        GroupAlertDialogModelProvider.watch(context)?.groupAlertDialogModel;
    final modelOfGroups =
        GroupAlertDialogModelProvider.watch(context)?.groupsWidgetModel;
    final int? selectedGroup = modelOfGroups?.selectedGroup();
    String nameOfGroup =
        selectedGroup != null && modelOfAlert?.errorText == null
            ? '${modelOfGroups?.groups[selectedGroup].name}'
            : '';
    modelOfAlert?.controller.text = nameOfGroup;
    modelOfAlert?.controller.selection = TextSelection(
        baseOffset: 0, extentOffset: modelOfAlert.controller.text.length);
    return TextField(
      enableInteractiveSelection: true,
      controller: modelOfAlert?.controller,
      autofocus: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Group name',
        errorText: modelOfAlert?.errorText,
      ),
      onEditingComplete: () {
        modelOfAlert?.saveRenameGroup(context, groupIndex: selectedGroup);
        modelOfGroups?.disableGroupsSelection();
        modelOfAlert?.exitDialogWindow(context);
      },
    );
  }
}
