import 'package:flutter/material.dart';
import 'package:flutter_application_first/ui/widgets/app/my_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const MaterialApp(
    debugShowCheckedModeBanner: false,
  );
  runApp(const MyApp());
}
