
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/models/mjerna_jedinica.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';
import 'package:inventura_app/services/sqlite/mjerne_jedinice_service.dart';
import 'package:collection/collection.dart';

class AddEditArtiklScreen extends StatefulWidget {
  final Function? onAddArtikl, onUpdateArtikl;
  final Artikl? artikl;
  const AddEditArtiklScreen({ Key? key, this.artikl, this.onAddArtikl, this.onUpdateArtikl }) : super(key: key);

  @override
  _AddEditArtiklScreenState createState() => _AddEditArtiklScreenState();
}

class _AddEditArtiklScreenState extends State<AddEditArtiklScreen> {
  bool isEdit = false;
  final ArtikliService? _sqlLiteHelperService = ArtikliService();


  final TextEditingController barkodController = TextEditingController();
  final TextEditingController nazivController = TextEditingController();
  final TextEditingController jedinicaMjereController = TextEditingController();
  final TextEditingController pdvController = TextEditingController();
  final TextEditingController kodController = TextEditingController();
  final TextEditingController cijenaController = TextEditingController();
  // final TextEditingController kolicinaController = TextEditingController();
  final TextEditingController napomenaController = TextEditingController();
  // final TextEditingController predefiniranaKolicinaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    isEdit = widget.artikl != null;


    Future.delayed(Duration.zero, () async {

      if(isEdit) {
        barkodController.text = widget.artikl!.barkod!;
        nazivController.text  = widget.artikl!.naziv!;
        jedinicaMjereController.text = widget.artikl!.jedinicaMjere!;
        kodController.text    = widget.artikl!.kod!;
        cijenaController.text = widget.artikl!.cijena!.toString();
        napomenaController.text    = widget.artikl!.napomena!;
        pdvController.text    = widget.artikl!.pdv!.toString();
        // predefiniranaKolicinaController.text = widget.artikl!.predefiniranaKolicina!.toString();

        // existingMjernaJedinica = mjd.firstWhereOrNull((element) => element.id == widget.artikl!.mjernaJedinicaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MainAppBar.buildAppBar('Artikli', isEdit ? 'Pregled artikla' : 'Dodaj artikl', context),
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
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
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
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
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
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      controller: jedinicaMjereController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Jedinica mjere',
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
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
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
                      showCursor: false,
                      readOnly: true,
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
                      showCursor: false,
                      readOnly: true,
                      controller: pdvController,
                      decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'PDV',
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
                      showCursor: false,
                      readOnly: true,
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         primary: ColorPalette.primary,
            //         textStyle: const TextStyle(fontSize: 15),
            //       ),
            //       onPressed: () async{
            //         Navigator.pop(context, 'Odustani');
            //         resetControllers();
            //       },
            //       child: const Text('Odustani'),
            //     ),
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         backgroundColor: ColorPalette.primary,
            //         primary: const Color.fromARGB(255, 255, 255, 255),
            //         textStyle: const TextStyle(fontSize: 15),
            //       ),
            //       onPressed: () async {
            //         if (_formKey.currentState!.validate()) {
        
        
            //             var cijena = num.tryParse(cijenaController.text);
            //               if(cijena == null) {
            //                 return;
            //               }
        
            //               var artikl = Artikl(
            //                 id: isEdit ? widget.artikl!.id! : 0,
            //                 barkod: barkodController.text,
            //                 naziv: nazivController.text,
            //                 kod: kodController.text,
            //                 cijena: cijena,
            //                 // kolicina: kolicina,
            //                 // predefiniranaKolicina: 0,
            //                 napomena: napomenaController.text
            //               );
        
            //             if(!isEdit) {
            //               var inserted = await _sqlLiteHelperService!.addArtikl(artikl);
                  
            //               if(inserted > 0) {
            //                 var snackBar = const SnackBar(content: Text("Artikl je uspješno dodan!"));
            //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //                 resetControllers();
            //                 widget.onAddArtikl!();
            //                 Navigator.of(context).pop();
            //               }
            //               else {
            //                 var snackBar = const SnackBar(content: Text("Greška prilikom dodavanja artikla!"));
            //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //               }
            //             }
            //             else {
            //               var updated = await _sqlLiteHelperService!.updateArtikl(widget.artikl!.id!, artikl);
        
            //               if(updated > 0) {
            //                 var snackBar = const SnackBar(content: Text("Artikl je uspješno izmjenjen!"));
            //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //                 widget.onUpdateArtikl!();
            //                 Navigator.of(context).pop();
            //               }
            //               else {
            //                 var snackBar = const SnackBar(content: Text("Greška prilikom izmjene artikla!"));
            //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //               }
            //             }
            //         }
            //       },
            //       child: const Text('Spremi'),
            //     ),
            //   ]),
            // )
            ],),
          ),
        );
    });
  
  }

  _buildButton() {

  }

  void resetControllers() {
    barkodController.clear();
    nazivController.clear();
    kodController.clear();
    cijenaController.clear();
    napomenaController.clear();
    pdvController.clear();
    jedinicaMjereController.clear();
  }
}