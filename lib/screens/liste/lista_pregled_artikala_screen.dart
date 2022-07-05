
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/screens/liste/add_edit_dodani_artikl.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';
import 'package:inventura_app/services/sqlite/liste_service.dart';
import 'package:collection/collection.dart';

class ListaPregledArtikalaScreen extends StatefulWidget {
  final Lista? lista;
  final Function? onAddLista, onUpdateLista;
  const ListaPregledArtikalaScreen({ Key? key, this.lista, this.onAddLista, this.onUpdateLista }) : super(key: key);

  @override
  _ListaPregledArtikalaScreen createState() => _ListaPregledArtikalaScreen();
}

class _ListaPregledArtikalaScreen extends State<ListaPregledArtikalaScreen> {
  bool isEdit = false;
  bool isLoading = false;
  final ListeService? _listeService = ListeService();
  final ArtikliService? _artikliService = ArtikliService();

  int totalBrojArtikala = 0;
  num totalCijena = 0;
  num totalKolicina = 0;

  List<Artikl> artikli = [];
  List<ListItem> dodaniArtikli = [];


  final _formKey = GlobalKey<FormState>();
  


  @override
  void initState() {
    super.initState();
    
    isEdit = widget.lista != null;

    if(isEdit) {
      
    }

    isLoading = true;
    Future.delayed(Duration.zero, () async {
      var artikliData = await _artikliService!.fetchArtikli();

      _updateTotalValues();
      setState(() {
        artikli = artikliData;
        dodaniArtikli = List.of(widget.lista != null ? widget.lista!.items! : []);
        isLoading = false;
      });
    });
  }

  _updateTotalValues() {
    totalBrojArtikala = 0;
    totalCijena = 0;
    totalKolicina = 0;
    setState(() {
        widget.lista!.items!.forEach((element) { 
          totalBrojArtikala += element.kolicina as int;
          totalCijena += (element.artikl!.cijena! * element.kolicina!);
          totalKolicina += element.kolicina!;
        });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar.buildAppBar(widget.lista!.naziv!, 'Pregled artikala', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,//set your height here
          width: double.maxFinite, //set your width here
          decoration: const BoxDecoration(
            color: ColorPalette.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('#' + totalBrojArtikala.toString(), style: TextStyle(fontSize: 16, color: ColorPalette.basic[50], fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(totalCijena.toString() + ' KM', style: TextStyle(fontSize: 16,  color: ColorPalette.basic[50], fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(totalKolicina.toString(), style: TextStyle(fontSize: 16,  color: ColorPalette.basic[50], fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  _buildBody() {
      return SingleChildScrollView(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 12, ),
                      child: Column(
                        children: [
                          // const Text('Artikli:',),
                          !isLoading && dodaniArtikli.isEmpty ? const Text('Lista nema dodanih artikala.', style: TextStyle(color: ColorPalette.warning),) : const SizedBox(),
                          !isLoading ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: dodaniArtikli.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                                child: Card(
                                    child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              settings: const RouteSettings(name: '/add-edit-dodani-artikl'),
                                              builder: (context) => AddEditDodaniArtikl(
                                                dodaniArtikl: dodaniArtikli[index],
                                                lista: widget.lista,
                                                onAddDodaniArtikl: _dodajArtikl,
                                                onUpdateDodaniArtikl: _updateDodaniArtikl,
                                              ),
                                            ),
                                          );
                                        },
                                        onLongPress: () async {
                                        },
                                        title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('#' + (index + 1).toString()),
                                              Expanded(
                                                child: Padding(padding: EdgeInsets.only(left: 15),
                                                child: Text(dodaniArtikli[index].artikl!.naziv!,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                              Row(  
                                                children: [
                                                  Text(dodaniArtikli[index].kolicina!.toString()),
                                                  IconButton(onPressed: () async { 
                                                    _removeDodaniArtikl(dodaniArtikli[index]);
                                                  }, icon: const Icon(Icons.cancel), color: ColorPalette.danger,)
                                                ],
                                              )
                                            ],
                                          ),)),
                              );
                            },
                          ) : const Center(child: CircularProgressIndicator()),
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


                      await _spremiIzmjene();
                    }
                  },
                  child: const Text('Spremi'),
                ),
              ]),
            )
            ],),
          );
    }),
    );
  }


  _buildButton() {
    return FloatingActionButton(
          heroTag: null,
          backgroundColor: ColorPalette.info,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/add-edit-dodani-artikl'),
                builder: (context) => AddEditDodaniArtikl(
                  lista: widget.lista!,
                  onAddDodaniArtikl: _dodajArtikl,
                  onUpdateDodaniArtikl: _updateDodaniArtikl,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
  }

  _resetControllers() {
  }

  _dodajArtikl(Artikl? odabraniArtikl) {
    var listItem = ListItem(
      artikl: odabraniArtikl, artiklId: odabraniArtikl!.id, listaId: widget.lista != null ? widget.lista!.id : 0, kolicina: 1, 
    naziv: odabraniArtikl.naziv, barkod: odabraniArtikl.barkod, kod: odabraniArtikl.kod, cijena: odabraniArtikl.cijena );

    var existing = dodaniArtikli.firstWhereOrNull((element) => element.barkod == odabraniArtikl.barkod);
    if(existing == null) {
      dodaniArtikli.add(listItem);
    }

    setState(() {
      dodaniArtikli = List.of(dodaniArtikli);
      widget.lista!.items = List.of(dodaniArtikli);
    });

    _updateTotalValues();
  }

    


  void _removeDodaniArtikl(ListItem? item) {
    setState(() {
      dodaniArtikli.remove(item);
      dodaniArtikli = List.of(dodaniArtikli);
      widget.lista!.items = List.of(dodaniArtikli);
    });
    _updateTotalValues();
  }

  void _scanBarcode() {}

  void _updateDodaniArtikl(ListItem dodaniArt) {
    ListItem? existing;
    existing = dodaniArtikli.firstWhereOrNull((x) => x.barkod == dodaniArt.barkod);

    if(existing != null) {
      existing.barkod = dodaniArt.barkod;
      existing.cijena = dodaniArt.cijena;
      existing.id = dodaniArt.id;
      existing.kod = dodaniArt.kod;
      existing.kolicina = dodaniArt.kolicina;
      existing.listaId = dodaniArt.listaId;
      existing.naziv = dodaniArt.naziv;
      existing.artiklId = dodaniArt.artiklId;

      var artikl = artikli.firstWhereOrNull((x) => x.id == existing!.artiklId);
      existing.artikl = artikl;

      // var mjernaJedinica = mjerne

      setState(() {
        dodaniArtikli = List.of(dodaniArtikli);
      });
      _updateTotalValues();
    }
  }
  
  _spremiIzmjene() async {
    var lista = Lista(
      id: widget.lista!.id!,
      naziv: widget.lista!.naziv!,
      skladiste: widget.lista!.skladiste!,
      napomena: widget.lista!.napomena,
      items: dodaniArtikli
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
  }
}