import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/screens/dashboard.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();

  bool obrisiArtiklePrilikomImportaSwitch = false;
  bool trimLeadingZerosSwitch = false;
  TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();

  String? defaultSearchInputMethod = 'keyboard';
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;

  int? numberOfResultsPerSearch;
  String? csvDelimiterSimbol;

  
  final _formKey = GlobalKey<FormState>();
  TextEditingController dialogInputTextController = TextEditingController();


  List<String> vrsteUnosaPretrazivanja = ['keyboard', 'scan'];
  List<String> mogucaPoljaZaPretrazivanje = ['barkod', 'sifra', 'naziv'];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var settings = await _appSettingsService.getSettings();
      
      setState(() {
        numberOfResultsPerSearch = settings.numberOfResultsPerSearch;
        obrisiArtiklePrilikomImportaSwitch = settings.obrisiArtiklePrilikomUvoza! > 0;
        defaultSearchInputMethod = settings.defaultSearchInputMethod;
        scannerInputModeSearchByFields = settings.scannerInputModeSearchByFields;
        keyboardInputModeSearchByFields = settings.keyboardInputModeSearchByFields;
        numberOfResultsPerSearch = settings.numberOfResultsPerSearch;
        csvDelimiterSimbol = settings.csvDelimiterSimbol;
      });
    });

    linkZaUvozPodatakaSaRestApijaController.text = "http://192.168.5.200:8888/ords/opus/artikl/barkodovi";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar('Postavke', context),
        body: _buildBody(),
        drawer: MenuDrawer.getDrawer());
  }
  
  _buildBody() {
    return SingleChildScrollView(child: Column(
      children: [
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(0),
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
                ),),
                InkWell(
                  onTap: () async {
                  },
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pretraga skeniranjem pretražuje po poljima'), // barkod, sifra
                      ),
                        const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText,)
                    ],),
                  ),
                  InkWell(
                    onTap: () async {},
                    child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Pretraga unosom pretražuje po poljima'), // naziv, barkod, sifra
                        ),
                        const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText,)
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () async {
                    var valueFromDialog = await _displayTextInputDialog('Broj rezultata po pretraživanju', 'Unesite broj artikala koji će se prikazivati prilikom pretraživanja', 'Broj rezultata po pretraživanju', true, numberOfResultsPerSearch, context);
                    if(valueFromDialog != null) {
                      setState(() {
                        numberOfResultsPerSearch = int.parse(valueFromDialog.toString());
                      });
                    }
                  },
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Broj rezultata po pretraživanju'),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText,)
                      ],
                    ),
                ),
            ],)
          ),
        ),

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
                  padding: EdgeInsets.all(8.0),
                  child: Text('Trim leading zeros'),
                ),
                CupertinoSwitch(value: trimLeadingZerosSwitch, onChanged: (value) {
                  setState(() {
                    trimLeadingZerosSwitch  = !trimLeadingZerosSwitch;
                  });
                })
              ],),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //   const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Text('Obriši artikle prilikom importa'),
              //   ),
              //   CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
              //     setState(() {
              //       obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
              //     });
              //   })
              // ],),
            ],)
          ),
        ),
        
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
                  padding: EdgeInsets.all(8.0),
                  child: Text('Obriši artikle prilikom uvoza'),
                ),
                CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
                  setState(() {
                    obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
                  });
                })
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Csv delimiter simbol'),
                ),
                const Icon(Icons.arrow_forward_ios, color: ColorPalette.secondaryText)
              ],),
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
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(children: [
              const ListTile(
                leading: Icon(Icons.upload),
                title: Text('Izvoz podataka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                // subtitle: Text('Podnaslov'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ],),
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
        )
      ],
    ),);
  }

  AppBar _buildAppbar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.check),
        onPressed: () async {
          await _onSaveSettings();
        }),
        IconButton(icon: const Icon(CustomIcons.times), 
        onPressed: () async {
          await _onCancelSettings();
        }),
      ],
    );
  }


  _onSaveSettings() {

  }

  _onCancelSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/dashboard'),
        builder: (context) => const DashboardScreen(title: 'Dashboard',),
      ),
    );
  }


  Future<dynamic> _displayTextInputDialog(String title, String message, String inputLabel, bool isNumberOnly, dynamic value, BuildContext context) async {
    dialogInputTextController.text = value.toString();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: 
            Column(
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
                  child: const Text('cancel')),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, dialogInputTextController.text);
                      dialogInputTextController.clear();
                    }
                  },
                  child: const Text('confirm')
                ),
            ],
        );
      });
  }

  

  Future<dynamic> _displayZadanaMetodaUnosaPretrazivanja(String title, BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: 
                Column(
                  children: [
                  // Text(message),
                    Form(
                      // key: _formKey,
                      child: DropdownButtonFormField<String>(
                        value: defaultSearchInputMethod,
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
                            defaultSearchInputMethod = vrstaUnosa;
                          });
                        },
                      ),
                    ),
                  ],
                ),  
            );
          });
      }

  Future<dynamic> _displayDialog(String title, BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: 
                Column(
                  children: [
                  // Text(message),
                    Form(
                      // key: _formKey,
                      child: DropdownButtonFormField<String>(
                        value: defaultSearchInputMethod,
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
                            defaultSearchInputMethod = vrstaUnosa;
                          });
                        },
                      ),
                    ),
                  ],
                ),  
            );
          });
      }

}