import 'dart:io';

import 'package:download_manager/model/object_download.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/pages/home.dart';
import 'package:download_manager/pages/setting.dart';
import 'package:download_manager/pages/splash.dart';
import 'package:download_manager/theme/theme.dart';
import 'package:download_manager/theme/theme_notifier.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'global.dart';

void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations( Device.get().isPhone ?
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,] :
  [DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]
  ).then((_) async {
    var path =  await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    Hive.registerAdapter(ObjectStorageAdapter());
    Hive.registerAdapter(ObjectStorageTypeAdapter());
    Hive.registerAdapter(ObjectDownloadStateAdapter());
    Hive.registerAdapter(ObjectDownloadAdapter());
    Hive.registerAdapter(ObjectSegmentDownloadAdapter());

    SharedPreferences.getInstance().then((prefs) {
      Global.darkMode = prefs.getBool('darkMode') ?? false;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(Global.darkMode ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }
  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => SplashPage(),
    // Routes.HOME: (BuildContext context) => HomePage(),
    // Routes.SETTING: (BuildContext context) => SettingPage(),
  };

  @override
  Widget build(BuildContext context) {

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.red,
    //   statusBarIconBrightness: Global.darkMode ? Brightness.light : Brightness.dark,
    //   statusBarBrightness: Global.darkMode ? Brightness.light : Brightness.dark,
    //   systemNavigationBarColor: Global.darkMode ? Colors.black : Colors.white,
    //   systemNavigationBarDividerColor: Colors.grey,
    //   systemNavigationBarIconBrightness: Global.darkMode ? Brightness.dark : Brightness.light,
    // ));
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.black
    // ));
    return MaterialApp(
      key: key,
      title: 'Download Manager',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      routes: routes,
    );
  }

}
class Routes {
  static const String SPLASH = "/";
  static const String HOME = "/home";
  static const String SETTING = "/setting";
}