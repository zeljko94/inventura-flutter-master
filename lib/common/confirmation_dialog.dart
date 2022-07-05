import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';

class ConfirmationDialog {
  static openConfirmationDialog(
    title,
    subtitle,
    context,
  ) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(title),
                content: (Text(subtitle)),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: ColorPalette.primary,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Ne'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      primary: const Color.fromARGB(255, 255, 255, 255),
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () => {
                      Navigator.pop(context, true),
                    },
                    child: const Text('Da'),
                  ),
                ],
              ));
}
