import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_states_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarThemeData(
          backgroundColor: AppColor().primaryColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: AppColor().backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor().primaryColor),
      ),
      home: const RealStatesPage(),
    );
  }
}
