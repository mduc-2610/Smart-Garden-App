
import 'package:flutter/material.dart';
import 'package:smart_garden_app/features/garden/garden_menu_redirection.dart';
import 'package:smart_garden_app/main.reflectable.dart';
import 'package:smart_garden_app/utils/theme/theme.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  // Token? token = await TokenService.getToken();
  // $print(token);
  runApp(
     const MyApp(),
    );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // home: RegistrationFirstStepView(),
      home: const GardenMenuRedirection(),
    );
  }
}
