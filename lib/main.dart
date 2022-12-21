import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return GetMaterialApp(
      initialRoute: Routes.signup,
      getPages: [
        GetPage(name: Routes.signup, page: () => const SignupPage()),
        GetPage(name: Routes.home, page: () => const HomePage()),
        GetPage(name: Routes.data, page: () => const DataPage()),
        GetPage(name: Routes.map, page: () => const MapPage()),
        GetPage(name: Routes.history, page: () => const HistoryPage()),
        GetPage(name: Routes.settings, page: () => const SettingsPage())
      ],
    );
  }
}
