import 'package:audioplayers/audioplayers.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/menu.dart';
import 'config/config.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
      .then((_) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

final light = ColorScheme.fromSwatch(
    primarySwatch: ColorTools.createPrimarySwatch(const Color(0xFFE0E0E0)),
    accentColor: const Color(0xFF464646),
    brightness: Brightness.light);

final dark = ColorScheme.fromSwatch(
    primarySwatch: ColorTools.createPrimarySwatch(const Color(0xFFE0E0E0)),
    accentColor: const Color(0xFF464646),
    brightness: Brightness.dark);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          colorScheme: light,
          useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const Menu(),
    );
  }
}
