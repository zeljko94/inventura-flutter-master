import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsSkeniranjeScreen extends StatefulWidget {
  const SettingsSkeniranjeScreen({ Key? key }) : super(key: key);

  @override
  _SettingsSkeniranjeScreenState createState() => _SettingsSkeniranjeScreenState();
}

class _SettingsSkeniranjeScreenState extends State<SettingsSkeniranjeScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;


  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
      await _fetchAppSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.qr_code_2),
                  title: Text('Skeniranje', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Text('Trim leading zeros'),
                  ),
                  CupertinoSwitch(value: _settings == null || _settings!.trimLeadingZeros! == 0 ? false : true, onChanged: (value) async {
                    await _updateTrimLeadingZeros(value);
                  })
                ],),
              ],)
            ),
          );
  }


  _updateTrimLeadingZeros(bool value) async {
    _settings!.trimLeadingZeros  = value ? 1 : 0;
    await _appSettingsService.update(_settings!.id!, _settings!);
    await _fetchAppSettings();
  }

  _fetchAppSettings() async {
    var settings = await _appSettingsService.getSettings();

    setState(() {
      _settings = settings;
    });
    print("SETTINGS SKENIRANJE");
    print(_settings!.toMap());
  }
}