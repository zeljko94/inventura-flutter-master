import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class AddEditDodaniArtikl extends StatefulWidget {
  final ListItem? dodaniArtikl;
  final Lista? lista;
  final Function? onAddDodaniArtikl, onUpdateDodaniArtikl;
  const AddEditDodaniArtikl({ Key? key, this.dodaniArtikl, this.onAddDodaniArtikl, this.onUpdateDodaniArtikl, this.lista }) : super(key: key);

  @override
  _AddEditDodaniArtiklState createState() => _AddEditDodaniArtiklState();
}

class _AddEditDodaniArtiklState extends State<AddEditDodaniArtikl> {
  final ArtikliService _artikliService = ArtikliService();
  bool isEdit = false;
  Artikl? selectedArtikl;
  String? _scannedBarcode;
  String inputType = 'keyboard';


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
  
  
  
  @override
  void initState() {
    super.initState();

    isEdit = widget.dodaniArtikl != null;


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
    artiklTypeAheadFocusNode.requestFocus();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar.buildAppBar(widget.lista != null ? widget.lista!.naziv! : '', 'Dodavanje artikla', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
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
                      isEdit ? SizedBox() : TypeAheadFormField<Artikl?>(
                        key: dodajArtiklTypeAheadControllerState,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: isEdit ? true : false,
                          focusNode: artiklTypeAheadFocusNode,
                          controller: dodajArtiklTypeAheadController,
                          cursorColor: ColorPalette.primary,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: _scanBarcode, icon: const Icon(Icons.camera_alt)),
                            // suffixIcon: Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(onPressed: _scanBarcode, icon: const Icon(CustomIcons.times),),
                            //   ],
                            // ),
                            border: const UnderlineInputBorder(),
                            labelText: 'Dodaj artikl',
                            floatingLabelStyle:
                                const TextStyle(color: ColorPalette.primary),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorPalette.primary,
                                  width: 2.0),
                            ),
                          ),
                        ),
                        noItemsFoundBuilder: (context) => const Center(
                          child: Text('Nema pronađenih artikala', style: TextStyle(fontSize: 18),),
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
                        widget.onAddDodaniArtikl!(suggestion);
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
                          return "Kolicina je obavezno polje!";
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
                      showCursor: true,
                      readOnly: true,
                      enabled: false,
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
                    _resetControllers();
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
                            nazivArtikla: isEdit ? widget.dodaniArtikl!.nazivArtikla : selectedArtikl!.naziv,
                            artiklId: isEdit ? widget.dodaniArtikl!.artiklId : selectedArtikl!.id!,
                            // artikl: isEdit ? widget.dodaniArtikl!.artikl : selectedArtikl,
                            listaId: isEdit ? widget.dodaniArtikl!.listaId! : widget.lista!.id!,
                            jedinicaMjere: isEdit ? widget.dodaniArtikl!.jedinicaMjere! : selectedArtikl!.jedinicaMjere
                          );
        
        
                          widget.onUpdateDodaniArtikl!(listItem);
                          Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Spremi'),
                ),
              ]),
            )
            ],),
          ),
        );
    });
  }

  Future<List<Artikl?>> _fetchAritkliSuggestions(String textFieldValue) {
    return Future.delayed(Duration.zero, () async {
      var artikli = await _artikliService.fetchArtikli();
      return artikli.where((x) => x.naziv!.toLowerCase().contains(textFieldValue.toLowerCase()) || x.barkod!.toLowerCase().contains(textFieldValue.toLowerCase())).toList();
    });
  }
  
  _buildButton() {

  }

  _resetControllers() {}

  Future<void> _scanQrCode() async {
    // String barcodeScanRes;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.QR);
    //   print(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    // if (!mounted) return;

    // setState(() {
    //   _scannedBarcode = barcodeScanRes;
    // });
  }

  Future<void> _scanBarcode() async {
    setState(() {
      inputType = 'scanBarcode';
    });
    // String barcodeScanRes;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    //   print(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });

    Future.delayed(const Duration(seconds: 2), () async {
      setState(() {
        _scannedBarcode = '238668';
      });
      dodajArtiklTypeAheadController.text = _scannedBarcode!;
      artiklTypeAheadFocusNode.requestFocus();
    });
  }

}