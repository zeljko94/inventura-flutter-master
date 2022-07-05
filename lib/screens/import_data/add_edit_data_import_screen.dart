

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/loading_spinner.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/data_import.dart';
import 'package:inventura_app/services/data_import_service.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class AddEditDataImportScreen extends StatefulWidget {
  final DataImport? dataImport;
  final Function? onAddDataImport, onUpdateDataImport;
  const AddEditDataImportScreen({ Key? key, this.dataImport, this.onAddDataImport, this.onUpdateDataImport }) : super(key: key);

  @override
  State<AddEditDataImportScreen> createState() => _AddEditDataImportScreenState();
}

class _AddEditDataImportScreenState extends State<AddEditDataImportScreen> {
  final DataImportService? _dataImportService = DataImportService();
  final ArtikliService? _artikliService = ArtikliService();
  bool isLoading = false;
  List<PlatformFile> files = [];
  List<String> vrsteUvoza = ['csv', 'rest api'];
  String? selectedVrstaUvoza;

  TextEditingController nazivController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar.buildAppBar('Novi uvoz podataka', 'Uvoz artikala', context),
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
          Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: (Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedVrstaUvoza,
                    hint: const Text('Odaberite vrstu uvoza:'),
                    validator: (value) => value == null ? 'Odaberite vrstu uvoza' : null,
                    items: vrsteUvoza.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (vrstaUvoza) {
                      _setSelectedVrstaUvoza(vrstaUvoza!);
                    },
                  ),
                  selectedVrstaUvoza == 'csv' ? Padding(
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
                  ) : const SizedBox(),
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

                    if(selectedVrstaUvoza == 'csv') {
                      if(files.isNotEmpty) {
                        buildLoadingSpinner('Učitavanje...', context);
                        var artikli = await _dataImportService!.getArtikliFromCsv(files.first);
                        await _artikliService!.deleteAll();
                        await _artikliService!.bulkInsert(artikli!);
                        removeLoadingSpinner(context);
                      }
                      else {
                        var snackBar = const SnackBar(content: Text("Odaberite datoteku za uvoz!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    else if(selectedVrstaUvoza == 'rest api') {
                      buildLoadingSpinner('Učitavanje...', context);
                      await _dataImportService!.getArtikli(context);
                      removeLoadingSpinner(context);
                    }
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


  _setIsLoading(stateIsLoading) {
    setState(() {
      isLoading = stateIsLoading;
    });
  }

  _setSelectedVrstaUvoza(String vrstaUvoza) {
    setState(() {
      selectedVrstaUvoza = vrstaUvoza;
    });
  }

}


