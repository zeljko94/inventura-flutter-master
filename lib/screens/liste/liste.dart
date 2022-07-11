import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/confirmation_dialog.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/screens/export_data/export_data_screen.dart';
import 'package:inventura_app/screens/liste/add_edit_lista_screen.dart';
import 'package:inventura_app/screens/liste/lista_pregled_artikala_screen.dart';
import 'package:inventura_app/services/sqlite/liste_service.dart';

class ListeScreen extends StatefulWidget {
  const ListeScreen({ Key? key }) : super(key: key);

  @override
  _ListeScreenState createState() => _ListeScreenState();
}

class _ListeScreenState extends State<ListeScreen> {
  List<Lista> liste = [];
  List<Lista> listeStore = [];
  final ListeService? _listeService = ListeService();
  bool isSearchMode = false;
  // List<Lista> searchSelectedLista = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();


    fetchListe();
  }

  fetchListe() async {
    var listeData = await _listeService!.fetchAll();
    setState(() {
      liste = listeData;
      listeStore = listeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearchMode ? buildSearchAppBar('Liste', context) : MainAppBar.buildAppBar('Liste', 'Pregled svih lista', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
    );
  }
  
  _buildBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
          image: const AssetImage(ColorPalette.backgroundImagePath),
          fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: searchController,
            cursorColor: ColorPalette.primary,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: UnderlineInputBorder(),
              labelText: 'Search',
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
            onChanged: _searchOnChange,
          ),
          Expanded(
            child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: liste.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                child: Card(
                    child: ListTile(
                        onTap: () {
                          if(!isSearchMode) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: const RouteSettings(name: '/lista-pregled-artikala'),
                                builder: (context) => ListaPregledArtikalaScreen(
                                  lista: liste[index],
                                  onAddLista: fetchListe,
                                  onUpdateLista: fetchListe,
                                ),
                              ),
                            );
                          }
                          else {
                            setState(() {
                              liste[index].isCheckedForExport = !liste[index].isCheckedForExport!;
                            });
                          }
                        },
                        onLongPress: () async {
                        //  liste[index].isCheckedForExport != liste[index].isCheckedForExport;
                          _toggleSearchModeOn();
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(isSearchMode) Checkbox(
                              checkColor: ColorPalette.success,
                              value: liste[index].isCheckedForExport,
                              onChanged: (value) async {
                                setState(() {
                                  liste[index].isCheckedForExport = !liste[index].isCheckedForExport!;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(liste[index].naziv!),
                                Text(liste[index].skladiste!)
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Broj artikala: ' + liste[index].items!.length.toString())
                            ],)
                          ],
                        ),)),
              );
            },
          )
          ),
        ],
      ),
    );
  }
  
  _buildButton() {
    return FloatingActionButton(
          heroTag: null,
          backgroundColor: ColorPalette.info,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/add-edit-lista'),
                builder: (context) => AddEditListaScreen(
                  onAddLista: fetchListe,
                  onUpdateLista: fetchListe,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
  }

  _toggleSearchModeOff() {
    setState(() {
      isSearchMode = false;
      
      for(var i=0; i<liste.length; i++) {
        liste[i].isCheckedForExport = false;
      }
    });
  }

  _toggleSearchModeOn() {
    setState(() {
      isSearchMode = true;
    });
  }


  AppBar buildSearchAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        if(liste.where((lista) => lista.isCheckedForExport == true).toList().length < 2 && liste.where((lista) => lista.isCheckedForExport == true).toList().isNotEmpty) Tooltip(
          message: 'Uredi listu',
          child: IconButton(onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/add-edit-lista'),
              builder: (context) => AddEditListaScreen(
                lista: liste.firstWhere((element) => element.isCheckedForExport!),
                onAddLista: fetchListe,
                onUpdateLista: fetchListe,
              ),
            ),
          );
        }, icon: const Icon(Icons.edit)),),
        Tooltip(
          message: 'Obriši listu',
          child: IconButton(onPressed: () async {
          // if(searchSelectedLista != null) {
            await _deleteSelectedListe();
          // }
        },  icon: const Icon(Icons.delete))
        ),
        Tooltip(
          message: 'Izvoz liste',
          child: IconButton(onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/export-data'),
              builder: (context) => ExportDataScreen(
                liste: liste.where((lista) => lista.isCheckedForExport!).toList(),
                // onAddLista: fetchListe,
                // onUpdateLista: fetchListe,
              ),
            ),
          );
        }, icon: const Icon(Icons.upload))
        ),
        Tooltip(
          message: 'Odustani',
          child: IconButton(onPressed: () async {
          _toggleSearchModeOff();
        }, icon: const Icon(CustomIcons.times)),
        ),
      ],
    );
  }

  _deleteSelectedListe() async {
    var confirmDelete = await ConfirmationDialog.openConfirmationDialog("Brisanje liste", 'Jeste li sigurni da želite trajno obrisati odabrane liste?', context);

    if(confirmDelete) {
      List<int> deletedIds = [];
      var selectedListe = liste.where((element) => element.isCheckedForExport!).toList();
      selectedListe.forEach((element) async {
        var deleted = await _listeService!.delete(element.id!);

        if(deleted > 0 ) {
          deletedIds.add(element.id!);
          await fetchListe();
        }
        else {
          var snackBar = const SnackBar(content: Text("Greška prilikom brisanja liste-!"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      });
      var snackBar = const SnackBar(content: Text("Liste uspješno obrisane!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if(isSearchMode) {
        _toggleSearchModeOff();
      }
    }
  }

  _searchOnChange(String value) {
    setState(() {
      if(value.isEmpty) {
        liste = List.of(listeStore);
      }
      else {
        liste = listeStore.where((element) => element.naziv!.toLowerCase().contains(value.toLowerCase())).toList();
      }
    });
  }

}