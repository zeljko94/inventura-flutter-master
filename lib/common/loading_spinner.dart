import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';

//Prikaz spinnera -  buildLoading(context);
//Makni spinner - Navigator.of(context).pop();

buildLoadingSpinner(String msg, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(msg, style: TextStyle(color: ColorPalette.basic[50]),),
              )
            ],
          )
        );
      });
}

removeLoadingSpinner(BuildContext context) {
  Navigator.of(context).pop();
}