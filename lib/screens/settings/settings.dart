
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;

  // String? defaultSearchInputMethod = 'keyboard';
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;
  List<String> vrsteUnosaPretrazivanja = ['keyboard', 'scanner'];

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


    TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();
  // String? csvDelimiterSimbolImport;
  
  final _formKey = GlobalKey<FormState>();

  final List<CheckboxListItem> poljaZaExportCheckboxItems = [
    CheckboxListItem(label: 'naziv', isChecked: false),
    CheckboxListItem(label: 'barkod', isChecked: false),
    CheckboxListItem(label: 'šifra', isChecked: false),
    CheckboxListItem(label: 'količina', isChecked: false),
    CheckboxListItem(label: 'jedinica mjere', isChecked: false),
  ];




  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _fetchAppSettings();
    });
  }

  _fetchAppSettings() async {
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
        linkZaUvozPodatakaSaRestApijaController.text = _settings!.restApiLinkImportArtikli!;

        var poljaZaExport = _settings!.exportDataFields!.split(',');
        poljaZaExportCheckboxItems.forEach((element) {
          if(poljaZaExport.firstWhere((x) => x == element.label, orElse: () => '') != '') {
            element.isChecked = true;
          }
        });
      });
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
        children: [
          // PRETRAGA
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
                      title: const Text('Pretraga skeniranjem pretražuje po'),
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
                      title: const Text('Pretraga unosom pretražuje po'),
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
          ),
          // PRETRAGA END
    
          // SKENIRANJE BEGIN
          Padding(
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
                ),
                // SKENIRANJE END
          
          // UVOZ PODATAKA BEGIN
          Padding(
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
                    if(result != null) {
                      _settings!.csvDelimiterSimbolImport = result;
                      _appSettingsService.update(_settings!.id!, _settings!);
                    }
                  },
                  child: const IgnorePointer(
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
                  child: Focus(
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
                      onChanged: (value) async {
                        _settings!.restApiLinkImportArtikli = value;
                        _appSettingsService.update(_settings!.id!, _settings!);
                      },
                      validator: (value) {
                        return null;
                      },
                      onTap: () async {
        
                      },
                    ),
                    onFocusChange: (hasFocus) async {

                    },
                  ),
                ),
              ],)
            ),
          ),
          // UVOZ PODATAKA END
          
          // BEGIN IZVOZ PODATAKA UI
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Izvoz podataka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),

                
                InkWell(
                  onTap: () async {
                    var result = await _displayInputDialog('Csv delimiter simbol', '', 'Simbol', false, _settings!.csvDelimiterSimbolExport, context);
                    if(result != null) {
                      await _updateCsvExportSimbol(result);
                    }
                  },
                  child: const IgnorePointer(
                    ignoring: true,
                    child: ExpansionTile(
                      trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                      title: Text('Csv delimiter simbol'),
                      children: <Widget>[
                      ],
                    ),
                  )
                ),

                
                ExpansionTile(
                  title: const Text('Odaberite stupce za izvoz'),
                  children: <Widget>[
                    for(var i=0; i<poljaZaExportCheckboxItems.length; i++)
                      CheckboxListTile(
                        checkColor: ColorPalette.success,
                        title: Text(poljaZaExportCheckboxItems[i].label!),
                        value: poljaZaExportCheckboxItems[i].isChecked,
                        onChanged: (value) async {
                          setState(() {
                            poljaZaExportCheckboxItems[i].isChecked = !poljaZaExportCheckboxItems[i].isChecked!;
                          });
                          await _updatePoljaZaExport();
                        },
                      )
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Text('Izvezi datoteke kao odvojene'),
                  ),
                  CupertinoSwitch(value: _settings == null || _settings!.izveziKaoOdvojeneDatoteke! == 0 ? false : true, onChanged: (value) async {
                      await _updateIzveziKaoOdvojeneDatoteke(value);
                  })
                ],),
              ],)
            ),
          )
          // END IZVOZ PODATAKA UI
          
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

  
  // PRETRAGA BEGIN
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

  // PRETRAGA END


  // SKENIRANJE BEGIN
  _updateTrimLeadingZeros(bool value) async {
    _settings!.trimLeadingZeros  = value ? 1 : 0;
    await _appSettingsService.update(_settings!.id!, _settings!);
    await _fetchAppSettings();
  }
  // SKENIRANJE END


  // UVOZ PODATAKA BEGIN
  _updateObrisiArtiklePrilikomImporta(bool value) async {
    _settings!.obrisiArtiklePrilikomUvoza = value ? 1 : 0;
    _appSettingsService.update(_settings!.id!, _settings!);
    await _fetchAppSettings();
  }
  // UVOZ PODATAKA END

  // IZVOZ PODATAKA BEGIN
  _updateCsvExportSimbol(result) async {
    _settings!.csvDelimiterSimbolExport = result;
    _appSettingsService.update(_settings!.id!, _settings!);
  }

  _updatePoljaZaExport() async {
    String result = poljaZaExportCheckboxItems.where((element) => element.isChecked!).map((e) => e.label!).toList().join(',');
    setState(() {
      _settings!.exportDataFields = result;
    });
    await _appSettingsService.update(_settings!.id!, _settings!);
  }

  _updateIzveziKaoOdvojeneDatoteke(bool value) async {
    setState(() {
      _settings!.izveziKaoOdvojeneDatoteke = value ? 1 : 0;
    });
    await _appSettingsService.update(_settings!.id!, _settings!);
  }
  // IZVOZ PODATAKA END
}




class CheckboxListItem {
  String? label;
  bool? isChecked = false;

  CheckboxListItem({ this.label, this.isChecked });
}