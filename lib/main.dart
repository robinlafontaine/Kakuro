import 'package:audioplayers/audioplayers.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/theme.dart';
import 'package:kakuro/screens/menu.dart';
import 'config/config.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kakuro/config/theme.dart';
import 'package:kakuro/config/config.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  WidgetsFlutterBinding.ensureInitialized();
  Config.sons.player.play(AssetSource('loop.mp3'));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await GetStorage.init();
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    Storage.fetchTheme();
    _theme = Config.theme!;
  }

  @override
  Widget build(BuildContext context) {
    return MyThemeData(
      themeData: _theme,
      onThemeUpdated: (newTheme) {
        setState(() {
          _theme = newTheme;
        });
      },
      child: MaterialApp(
        theme: _theme,
        debugShowCheckedModeBanner: false,
        home: const Menu(),
      ),
    );
  }
}
