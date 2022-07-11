
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/screens/settings/pretraga.dart';
import 'package:inventura_app/screens/settings/settings_izvoz_podataka.dart';
import 'package:inventura_app/screens/settings/settings_uvoz_podataka.dart';
import 'package:inventura_app/screens/settings/skeniranje.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar('Postavke', context),
        body: _buildBody(),
        drawer: MenuDrawer.getDrawer());
  }
  
  _buildBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
          image: const AssetImage(ColorPalette.backgroundImagePath),
          fit: BoxFit.cover),
      ),
      child: SingleChildScrollView(child: Column(
        children: const [
          SettingsPretragaScreen(),
    
          SettingsSkeniranjeScreen(),
          
          SettingsUvozPodatakaScreen(),
          
          SettingsIzvozPodatakaScreen()
          
        ],
      ),),
    );
  }

  AppBar _buildAppbar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
      ],
    );
  }

}




class CheckboxListItem {
  String? label;
  bool? isChecked = false;

  CheckboxListItem({ this.label, this.isChecked });
}