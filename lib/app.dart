import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QuickStart',
      debugShowCheckedModeBanner: false,
      theme: materialLightTheme,
      initialRoute: Routes.login,
      getPages: Routes.pages,
    );
  }
}