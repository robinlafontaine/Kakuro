import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'GeeskforGeeks';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Colors.green,
        ),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () =>
            {Auth(FirebaseAuth.instance).signInWithGoogle(context)},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GeeksforGeeks is',
              style: TextStyle(
                color: Colors.white,
              ),
            ), // <-- Text

            Icon(
              // <-- Icon
              Icons.favorite,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
