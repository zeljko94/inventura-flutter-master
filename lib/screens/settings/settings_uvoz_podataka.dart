import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsUvozPodatakaScreen extends StatefulWidget {
  const SettingsUvozPodatakaScreen({ Key? key }) : super(key: key);

  @override
  _SettingsUvozPodatakaScreenState createState() => _SettingsUvozPodatakaScreenState();
}

class _SettingsUvozPodatakaScreenState extends State<SettingsUvozPodatakaScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  
  bool obrisiArtiklePrilikomImportaSwitch = false;
  TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();
  String? csvDelimiterSimbol;
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController dialogInputTextController = TextEditingController();


  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero, () async {
      var settings = await _appSettingsService.getSettings();
      
      setState(() {
        obrisiArtiklePrilikomImportaSwitch = settings.obrisiArtiklePrilikomUvoza! > 0;
        csvDelimiterSimbol = settings.csvDelimiterSimbol;
      });
      linkZaUvozPodatakaSaRestApijaController.text = settings.restApiLinkImportArtikli!;
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
                    padding: EdgeInsets.all(8.0),
                    child: Text('Obriši artikle prilikom uvoza'),
                  ),
                  CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
                    setState(() {
                      obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
                    });
                  })
                ],),
                InkWell(
                  onTap: () async {
                    var result = await _displayInputDialog('Csv delimiter simbol', '', 'Simbol', false, csvDelimiterSimbol, context);
                  },
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Csv delimiter simbol'),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText)
                  ],
                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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

}