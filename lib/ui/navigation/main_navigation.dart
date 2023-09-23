import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/groups/groups_widget.dart';
import 'package:flutter_application_first/ui/widgets/tasks/tasks_widget.dart';
import 'package:flutter_application_first/ui/widgets/tasks_form/task_form_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  // static const groupsForm = '/groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
    // MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    if (settings.name == MainNavigationRouteNames.tasks) {
      final configuration = settings.arguments as TaskWidgetModelConfiguration;
      return MaterialPageRoute(
          builder: (context) => TasksWidget(configuration: configuration));
    } else if (settings.name == MainNavigationRouteNames.tasksForm) {
      final groupKey =
          (settings.arguments as TaskWidgetModelConfiguration).groupKey;
      return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupKey: groupKey));
    } else {
      const widget = Text('Navigation Error!!!');
      return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
