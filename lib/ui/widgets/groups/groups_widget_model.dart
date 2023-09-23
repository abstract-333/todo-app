import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_first/domain/data_provider/box_manager.dart';
import 'package:flutter_application_first/domain/entity/group.dart';
import 'package:flutter_application_first/ui/navigation/main_navigation.dart';
import 'package:flutter_application_first/ui/widgets/tasks/tasks_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];
  final _groupsSelected = <int>[];
  bool _isGroupsSelection = false;

  List<Group> get groups => _groups.toList();

  set groupsSelectionEnabled(bool value) => _isGroupsSelection = value;

  bool get groupsSelectionEnabled => _isGroupsSelection;

  int get countOfSelectedGroups => _groupsSelected.length;

  GroupsWidgetModel() {
    _setup();
  }
  bool checkGroupSelected(int groupIndex) {
    return _groupsSelected.contains(groupIndex);
  }

  int? selectedGroup() {
    if (_groupsSelected.isNotEmpty) {
      return _groupsSelected[0];
    }
    return null;
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetModelConfiguration(
          groupKey: group.key as int, title: group.name);
      unawaited(Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.tasks, arguments: configuration));
    }
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  void selectGroup(int groupIndex) {
    if (_groupsSelected.contains(groupIndex)) {
      _groupsSelected.remove(groupIndex);
      notifyListeners();
    } else {
      _groupsSelected.add(groupIndex);
      notifyListeners();
    }
    if (_groupsSelected.isEmpty) {
      disableGroupsSelection();
    }
  }

  void enableGroupsSelection(int groupIndex) {
    if (!groupsSelectionEnabled) {
      groupsSelectionEnabled = true;
      selectGroup(groupIndex);
      notifyListeners();
    }
  }

  void disableGroupsSelection() {
    if (groupsSelectionEnabled) {
      groupsSelectionEnabled = false;
      _groupsSelected.clear();
      notifyListeners();
    }
  }

  Future<void> deleteAllSelected() async {
    _groupsSelected.sort();
    for (int groupIndex in _groupsSelected.reversed) {
      await deleteGroup(groupIndex);
    }
    disableGroupsSelection();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {required this.model, Key? key, required Widget child})
      : super(key: key, notifier: model, child: child);

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
