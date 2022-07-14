import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/common/snackbar.service.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';
import 'package:collection/collection.dart';

class AddEditDodaniArtikl extends StatefulWidget {
  final ListItem? dodaniArtikl;
  final Lista? lista;
  final Function? onAddDodaniArtikl, onUpdateDodaniArtikl;
  const AddEditDodaniArtikl({ Key? key, this.dodaniArtikl, this.onAddDodaniArtikl, this.onUpdateDodaniArtikl, this.lista }) : super(key: key);

  @override
  _AddEditDodaniArtiklState createState() => _AddEditDodaniArtiklState();
}

class _AddEditDodaniArtiklState extends State<AddEditDodaniArtikl> {
  AppSettings? _settings;
  final AppSettingsService _appSettingsService = AppSettingsService();
  final ArtikliService _artikliService = ArtikliService();
  bool isEdit = false;
  bool fetchingSuggestions = false;
  List<Artikl> suggestions = [];
  Artikl? selectedArtikl;
  String? _scannedBarcode;
  String inputType = 'scanner';


  final TextEditingController dodajArtiklTypeAheadController = TextEditingController();
  final dodajArtiklTypeAheadControllerState = GlobalKey<FormFieldState>();
  final FocusNode artiklTypeAheadFocusNode = FocusNode();
  final TextEditingController kolicinaController = TextEditingController();
  final FocusNode kolicinaFocusNode = FocusNode();
  final TextEditingController mjernaJedinicaController = TextEditingController();
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController nazivController = TextEditingController();
  final TextEditingController kodController = TextEditingController();
  final TextEditingController cijenaController = TextEditingController();
  final TextEditingController napomenaController = TextEditingController();
  final TextEditingController predefiniranaKolicinaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  final TextEditingController scannerInputController = TextEditingController();
  final FocusNode scannerInputFocusNode = FocusNode();
  
  
  @override
  void initState() {
    super.initState();



    isEdit = widget.dodaniArtikl != null;

    Future.delayed(Duration.zero, () async {
        var artikli = await _artikliService.fetchArtikli();
        var settings = await _appSettingsService.getSettings();

        setState(() {
          suggestions = artikli;
          _settings = settings;
          inputType = _settings!.defaultSearchInputMethod!;
        });
      });


    if(isEdit) {
      barkodController.text = widget.dodaniArtikl!.barkod!;
      nazivController.text  = widget.dodaniArtikl!.naziv!;
      kodController.text    = widget.dodaniArtikl!.kod!;
      cijenaController.text = widget.dodaniArtikl!.cijena!.toString();
      kolicinaController.text    = widget.dodaniArtikl!.kolicina!.toString();
      mjernaJedinicaController.text = widget.dodaniArtikl!.jedinicaMjere!;
      
      kolicinaController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: kolicinaController.text.length,
      );
    }
    
    if(inputType == 'keyboard') {
      artiklTypeAheadFocusNode.requestFocus();
    }
    else if(inputType == 'scanner') {
      scannerInputFocusNode.requestFocus();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: MainAppBar.buildAppBar(widget.lista != null ? widget.lista!.naziv! : '', 'Dodavanje artikla', context),
      appBar: buildSearchAppBar(widget.lista != null ? widget.lista!.naziv! : '', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
    );
  }
  
