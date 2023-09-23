import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/app/constants.dart';
import 'package:flutter_application_first/ui/widgets/tasks_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;
  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TextFromWidgetBody(),
    );
  }
}

class _TextFromWidgetBody extends StatelessWidget {
  const _TextFromWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.watch(context)?.model;
    final actionButton = FloatingActionButton(
      onPressed: () => model?.saveTasks(context),
      child: const Icon(Icons.done),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WidgetConstants.colorSecond.shade100,
        title: const Text('<New Task>'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextWidget(),
        ),
      ),
      floatingActionButton: model?.isValid == true ? actionButton : null,
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'File text',
      ),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTasks(context),
    );
  }
}
