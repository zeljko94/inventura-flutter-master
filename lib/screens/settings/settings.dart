import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
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

  String? defaultSearchInputMethod;
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;
  String? csvDelimiterSimbol;


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var settings = await _appSettingsService.getSettings();
      print(settings.toMap());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Default search input method'),
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
                  child: Text('Scanner input mode search by fields'), // barkod, sifra
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
                  child: Text('Keyboard input mode search by fields'), // naziv, barkod, sifra
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
                  child: Text('Number of results per search'), // barkod, sifra
                ),
                CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
                  setState(() {
                    obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
                  });
                })
              ],),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Obriši artikle prilikom uvoza'),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Csv delimiter simbol'),
                ),
                CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
                  setState(() {
                    obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
                  });
                })
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
                  child: const Text('Obriši artikle prilikom importa'),
                ),
                CupertinoSwitch(value: obrisiArtiklePrilikomImportaSwitch, onChanged: (value) {
                  setState(() {
                    obrisiArtiklePrilikomImportaSwitch  = !obrisiArtiklePrilikomImportaSwitch;
                  });
                })
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
        IconButton(icon: const Icon(Icons.cancel), 
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
}