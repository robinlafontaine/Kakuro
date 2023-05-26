import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({Key? key}) : super(key: key);

  static Future<void> showAlert(context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Attention"),
            content: const Text(
                "Les données ne sont pas à jour, vérifiez votre connexion internet."),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
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
