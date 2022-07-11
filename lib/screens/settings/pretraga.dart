import 'package:inventura_app/common/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/screens/settings/settings.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsPretragaScreen extends StatefulWidget {
  const SettingsPretragaScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPretragaScreen> createState() => _SettingsPretragaScreenState();
}

class _SettingsPretragaScreenState extends State<SettingsPretragaScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;

  // String? defaultSearchInputMethod = 'keyboard';
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;
  List<String> vrsteUnosaPretrazivanja = ['keyboard', 'scan'];

  final _formKeyDialogInput = GlobalKey<FormState>();
  final _formKeyDialogDropdown = GlobalKey<FormState>();
  TextEditingController dialogInputTextController = TextEditingController();

  
  final List<CheckboxListItem> poljaZaPretraguCheckboxItemsScanner = [
    CheckboxListItem(label: 'naziv', isChecked: false),
    CheckboxListItem(label: 'barkod', isChecked: false),
    CheckboxListItem(label: 'šifra', isChecked: false),
  ];

  final List<CheckboxListItem> poljaZaPretraguCheckboxItemsKeyboard = [
    CheckboxListItem(label: 'naziv', isChecked: false),
    CheckboxListItem(label: 'barkod', isChecked: false),
    CheckboxListItem(label: 'šifra', isChecked: false),
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var settings = await _appSettingsService.getSettings();
      
      setState(() {
        _settings = settings;
        var poljaZaPretraguScanner = _settings!.scannerInputModeSearchByFields!.split(',');
        poljaZaPretraguCheckboxItemsScanner.forEach((element) {
          if(poljaZaPretraguScanner.firstWhere((x) => x == element.label, orElse: () => '') != '') {
            element.isChecked = true;
          }
        });

        var poljaZaPretraguKeyboard = _settings!.keyboardInputModeSearchByFields!.split(',');
        poljaZaPretraguCheckboxItemsKeyboard.forEach((element) {
          if(poljaZaPretraguKeyboard.firstWhere((x) => x == element.label, orElse: () => '') != '') {
            element.isChecked = true;
          }
        });

        dialogInputTextController.text = _settings!.numberOfResultsPerSearch!.toString();
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Pretraga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),
                InkWell(
                  onTap: () async {
                      var res = await _displayZadanaMetodaUnosaPretrazivanja('Odaberite zadanu vrstu pretraživanja', context);
                      if(res != null) {
                        await _updateZadanaMetodaPretrazivanja(res);
                      }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(0),
                    child: 
                      IgnorePointer(
                        ignoring: true,
                        child: ExpansionTile(
                        title: Text('Zadana metoda pretraživanja'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                        // subtitle: Text('Trailing expansion arrow icon'),
                        ),
                      ),
                  ),),
                  
                    ExpansionTile(
                      title: const Text('Pretraga skeniranjem pretražuje po poljima'),
                      children: <Widget>[
                        for(var i=0; i<poljaZaPretraguCheckboxItemsScanner.length; i++)
                          CheckboxListTile(
                            checkColor: ColorPalette.success,
                            title: Text(poljaZaPretraguCheckboxItemsScanner[i].label!),
                            value: poljaZaPretraguCheckboxItemsScanner[i].isChecked,
                            onChanged: (value) async {
                              setState(() {
                                poljaZaPretraguCheckboxItemsScanner[i].isChecked = !poljaZaPretraguCheckboxItemsScanner[i].isChecked!;
                              });
                              await _updatePretragaSkeniranjemPretrazujePoPoljima();
                            },
                          )
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Pretraga unosom pretražuje po poljima'),
                      children: <Widget>[
                        for(var i=0; i<poljaZaPretraguCheckboxItemsKeyboard.length; i++)
                          CheckboxListTile(
                            checkColor: ColorPalette.success,
                            title: Text(poljaZaPretraguCheckboxItemsKeyboard[i].label!),
                            value: poljaZaPretraguCheckboxItemsKeyboard[i].isChecked,
                            onChanged: (value) async {
                              setState(() {
                                poljaZaPretraguCheckboxItemsKeyboard[i].isChecked = !poljaZaPretraguCheckboxItemsKeyboard[i].isChecked!;
                              });
                              await _updatePretragaKeyboardPretrazujePoPoljima();
                            },
                          )
                      ],
                    ),
                      InkWell(
                        child: IgnorePointer(
                        ignoring: true,
                          child: ExpansionTile(
                          title: Text('Broj rezultata po pretraživanju'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                          ),
                        ),
                        onTap: () async {
                            var result = await _displayInputDialog('Broj rezultata po pretraživanju', 'Broj rezultata koji se prikazuje prilikom pretraživanja', 'Broj pretraživanja', true, _settings!.numberOfResultsPerSearch, context);
                            if(result != null && result != '' && result != 0) {
                              await _updateBrojRezultataPoPretrazivanju();
                            }
                        },
                      ),
              ],)
            ),
          );
  }

  _updateZadanaMetodaPretrazivanja(String value) async{
    setState(() {
      _settings!.defaultSearchInputMethod = value;
    });
    await _appSettingsService.update(_settings!.id!, _settings!);
  }

  _updatePretragaSkeniranjemPretrazujePoPoljima() async {
    String result = poljaZaPretraguCheckboxItemsScanner.where((element) => element.isChecked!).map((e) => e.label!).toList().join(',');
    setState(() {
      _settings!.scannerInputModeSearchByFields = result;
    });
    await _appSettingsService.update(_settings!.id!, _settings!);
  }

  _updatePretragaKeyboardPretrazujePoPoljima() {
    String result = poljaZaPretraguCheckboxItemsKeyboard.where((element) => element.isChecked!).map((e) => e.label!).toList().join(',');
    setState(() {
      _settings!.keyboardInputModeSearchByFields = result;
    });
    _appSettingsService.update(_settings!.id!, _settings!);
  }

  _updateBrojRezultataPoPretrazivanju() async {
    setState(() {
      _settings!.numberOfResultsPerSearch = int.tryParse(dialogInputTextController.text);
    });
    await _appSettingsService.update(_settings!.id!, _settings!);
  }
  
  
  Future<dynamic> _displayZadanaMetodaUnosaPretrazivanja(String title, BuildContext context) async {
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
                      key: _formKeyDialogInput,
                      child: DropdownButtonFormField<String>(
                        value: _settings!.defaultSearchInputMethod,
                        hint: const Text('Vrsta unosa:'),
                        validator: (value) => value == null ? 'Vrsta unosa' : null,
                        decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Vrsta unosa',
                        floatingLabelStyle:
                            TextStyle(color: ColorPalette.primary),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette.primary,
                              width: 2.0),
                        ),
                      ),
                        items: vrsteUnosaPretrazivanja.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (vrstaUnosa) {
                          setState(() {
                            _settings!.defaultSearchInputMethod = vrstaUnosa;
                          });
                        },
                      ),
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
                    if (_formKeyDialogInput.currentState!.validate()) {
                      Navigator.pop(context, _settings!.defaultSearchInputMethod);
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
                  key: _formKeyDialogInput,
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
                    if (_formKeyDialogInput.currentState!.validate()) {
                      var res = dialogInputTextController.text;
                      Navigator.pop(context, res);
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