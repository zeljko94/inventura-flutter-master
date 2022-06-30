import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/list_item.dart';

class AddEditDodaniArtikl extends StatefulWidget {
  final ListItem? dodaniArtikl;
  final Function? onAddDodaniArtikl, onUpdateDodaniArtikl;
  const AddEditDodaniArtikl({ Key? key, this.dodaniArtikl, this.onAddDodaniArtikl, this.onUpdateDodaniArtikl }) : super(key: key);

  @override
  _AddEditDodaniArtiklState createState() => _AddEditDodaniArtiklState();
}

class _AddEditDodaniArtiklState extends State<AddEditDodaniArtikl> {
  bool isEdit = false;


  final TextEditingController kolicinaController = TextEditingController();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar.buildAppBar('Edit dodani artikl', context),
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
          // Row(
          //   children: [
          //     Icon(
          //       !isEdit ? Icons.add_box_outlined : Icons.mode_edit_outline,
          //       color: ColorPalette.primary,
          //       size: 30.0,
          //     ),
          //     Container(
          //         margin: const EdgeInsets.only(left: 10),
          //         child: Text(
          //           !isEdit ? "Artikli - novi artikl" : "Artikli - izmjeni artikl",
          //           style: Theme.of(context).textTheme.headline6,
          //         ),
          //     )
          //   ],
          // ),
          Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: (Column(
                children: [
                  TextFormField(
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

                      var cijena = num.tryParse(cijenaController.text);
                        if(cijena == null) {
                          return;
                        }
                        var kolicina = num.tryParse(kolicinaController.text);
                        if(kolicina == null) {
                          return;
                        }

                        var listItem = ListItem(
                          id: 0,
                          barkod: barkodController.text,
                          naziv: nazivController.text,
                          kod: kodController.text,
                          cijena: cijena,
                          kolicina: kolicina,
                          artiklId: widget.dodaniArtikl!.artiklId,
                          artikl: widget.dodaniArtikl!.artikl
                        );


                        // if(updated > 0) {
                          // var snackBar = const SnackBar(content: Text("Artikl je uspješno izmjenjen!"));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          widget.onUpdateDodaniArtikl!(listItem);
                          Navigator.of(context).pop();
                        // }
                        // else {
                        //   var snackBar = const SnackBar(content: Text("Greška prilikom izmjene artikla!"));
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // }
                      // }
                  }
                },
                child: const Text('Spremi'),
              ),
            ]),
          )
          ],),
        );
    });
  }
  
  _buildButton() {

  }

  _resetControllers() {}
}