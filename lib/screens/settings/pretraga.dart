import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';

class SettingsPretragaScreen extends StatefulWidget {
  const SettingsPretragaScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPretragaScreen> createState() => _SettingsPretragaScreenState();
}

class _SettingsPretragaScreenState extends State<SettingsPretragaScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Zadana metoda unosa pretraživanja'),
              ),
              const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText,)
            ],
        ),
    );
  }
  
  _buildBody() {}
}