

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/data_import.dart';

class AddEditDataImportScreen extends StatefulWidget {
  final DataImport? dataImport;
  final Function? onAddDataImport, onUpdateDataImport;
  const AddEditDataImportScreen({ Key? key, this.dataImport, this.onAddDataImport, this.onUpdateDataImport }) : super(key: key);

  @override
  State<AddEditDataImportScreen> createState() => _AddEditDataImportScreenState();
}

class _AddEditDataImportScreenState extends State<AddEditDataImportScreen> {
  bool isEdit = false;
  List<PlatformFile> files = [];

  TextEditingController nazivController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    isEdit = widget.dataImport != null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar.buildAppBar(isEdit ? 'Pregled importa': 'New data import', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
    );
  }

  _buildBody() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
          Row(
            children: [
              Icon(
                !isEdit ? Icons.add_box_outlined : Icons.mode_edit_outline,
                color: ColorPalette.primary,
                size: 30.0,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    !isEdit ? "Unos novog importa" : "Pregled importa",
                    style: Theme.of(context).textTheme.headline6,
                  ),
              )
            ],
          ),
          Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: (Column(
                children: [
                  TextFormField(
                    controller: nazivController,
                    cursorColor: ColorPalette.primary,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Naziv uvoza',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unesite naziv';
                      }
                      return null;
                    },
                    onTap: () async {
        
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text('Odaberite dokument za uvoz:'),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(allowMultiple: true, );
                        if (result == null) return;
                        files = result.files;
                        setState((){});
                      },
                    ),
                  ),
                  files.isNotEmpty ? Text('Odabrani dokument: ' + files[0].name) : const SizedBox()
                ],
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: ColorPalette.primary,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () async{
                  Navigator.pop(context, 'Odustani');
                  resetControllers();
                },
                child: const Text('Odustani'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                  primary: const Color.fromARGB(255, 255, 255, 255),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    // buildLoadingSpinner(context);
                    // try {


                      //   var artikl = Artikl(
                      //     id: isEdit ? widget.artikl!.id! : 0,
                      //     barkod: barkodController.text,
                      //     naziv: nazivController.text,
                      //     kod: kodController.text,
                      //     cijena: cijena,
                      //     kolicina: kolicina,
                      //     predefiniranaKolicina: 0,
                      //     napomena: napomenaController.text
                      //   );

                      // if(!isEdit) {
                      //   var inserted = await _sqlLiteHelperService!.addArtikl(artikl);
                
                      //   if(inserted > 0) {
                      //     var snackBar = const SnackBar(content: Text("Artikl je uspješno dodan!"));
                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //     resetControllers();
                      //     widget.onAddArtikl!();
                      //     Navigator.of(context).pop();
                      //   }
                      //   else {
                      //     var snackBar = const SnackBar(content: Text("Greška prilikom dodavanja artikla!"));
                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //   }
                      // }
                      // else {
                      //   var updated = await _sqlLiteHelperService!.updateArtikl(widget.artikl!.id!, artikl);

                      //   if(updated > 0) {
                      //     var snackBar = const SnackBar(content: Text("Artikl je uspješno izmjenjen!"));
                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //     widget.onUpdateArtikl!();
                      //     Navigator.of(context).pop();
                      //   }
                      //   else {
                      //     var snackBar = const SnackBar(content: Text("Greška prilikom izmjene artikla!"));
                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //   }
                      // }
                  }
                },
                child: const Text('Pokreni uvoz'),
              ),
            ]),
          )
          ],),
        );
    });
  }

  _buildButton() {}

  void resetControllers() {}

}


























              // child: Column(
              //   // crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //   const Text('Odaberite način importa:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              //   Row(children: [
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/csv.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('csv');
              //       },),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/text.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('txt');
              //       },),
              //     ),
              //   ],),
              //   Row(children: [
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/postgres.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('postgresql');
                      
              //       }),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/sql-server.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('sql-server');
              //       }),
              //     ),
              //   ],),
              //   Row(children: [
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/excel.jpg', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('xls');
              //       }),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/mysql.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('mysql');
              //       }),
              //     ),
              //   ],),
              //   Row(children: [
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/oracle-rest-api.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('oracle-rest-api');
              //       }),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: InkWell(child: Image.asset('assets/images/sqlite.png', height: 150, width: 150,), onTap: () async {
              //         _redirectToStep2('sqlite');
              //       }),
              //     ),
              //   ],)
              //       ]),