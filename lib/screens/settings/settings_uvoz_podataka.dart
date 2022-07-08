import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsUvozPodatakaScreen extends StatefulWidget {
  const SettingsUvozPodatakaScreen({ Key? key }) : super(key: key);

  @override
  _SettingsUvozPodatakaScreenState createState() => _SettingsUvozPodatakaScreenState();
}

class _SettingsUvozPodatakaScreenState extends State<SettingsUvozPodatakaScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;
  
  // bool obrisiArtiklePrilikomImportaSwitch = false;
  TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();
  // String? csvDelimiterSimbolImport;
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController dialogInputTextController = TextEditingController();


  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero, () async {
      await _fetchAppSettings();
      linkZaUvozPodatakaSaRestApijaController.text = _settings!.restApiLinkImportArtikli!;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Uvoz podataka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Text('Obriši artikle prilikom uvoza'),
                  ),
                  CupertinoSwitch(value: _settings == null || _settings!.obrisiArtiklePrilikomUvoza! == 0 ? false : true, onChanged: (value) async {
                      await _updateObrisiArtiklePrilikomImporta(value);
                  })
                ],),
                InkWell(
                  onTap: () async {
                    var result = await _displayInputDialog('Csv delimiter simbol', '', 'Simbol', false, _settings!.csvDelimiterSimbolImport, context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: ExpansionTile(
                      trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                      title: Text('Csv delimiter simbol'),
                      children: <Widget>[
                      ],
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: null,
                    controller: linkZaUvozPodatakaSaRestApijaController,
                    cursorColor: ColorPalette.primary,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Link za uvoz podataka sa rest backenda',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onTap: () async {
      
                    },
                  ),
                ),
              ],)
            ),
          );
  }

    Future<dynamic> _displayInputDialog(String title, String message, String inputLabel, bool isNumberOnly, dynamic value, BuildContext context) async {
    dialogInputTextController.text = value.toString();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: 
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Text(message),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: isNumberOnly ? TextInputType.number : TextInputType.text,
                    controller: dialogInputTextController,
                    cursorColor: ColorPalette.primary,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: inputLabel,
                      floatingLabelStyle: const TextStyle(color: ColorPalette.primary),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value == '') {
                        return inputLabel + ' je obavezno polje.';
                      }

                      if(isNumberOnly) {
                        var numberValue = double.tryParse(value);
                        if(numberValue == null) {
                          return 'Unesite broj.';
                        }
                      }
                      return null;
                    },
                    onTap: () async {
    
                    },
                  )
                ),
              ],
            ),  
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    dialogInputTextController.clear();
                  },
                  child: const Text('Odustani'),
                  style: ElevatedButton.styleFrom(
                    primary:ColorPalette.danger
                  ),
                ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, dialogInputTextController.text);
                      dialogInputTextController.clear();
                    }
                  },
                  child: const Text('Potvrdi'),
                  style: ElevatedButton.styleFrom(
                    primary: ColorPalette.primary
                  ),
                ),
            ],
        );
      });
  }

  _updateObrisiArtiklePrilikomImporta(bool value) async {
    _settings!.obrisiArtiklePrilikomUvoza = value ? 1 : 0;
    _appSettingsService.update(_settings!.id!, _settings!);
    await _fetchAppSettings();
  }
  
  _fetchAppSettings() async {
    var settings = await _appSettingsService.getSettings();
    
    setState(() {
      _settings = settings;
    });
    print("SETTINGS UVOZ");
    print(_settings!.toMap());
  }

}