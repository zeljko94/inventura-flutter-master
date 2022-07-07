
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/data_export_service.dart';
import 'package:open_file/open_file.dart';

class ExportDataScreen extends StatefulWidget {
  final Lista? lista;
  const ExportDataScreen({Key? key, this.lista }) : super(key: key);

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  final DataExportService _dataExportService = DataExportService();

  bool isLoading = false;
  List<String>  vrsteIzvoza = ['csv', 'excel', 'rest api'];
  String? selectedVrstaIzvoza;

  TextEditingController filenameController = TextEditingController();
  TextEditingController restApiLinkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar.buildAppBar('Izvoz podataka', '', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
    );
  }
    _buildBody() {
    return StatefulBuilder(builder: (context, setState) {
      return !isLoading ? DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
          image: AssetImage(ColorPalette.backgroundImagePath),
          fit: BoxFit.cover),
      ),
        child: Padding(
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
                      value: selectedVrstaIzvoza,
                      hint: const Text('Odaberite vrstu izvoza:'),
                      validator: (value) => value == null ? 'Odaberite vrstu izvoza' : null,
                      decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Vrsta izvoza',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                      items: vrsteIzvoza.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (vrstaUvoza) {
                        _setSelectedVrstaUvoza(vrstaUvoza!);
                      },
                    ),
                  ],
                )
                ),
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
      
                      if(selectedVrstaIzvoza == 'csv') {
                        await _pokreniIzvozCsv(widget.lista!.items!, widget.lista!.naziv! + '_' + DateTime.now().millisecondsSinceEpoch.toString());
                      }
                      else if(selectedVrstaIzvoza == 'excel') {
                        await _pokreniIzvozExcel(widget.lista!.items!, widget.lista!.naziv! + '_' + DateTime.now().millisecondsSinceEpoch.toString());
                      }
                      else if(selectedVrstaIzvoza == 'rest api') {
                      }
                    }
                  },
                  child: const Text('Pokreni izvoz'),
                ),
              ]),
            )
            ],),
          ),
      ) : const Center(child: CircularProgressIndicator());
    });
  }

  
  _buildButton() {}
  
  _setSelectedVrstaUvoza(String vrstaUvoza) {
    setState(() {
      selectedVrstaIzvoza = vrstaUvoza;
    });
  }

  _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
  
  _pokreniIzvozCsv(List<ListItem> items, String filename) async {
    _setIsLoading(true);
    var isSuccess = await _dataExportService.exportCsv(items, filename);
    if(isSuccess) {
        var snackBar = const SnackBar(content: Text("Uspješan izvoz podataka!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      var snackBar = const SnackBar(content: Text("Greška prilikom izvoza liste!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    _setIsLoading(false);
  }
  _pokreniIzvozExcel(List<ListItem> items, String filename) async {
    // _setIsLoading(true);
    // var isSuccess = await _dataExportService.exportExcel(items, filename);
    // if(isSuccess) {
    //     var snackBar = const SnackBar(content: Text("Uspješan izvoz podataka!"));
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
    // else {
    //   var snackBar = const SnackBar(content: Text("Greška prilikom izvoza liste!"));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
    // _setIsLoading(false);
  }
}