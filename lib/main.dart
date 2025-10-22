import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'auth/login_controller.dart';
import 'bannerService.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ioazdjfgrwwmvnacjjcz.supabase.co',
    anonKey: 'sb_publishable_6pHQ7QXsPOCcY1wNn77K4w_0olVHuCN',
  );

  // Initialize services
  Get.put(BannerService());

  Get.put(ApiService(), permanent: true);
  Get.put(AuthController(), permanent: true);

  // Set preferred orientations (optional)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const App());
}
