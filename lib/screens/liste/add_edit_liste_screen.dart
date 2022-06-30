import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/models/list_item.dart';
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
  final ListeService? _listeService = ListeService();
  final ArtikliService? _artikliService = ArtikliService();
  bool isEdit = false;
  List<Artikl> artikli = [];
  List<ListItem> dodaniArtikli = [];

  // final List<TextEditingController> listItemKolicinaControllers = [];


  final TextEditingController nazivController = TextEditingController();
  final TextEditingController skladisteController = TextEditingController();
  final TextEditingController napomenaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    
    isEdit = widget.lista != null;

    if(isEdit) {
      nazivController.text = widget.lista!.naziv!;
      skladisteController.text = widget.lista!.skladiste!;
      napomenaController.text = widget.lista!.napomena!;
    }

    Future.delayed(Duration.zero, () async {
      var artikliData = await _artikliService!.fetchArtikli();


      setState(() {
        artikli = artikliData;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar.buildAppBar('Edit list', context),
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
                    !isEdit ? "Nova lista" : "Izmjeni listu",
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
                  DropdownButtonFormField<Artikl>(
                    hint: const Text('Odaberite artikl:'),
                    // validator: (value) => value == null ? 'Odaberite mjernu jedinicu' : null,
                    items: artikli.map((Artikl value) {
                      return DropdownMenuItem<Artikl>(
                        value: value,
                        child: Text(value.naziv!),
                      );
                    }).toList(),
                    onChanged: (Artikl? odabraniArtikl) {
                      _dodajArtikl(odabraniArtikl);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, ),
                    child: Column(
                      children: [
                        const Text('Dodani artikli:',),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: dodaniArtikli.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                              child: Card(
                                  child: ListTile(
                                      onTap: () {
                                      },
                                      onLongPress: () async {
                                      },
                                      title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(dodaniArtikli[index].artikl!.naziv!),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        _decrementAmount(dodaniArtikli[index]);
                                                      }, 
                                                      icon: const Icon(Icons.remove)
                                                    ),
                                                    SizedBox(
                                                      child: Text(dodaniArtikli[index].kolicina!.toString())
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        _incrementAmount(dodaniArtikli[index]);
                                                      }, 
                                                      icon: const Icon(Icons.add)
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        _removeDodaniArtikl(dodaniArtikli[index]);
                                                      }, 
                                                      icon: Icon(Icons.cancel, color:  ColorPalette.danger,)
                                                    ),
                                                ],)
                                              ],
                                            ),)),
                            );
                          },
                        ),
                      ],
                    ),
                  )
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

                    // buildLoadingSpinner(context);
                    // try {


                      var lista = Lista(
                        id: isEdit ? widget.lista!.id! : 0,
                        naziv: nazivController.text,
                        skladiste: skladisteController.text,
                        napomena: napomenaController.text
                      );

                      if(!isEdit) {
                        var inserted = await _listeService!.add(lista);
                
                        if(inserted > 0) {
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
                        var updated = await _listeService!.update(widget.lista!.id!, lista);

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
                    // }
                    // catch(exception) {          
                    //   var snackBar = const SnackBar(content: Text("Došlo je do pogreške!"));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //   print("Exception");
                    //   print(exception);
                    // }
                     
                    // await Future.delayed(const Duration(seconds: 1));
                    // removeLoadingSpinner(context);
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
  
  _dodajArtikl(Artikl? odabraniArtikl) {
    var listItem = ListItem(artikl: odabraniArtikl, artiklId: odabraniArtikl!.id, listId: widget.lista != null ? widget.lista!.id : 0, kolicina: 1);
    dodaniArtikli.add(listItem);

    setState(() {
      dodaniArtikli = List.of(dodaniArtikli);
    });
  }

  _buildButton() {
    return FloatingActionButton(
          heroTag: null,
          backgroundColor: ColorPalette.info,
          onPressed: () {
            
          },
          child: const Icon(Icons.camera_alt),
        );
  }

  _resetControllers() {
    nazivController.clear();
    skladisteController.clear();
    napomenaController.clear();
  }

  void _incrementAmount(ListItem? item) {
    setState(() {
      item!.kolicina = item.kolicina! + 1;
    });
  }

  void _decrementAmount(ListItem? item) {
    setState(() {
      item!.kolicina = item.kolicina! - 1;
      if(item.kolicina! < 1) {
      item.kolicina = 0;
      }
    });}

  void _removeDodaniArtikl(ListItem? item) {
    setState(() {
      dodaniArtikli.remove(item);
      dodaniArtikli = List.of(dodaniArtikli);
    });
  }

}