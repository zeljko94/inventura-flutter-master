
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/data_export_service.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';

class ExportDataScreen extends StatefulWidget {
  final List<Lista>? liste;
  const ExportDataScreen({Key? key, this.liste }) : super(key: key);

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  AppSettings? _settings;
  final AppSettingsService _appSettingsService = AppSettingsService();
  final DataExportService _dataExportService = DataExportService();

  bool isLoading = false;
  List<String>  vrsteIzvoza = ['csv', 'excel', 'rest api'];
  String? selectedVrstaIzvoza;
  bool izveziKaoOdvojeneDatoteke = true;

  TextEditingController filenameController = TextEditingController();
  TextEditingController restApiLinkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
      var settings = await _appSettingsService.getSettings();

      setState(() {
        _settings = settings;
        izveziKaoOdvojeneDatoteke = _settings!.izveziKaoOdvojeneDatoteke == 1 ? true : false;
      });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Odabrane liste: ', style: TextStyle(fontSize: 16),),
                    for(var i=0; i<widget.liste!.length; i++) 
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(widget.liste![i].naziv!)
                      )
                    ,
                    DropdownButtonFormField<String>(
                      value: selectedVrstaIzvoza,
                      hint: const Text('Odaberite vrstu izvoza:', textAlign: TextAlign.start,),
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
                    if(widget.liste != null && widget.liste!.length > 1) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                          checkColor: ColorPalette.success,
                          title: const Text('Izvezi kao odvojene datoteke?'),
                          value: izveziKaoOdvojeneDatoteke,
                          onChanged: (value) async {
                            setState(() {
                              izveziKaoOdvojeneDatoteke = !izveziKaoOdvojeneDatoteke;
                            });
                          },
                        ),
                    )
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
      
                      _setIsLoading(true);
                      if(selectedVrstaIzvoza == 'csv') {
                        if(izveziKaoOdvojeneDatoteke) {
                          for(var i=0; i<widget.liste!.length; i++) {
                            await _pokreniIzvozCsv(widget.liste![i].items!, widget.liste![i].naziv!.replaceAll(' ', '') + '_' + DateTime.now().millisecondsSinceEpoch.toString());
                          }
                        }
                        else {
                          List<ListItem> listItems = [];
                          String naziv = '';
                          for(var i=0; i<widget.liste!.length; i++) {
                            listItems.addAll(widget.liste![i].items!);
                            naziv += widget.liste![i].naziv! + '_';
                          }
                          await _pokreniIzvozCsv(listItems, naziv.replaceAll(' ', '') + DateTime.now().millisecondsSinceEpoch.toString());
                        }
                      }
                      else if(selectedVrstaIzvoza == 'excel') {
                        if(izveziKaoOdvojeneDatoteke){
                          for(var i=0; i<widget.liste!.length; i++) {
                            await _pokreniIzvozExcel(widget.liste![i].items!, widget.liste![i].naziv!.replaceAll(' ', '') + '_' + DateTime.now().millisecondsSinceEpoch.toString());
                          }
                        }
                        else {
                          List<ListItem> listItems = [];
                          String naziv = '';
                          for(var i=0; i<widget.liste!.length; i++) {
                            listItems.addAll(widget.liste![i].items!);
                            naziv += widget.liste![i].naziv! + '_';
                          }
                          await _pokreniIzvozExcel(listItems, naziv.replaceAll(' ', '') + '_' + DateTime.now().millisecondsSinceEpoch.toString());
                        }
                      }
                      // else if(selectedVrstaIzvoza == 'rest api') {
                      // }
                      _setIsLoading(false);
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
    var isSuccess = await _dataExportService.exportCsv(items, filename, context);
    if(isSuccess) {
        var snackBar = const SnackBar(content: Text("Uspješan izvoz podataka!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      var snackBar = const SnackBar(content: Text("Greška prilikom izvoza liste!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  _pokreniIzvozExcel(List<ListItem> items, String filename) async {
    var isSuccess = await _dataExportService.exportExcel(items, filename);
    if(isSuccess) {
        var snackBar = const SnackBar(content: Text("Uspješan izvoz podataka!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      var snackBar = const SnackBar(content: Text("Greška prilikom izvoza liste!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}