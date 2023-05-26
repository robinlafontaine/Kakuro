import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/config/theme.dart';
import 'package:kakuro/duels.dart';
import 'package:kakuro/screens/menu.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Storage.fetchTheme();
    _theme = Config.theme!;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) &&
        Config.multi.inMulti == true) {
      // send current user data
      Duels().sendResults(
          Config.multi.gameID,
          FirebaseAuth.instance.currentUser?.uid,
          -1,
          Config.multi.n,
          Config.multi.m);
      Config.multi.clearMulti();
      if (kDebugMode) {
        print("multi cleared");
      }
      // TODO
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Multijoueur()))
          .then((value) {
        Navigator.pop(context);
      });
      setState(() {});
    }
    if (state == AppLifecycleState.resumed) {
      Config.sons.player.resume();
    } else {
      Config.sons.player.pause();
    }
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
