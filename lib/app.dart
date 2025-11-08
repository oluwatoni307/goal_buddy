import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'banner.dart';
import 'bannerService.dart';
import 'routes.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Goal Buddy',
      debugShowCheckedModeBanner: false,
      theme: materialLightTheme,
      initialRoute: Routes.splash,
      getPages: Routes.pages,
      home: Stack(
        children: [
          // Your normal app content goes here
          const SizedBox.expand(),

          // Persistent floating banner (lives above all screens)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final bannerService = Get.find<BannerService>();
              if (!bannerService.isVisible.value) {
                return const SizedBox.shrink();
              }

              return PersistentFloatingBanner(
                isVisible: bannerService.isVisible,
                message: bannerService.message,
                bannerType: bannerService.bannerType,
                onDismiss: () {
                  bannerService.hide();
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
