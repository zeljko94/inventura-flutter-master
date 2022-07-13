import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/helpers/datetime_helper_service.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';
import 'package:inventura_app/services/sqlite/liste_service.dart';

class AddEditListaScreen extends StatefulWidget {
  final Lista? lista;
  final Function? onAddLista, onUpdateLista;
  const AddEditListaScreen({ Key? key, this.lista, this.onAddLista, this.onUpdateLista }) : super(key: key);

  @override
  _AddEditListaScreenState createState() => _AddEditListaScreenState();
}

class _AddEditListaScreenState extends State<AddEditListaScreen> {
  final ListeService   _listeService   = ListeService();
  final ArtikliService _artikliService = ArtikliService();

  bool isEdit = false;

  final TextEditingController nazivController = TextEditingController();
  final TextEditingController skladisteController = TextEditingController();
  final TextEditingController napomenaController = TextEditingController();
  final TextEditingController datumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    isEdit = widget.lista != null;

    if(isEdit) {
      nazivController.text = widget.lista!.naziv!;
      skladisteController.text = widget.lista!.skladiste!;
      napomenaController.text = widget.lista!.napomena!;
      datumController.text = DateTImeHelperService.formatZaPrikaz.format(DateTime.parse(widget.lista!.datumKreiranja!));
    }

    Future.delayed(Duration.zero, () async {
      // var artikliData = await _artikliService.fetchArtikli();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar.buildAppBar('Liste', isEdit ? 'Pregled liste' : 'Dodaj listu', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
    );
  
  }

    
  _buildBody() {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
              image: const AssetImage(ColorPalette.backgroundImagePath),
              fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
        child: StatefulBuilder(builder: (context, setState) {
          return Padding(
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
                    TextFormField(
                      controller: nazivController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Naziv liste',
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
                          return 'Unesite naziv liste';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      controller: skladisteController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Skladište',
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
                          return 'Unesite naziv skladišta';
                        }
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    TextFormField(
                      controller: napomenaController,
                      cursorColor: ColorPalette.primary,
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
                      validator: (value) {
                        return null;
                      },
                      onTap: () async {
          
                      },
                    ),
                    if(isEdit) TextFormField(
                      readOnly: true,
                      enabled: false,
                      controller: datumController,
                      cursorColor: ColorPalette.primary,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Datum kreiranja',
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
                    // DropdownButtonFormField<Artikl>(
                    //   hint: const Text('Odaberite artikl:'),
                    //   // validator: (value) => value == null ? 'Odaberite mjernu jedinicu' : null,
                    //   items: artikli.map((Artikl value) {
                    //     return DropdownMenuItem<Artikl>(
                    //       value: value,
                    //       child: Text(value.naziv!),
                    //     );
                    //   }).toList(),
                    //   onChanged: (Artikl? odabraniArtikl) {
                    //     _dodajArtikl(odabraniArtikl);
                    //   },
                    // ),
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


                        var dateFormat = DateTImeHelperService.formatDbInsert;
                        var lista = Lista(
                          id: isEdit ? widget.lista!.id! : 0,
                          naziv: nazivController.text,
                          skladiste: skladisteController.text,
                          napomena: napomenaController.text,
                          datumKreiranja: dateFormat.format(DateTime.now()),
                          items: isEdit ? widget.lista!.items! : []
                        );

                        if(!isEdit) {
                          var inserted = await _listeService.add(lista);
                  
                          if(inserted != null && inserted > 0) {
                            var snackBar = const SnackBar(content: Text("Lista je uspješno dodana!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            _resetControllers();
                            widget.onAddLista!();
                            Navigator.of(context).pop();
                          }
                          else {
                            var snackBar = const SnackBar(content: Text("Greška prilikom dodavanja liste!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                        else {
                          var updated = await _listeService.update(widget.lista!.id!, lista);

                          if(updated > 0) {
                            var snackBar = const SnackBar(content: Text("Lista je uspješno izmjenjena!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            widget.onUpdateLista!();
                            Navigator.of(context).pop();
                          }
                          else {
                            var snackBar = const SnackBar(content: Text("Greška prilikom izmjene liste!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                    }
                  },
                  child: const Text('Spremi'),
                ),
              ]),
            )
            ],),
          );
    }),
    )
        ],
      );
  }

  _resetControllers() {}

  _scanBarcode() {}
}