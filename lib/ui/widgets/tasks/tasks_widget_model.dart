import 'package:flutter/foundation.dart';
import 'package:flutter_application_first/domain/data_provider/box_manager.dart';
import 'package:flutter_application_first/domain/entity/task.dart';
import 'package:flutter_application_first/ui/navigation/main_navigation.dart';
import 'package:flutter_application_first/ui/widgets/tasks/tasks_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class TasksWidgetModel extends ChangeNotifier {
  final TaskWidgetModelConfiguration configuration;
  ValueListenable<Object>? _listenableBox;

  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();
  final List<int> _selecedTasks = [];
  bool _isTasksSelection = false;
  bool get tasksSelectionEnabled => _isTasksSelection;

  int get countOfSelectedTasks => _selecedTasks.length;

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
        arguments: configuration);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> deleteTask(int taskIndex) async {
    (await _box).deleteAt(taskIndex);
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  void selectTask(int taskIndex) {
    if (_selecedTasks.contains(taskIndex)) {
      _selecedTasks.remove(taskIndex);
      notifyListeners();
    } else {
      _selecedTasks.add(taskIndex);
      notifyListeners();
    }
    if (_selecedTasks.isEmpty) {
      disableTasksSelection();
    }
  }

  void disableTasksSelection() {
    _isTasksSelection = false;
    _selecedTasks.clear();
    notifyListeners();
  }

  void enalbeTasksSelection(int taskIndex) {
    _isTasksSelection = true;
    selectTask(taskIndex);
    notifyListeners();
  }

  Future<void> deleteAllSelected() async {
    _selecedTasks.sort();
    for (int groupIndex in _selecedTasks.reversed) {
      await deleteTask(groupIndex);
    }
    disableTasksSelection();
  }

  bool checkTaskSelected(int groupIndex) {
    return _selecedTasks.contains(groupIndex);
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    await _readTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(() => _readTasksFromHive());
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
