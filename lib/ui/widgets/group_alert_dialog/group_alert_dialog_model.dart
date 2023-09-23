import 'package:flutter/cupertino.dart';
import 'package:flutter_application_first/domain/data_provider/box_manager.dart';
import 'package:flutter_application_first/domain/entity/group.dart';
import 'package:flutter_application_first/ui/widgets/groups/groups_widget_model.dart';

class GroupAlertDialogModel extends ChangeNotifier {
  var _groupName = '';
  final TextEditingController controller = TextEditingController();
  String? errorText;

  void exitDialogWindow(BuildContext context) {
    if (errorText == null) {
      Navigator.of(context).pop();
    }
  }

  set groupName(String value) {
    if (errorText != null && value.isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  String get groupName => _groupName;

  void saveRenameGroup(BuildContext context, {int? groupIndex}) async {
    final groupName = controller.text.trim();
    this.groupName = groupName;
    if (groupName.isEmpty) {
      errorText = 'Enter without spaces';
      controller.text = '';
      notifyListeners();
      return;
    }
    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    if (groupIndex == null) {
      await box.add(group);
    } else {
      await box.putAt(groupIndex, group);
    }
    await BoxManager.instance.closeBox(box);
  }
}

class GroupAlertDialogModelProvider extends InheritedNotifier {
  final GroupAlertDialogModel groupAlertDialogModel;
  final GroupsWidgetModel groupsWidgetModel;

  const GroupAlertDialogModelProvider(
      {required this.groupAlertDialogModel,
      required this.groupsWidgetModel,
      Key? key,
      required Widget child})
      : super(
          key: key,
          child: child,
          notifier: groupAlertDialogModel,
        );

  static GroupAlertDialogModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupAlertDialogModelProvider>();
  }

  static GroupAlertDialogModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            GroupAlertDialogModelProvider>()
        ?.widget;
    return widget is GroupAlertDialogModelProvider ? widget : null;
  }
}
