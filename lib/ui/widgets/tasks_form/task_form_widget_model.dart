import 'package:flutter/cupertino.dart';
import 'package:flutter_application_first/domain/data_provider/box_manager.dart';
import 'package:flutter_application_first/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  var _taskText = '';
  int groupKey;

  TaskFormWidgetModel({required this.groupKey});

  set taskText(String value) {
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  bool get isValid => _taskText.trim().isNotEmpty;

  void saveTasks(BuildContext context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) return;
    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(key: key, child: child, notifier: model);

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }
}
