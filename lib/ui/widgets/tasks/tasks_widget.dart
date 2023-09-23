import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/tasks/tasks_widget_model.dart';
import '../app/constants.dart';

class TaskWidgetModelConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetModelConfiguration({required this.groupKey, required this.title});
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetModelConfiguration configuration;

  const TasksWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;
  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    return TasksWidgetModelProvider(
      model: model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final tasksSelectionEnabled = model!.tasksSelectionEnabled;
    final title = tasksSelectionEnabled
        ? Text('${model.countOfSelectedTasks} Selected')
        : _NameTaskWidget(model: model);
    final bodyOfScaffold = model.tasks.isEmpty
        ? const _EmptyPageTextWidget()
        : const _TaskListWidget();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: tasksSelectionEnabled
          ? IntrinsicHeight(
              child: _NavigationBarWidget(model: model),
            )
          : null,
      body: bodyOfScaffold,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: title,
      ),
      floatingActionButton: !tasksSelectionEnabled
          ? _FloatingActionButtonAddWidget(model: model)
          : null,
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
          'Press + to add a new task.',
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

class _NameTaskWidget extends StatelessWidget {
  const _NameTaskWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TasksWidgetModel? model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.format_list_bulleted_rounded),
        const SizedBox(width: 5),
        Text(model!.configuration.title),
      ],
    );
  }
}

class _FloatingActionButtonAddWidget extends StatelessWidget {
  const _FloatingActionButtonAddWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TasksWidgetModel? model;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => model?.showForm(context),
      child: const Icon(Icons.add),
    );
  }
}

class _NavigationBarWidget extends StatelessWidget {
  const _NavigationBarWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TasksWidgetModel? model;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CancelButtonNavigationWidget(model: model),
            const VerticalDivider(
              indent: 2,
              endIndent: 2,
              color: Colors.black,
              thickness: 1,
              width: 2,
            ),
            _DeleteButtonNavigationWidget(model: model)
          ],
        ),
      ),
    );
  }
}

class _DeleteButtonNavigationWidget extends StatelessWidget {
  const _DeleteButtonNavigationWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TasksWidgetModel? model;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => model?.deleteAllSelected(),
      icon: const Text(
        'Delete',
        style: WidgetConstants.textStyleNavigationBar,
      ),
      label: WidgetConstants.deleteIcon,
    );
  }
}

class _CancelButtonNavigationWidget extends StatelessWidget {
  const _CancelButtonNavigationWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TasksWidgetModel? model;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => model?.disableTasksSelection(),
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

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: ((BuildContext context, index) => _TaskListRowWidget(
            indexInList: index,
          )),
      separatorBuilder: (context, index) => Divider(
        indent: 75,
        height: 0.5,
        endIndent: 75,
        thickness: 1,
        color: WidgetConstants.colorSecond.shade400,
      ),
      itemCount: groupsCount,
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];
    final icon =
        task.isDone ? Icons.check_circle_rounded : Icons.circle_outlined;
    final style = task.isDone
        ? const TextStyle(
            decoration: TextDecoration.lineThrough, color: Colors.grey)
        : null;
    final colorOfCheckBox =
        task.isDone ? Colors.grey : WidgetConstants.colorMain;
    return ColoredBox(
      color: model.checkTaskSelected(indexInList)
          ? WidgetConstants.colorMain.shade50
          : Colors.grey.shade100,
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          title: Text(
            task.text,
            style: style,
          ),
          trailing: Icon(icon, size: 30, color: colorOfCheckBox),
          onTap: () => !model.tasksSelectionEnabled
              ? model.doneToggle(indexInList)
              : model.selectTask(indexInList),
          onLongPress: () => !model.tasksSelectionEnabled
              ? model.enalbeTasksSelection(indexInList)
              : null),
    );
  }
}
