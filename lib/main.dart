import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:paychain_mobile/routes/routes.dart';
import 'package:paychain_mobile/shared/theme/theme_const.dart';
import 'package:paychain_mobile/utils/helpers/database_helper.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(),
      initialRoute: Routes.loginScreen,
    );
  }
}
