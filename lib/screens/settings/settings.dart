import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool obrisiArtiklePrilikomImportaSwitch = false;
  TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();


  @override
  void initState() {
    super.initState();

    linkZaUvozPodatakaSaRestApijaController.text = "http://192.168.5.200:8888/ords/opus/artikl/barkodovi";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar.buildAppBar('Postavke', '', context),
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
                  child: Text('Obriši artikle prilikom importa'),
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
                  child: Text('Obriši artikle prilikom importa'),
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
                leading: Icon(Icons.search),
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
                  child: Text('Obriši artikle prilikom importa'),
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
                  child: Text('Obriši artikle prilikom importa'),
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
                leading: Icon(Icons.download),
                title: Text('Uvoz podataka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
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
}