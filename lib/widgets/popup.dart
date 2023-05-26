import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({super.key});

  static Future<void> showAlert(context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Attention"),
            content: const Text(
                "Les données ne sont pas à jour, vérifiez votre connexion internet."),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
