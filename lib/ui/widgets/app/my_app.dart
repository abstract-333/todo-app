import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/navigation/main_navigation.dart';
import 'package:flutter_application_first/ui/widgets/app/constants.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do',
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      theme: ThemeData(
        textTheme: const TextTheme(subtitle1: WidgetConstants.mainTextStyle),
        splashColor: Colors.white,
        scaffoldBackgroundColor: WidgetConstants.colorSecond.shade100,
        primarySwatch: WidgetConstants.colorMain,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: WidgetConstants.colorMain.shade400,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: WidgetConstants.appBarTextStyle,
          color: WidgetConstants.colorSecond.shade300,
          centerTitle: true,
        ),
      ),
    );
  }
}
