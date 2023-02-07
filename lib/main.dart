import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/routes.dart';
import 'package:learnflutter/ui/pages/datamanage/data_page.dart';
import 'package:learnflutter/ui/pages/history/history_page.dart';
import 'package:learnflutter/ui/pages/home/home_page.dart';
import 'package:learnflutter/ui/pages/map/map_page.dart';
import 'package:learnflutter/ui/pages/settings/settings_page.dart';
import 'package:learnflutter/ui/pages/signup/signup_page.dart';

void main() {
  runApp(const IPLTApp());
}

class IPLTApp extends StatelessWidget {
  const IPLTApp({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Get.put(GlobalModel());  // global data

    return Obx(() {
      int modeCode = model.darkMode;
      ThemeMode mode;
      LoggerUtils.d('main', 'dark mode is $modeCode');
      switch (modeCode) {
        case 0:
        // light mode
          mode = ThemeMode.light;
          break;
        case 1:
        // dark mode
          mode = ThemeMode.dark;
          break;
        default:
        // follow system
          mode = ThemeMode.system;
          break;
      }

      return GetMaterialApp(
        initialRoute: Routes.signup,
        getPages: [
          GetPage(name: Routes.signup, page: () => const SignupPage()),
          GetPage(name: Routes.home, page: () => const HomePage()),
          GetPage(name: Routes.data, page: () => DataPage()),
          GetPage(name: Routes.map, page: () => MapPage()),
          GetPage(name: Routes.history, page: () => const HistoryPage()),
          GetPage(name: Routes.settings, page: () => const SettingsPage())
        ],
        routingCallback: (routing) {
          // Handle the right index when routing back.
          // Use preventDuplicates to avoid duplicate routing.
          switch (routing!.current) {
            case Routes.home:
              model.navigationIndex = 0;
              break;
            case Routes.data:
              model.navigationIndex = 1;
              break;
            case Routes.map:
              model.navigationIndex = 2;
              break;
            case Routes.history:
              model.navigationIndex = 3;
              break;
            case Routes.settings:
              model.navigationIndex = 4;
              break;
            default:
              break;
          }
        },
        themeMode: mode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      );
    });
  }
}