  _buildBody() {
      return StatefulBuilder(builder: (context, setState) {
        return DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
            image: AssetImage(ColorPalette.backgroundImagePath),
            fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
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
                    if(!isEdit && inputType == 'scanner') TextFormField(
                        onEditingComplete: () async {
                          String textFieldValue = scannerInputController.text;
                          selectedArtikl = suggestions.firstWhereOrNull((x) => x.naziv!.toLowerCase().contains(textFieldValue.toLowerCase()) || x.barkod!.toLowerCase().contains(textFieldValue.toLowerCase()));
                          if(selectedArtikl != null) {
                            barkodController.text = selectedArtikl!.barkod!;
                            nazivController.text  = selectedArtikl!.naziv!;
                            kodController.text    = selectedArtikl!.kod!;
                            cijenaController.text = selectedArtikl!.cijena!.toString();
                            kolicinaController.text    = '0';
                            mjernaJedinicaController.text = selectedArtikl!.jedinicaMjere!;
                            dodajArtiklTypeAheadController.text = selectedArtikl!.naziv!;
          
                            kolicinaFocusNode.requestFocus();
                            kolicinaController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: kolicinaController.text.length,
                            );
                          }
                        },
                        showCursor: true,
                        controller: scannerInputController,
                        focusNode: scannerInputFocusNode,
                        decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Dodaj artikl',
                        floatingLabelStyle:
                            TextStyle(color: ColorPalette.primary),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette.primary,
                              width: 2.0),
                        ),
                      ),
                      onTap: () {
                      }
                    ),
                      if(!isEdit && inputType == 'keyboard') TypeAheadFormField<Artikl?>(
                        key: dodajArtiklTypeAheadControllerState,
                        textFieldConfiguration: TextFieldConfiguration(
                          // autofocus: isEdit ? true : false,
                          focusNode: artiklTypeAheadFocusNode,
                          controller: dodajArtiklTypeAheadController,
                          cursorColor: ColorPalette.primary,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Dodaj artikl',
                            floatingLabelStyle:
                                TextStyle(color: ColorPalette.primary),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorPalette.primary,
                                  width: 2.0),
                            ),
                          ),
                        ),
                        noItemsFoundBuilder: (context) => Center(
                          child: Text(fetchingSuggestions ? 'Učitavanje...' : 'Nema pronađenih artikala', style: const TextStyle(fontSize: 18),),
                        ),
                        suggestionsCallback: _fetchAritkliSuggestions, 
                        itemBuilder: (context, Artikl? suggestion) {
                          return ListTile(
                            title: Text(suggestion!.naziv!),
                          );
                        }, 
                        onSuggestionSelected: (Artikl? suggestion) {
                          selectedArtikl = suggestion;
                          barkodController.text = suggestion!.barkod!;
                          nazivController.text  = suggestion.naziv!;
                          kodController.text    = suggestion.kod!;
                          cijenaController.text = suggestion.cijena!.toString();
                          kolicinaController.text    = '0';
                          mjernaJedinicaController.text = suggestion.jedinicaMjere!;
                          dodajArtiklTypeAheadController.text = suggestion.naziv!;
        
                          kolicinaFocusNode.requestFocus();
                          kolicinaController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: kolicinaController.text.length,
                          );
                        // widget.onAddDodaniArtikl!(suggestion);
                        }
                      ),
                    TextFormField(
                      autofocus: isEdit ? true : false,
                      focusNode: kolicinaFocusNode,
                      keyboardType: TextInputType.number,
                      controller: kolicinaController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Količina',
                        floatingLabelStyle:
                            TextStyle(color: ColorPalette.primary),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette.primary,
                              width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          kolicinaFocusNode.requestFocus();
                          return "Kolicina je obavezno polje!";
                        }
                        else if(num.tryParse(value) == null){
                          kolicinaFocusNode.requestFocus();
                          return 'Unesite brojčanu vrijednost!';
                        }
                        else if(num.tryParse(value)! < 1) {
                          kolicinaFocusNode.requestFocus();
                          return 'Količina mora biti veća od 0.';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      controller: barkodController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Barkod',
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
                          return 'Unesite barkod';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      controller: nazivController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Naziv',
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
                    TextFormField(
                      controller: kodController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Kod',
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
                          return 'Unesite kod';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cijenaController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Cijena',
                        floatingLabelStyle:
                            TextStyle(color: ColorPalette.primary),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorPalette.primary,
                              width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Cijena je obavezno polje!";
                        }
                        else if(num.tryParse(value) == null){
                          return 'Unesite brojčanu vrijednost!';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      // showCursor: true,
                      // readOnly: true,
                      // enabled: false,
                      controller: mjernaJedinicaController,
                      decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Mjerna jedinica',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    onTap: () {
                    }
                  ),
                    TextFormField(
                      showCursor: true,
                      controller: napomenaController,
                      decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Napomena',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    onTap: () {
                    }
                  ),
                  ],
                )),
              ),
            ),
            ],),
          )
          ),
        );
    });
  }

  Future<List<Artikl?>> _fetchAritkliSuggestions(String textFieldValue) {
    fetchingSuggestions = true;
    return Future.delayed(Duration.zero, () async {
    if(textFieldValue.isNotEmpty) {
      fetchingSuggestions = false;
      return suggestions.where((x) => x.naziv!.toLowerCase().contains(textFieldValue.toLowerCase()) || x.barkod!.toLowerCase().contains(textFieldValue.toLowerCase())).toList();
    }
    else {
      fetchingSuggestions = false;
      return [];
    }
    });
  }
  
  AppBar buildSearchAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        Tooltip(
          message: 'Pretraži',
          child: IconButton(
            icon: Icon(inputType == 'scanner' ? Icons.search : Icons.camera_alt),
            onPressed: () async {
              setState(() {
                if(inputType == 'keyboard') {
                  inputType = 'scanner';
                  Future.delayed(const Duration(milliseconds: 1000), () async {
                    artiklTypeAheadFocusNode.requestFocus();
                  });
                }
                else if(inputType == 'scanner') {
                  inputType = 'keyboard';
                  Future.delayed(const Duration(milliseconds: 150), () async {
                    scannerInputFocusNode.requestFocus();
                  });
                }
              });
            }, 
          ),
        ),
        Tooltip(
          message: 'Odustani',
          child: IconButton(
            icon: const Icon(CustomIcons.times),
            onPressed: () async {
              _resetControllers();
              Navigator.pop(context, 'Odustani');
            }, 
          ),
        ),
        Tooltip(
          message: 'Spremi',
          child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if(selectedArtikl == null && widget.dodaniArtikl == null) {
                SnackbarService.show('Artikl nije pronađen u bazi.', context);
                return;
              }

              if (_formKey.currentState!.validate()) {

  
                    var kolicina = num.tryParse(kolicinaController.text);
                    if(kolicina == null) {
                      return;
                    }
  
                    var cijena = num.tryParse(cijenaController.text);
                    if(cijena == null) {
                      return;
                    }
  
                    var listItem = ListItem(
                      id: 0,
                      barkod: barkodController.text,
                      naziv: nazivController.text,
                      kod: kodController.text,
                      cijena: cijena,
                      kolicina: kolicina,
                      nazivArtikla: isEdit ? widget.dodaniArtikl!.nazivArtikla! : selectedArtikl != null ? selectedArtikl!.naziv! : nazivController.text,
                      artiklId: isEdit ? widget.dodaniArtikl!.artiklId : selectedArtikl != null ? selectedArtikl!.id! : 0,
                      listaId: isEdit ? widget.dodaniArtikl!.listaId! : widget.lista!.id!,
                      jedinicaMjere: isEdit ? widget.dodaniArtikl!.jedinicaMjere! : selectedArtikl != null ? selectedArtikl!.jedinicaMjere : mjernaJedinicaController.text
                    );
  
  
                    isEdit ? widget.onUpdateDodaniArtikl!(listItem) : widget.onAddDodaniArtikl!(listItem);
                    // Navigator.of(context).pop();
                    _resetControllers();
              }
            }, 
          ),
        ),
      ],
    );
  }

  _resetControllers() {
      barkodController.text = '';
      nazivController.text  = '';
      kodController.text    = '';
      cijenaController.text = '';
      kolicinaController.text    = '';
      mjernaJedinicaController.text = '';
      scannerInputController.text = '';
      napomenaController.text = '';
      dodajArtiklTypeAheadController.text = '';

          
    if(inputType == 'keyboard') {
      artiklTypeAheadFocusNode.requestFocus();
    }
    else if(inputType == 'scanner') {
      scannerInputFocusNode.requestFocus();
    }
  }

  Future<void> _scanCode() async {
    // String scannedCodeRes;
    // artiklTypeAheadFocusNode.unfocus();
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   scannedCodeRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

    // } on PlatformException {
    //   scannedCodeRes = 'Failed to get platform version.';
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _scannedBarcode = scannedCodeRes;
    //   artiklTypeAheadFocusNode.requestFocus();
    //   dodajArtiklTypeAheadController.text = _scannedBarcode!;
    // });
  }

}