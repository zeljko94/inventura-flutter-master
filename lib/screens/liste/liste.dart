import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/confirmation_dialog.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/lista.dart';
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
  Lista? searchSelectedLista;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchListe();
  }

  fetchListe() {
    Future.delayed(Duration.zero, () async {
      var listeData = await _listeService!.fetchAll();
      setState(() {
        liste = listeData;
        listeStore = listeData;
      });
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
    return Column(
      children: [
        TextFormField(
          controller: searchController,
          cursorColor: ColorPalette.primary,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: UnderlineInputBorder(),
            labelText: 'Search',
            floatingLabelStyle:
                TextStyle(color: Color.fromARGB(255, 0, 95, 55)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 0, 95, 55),
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
        ListView.builder(
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
                      },
                      onLongPress: () async {
                        searchSelectedLista = liste[index];
                        _toggleSearchModeOn();
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
        ),
      ],
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
      searchSelectedLista = null;
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
        Tooltip(
          message: 'Uredi listu',
          child: IconButton(onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/add-edit-lista'),
              builder: (context) => AddEditListaScreen(
                lista: searchSelectedLista,
                onAddLista: fetchListe,
                onUpdateLista: fetchListe,
              ),
            ),
          );
        }, icon: const Icon(Icons.edit)),),
        Tooltip(
          message: 'Obriši listu',
          child: IconButton(onPressed: () async {
          if(searchSelectedLista != null) {
            await _deleteLista(searchSelectedLista!.id!);
          }
        },  icon: const Icon(Icons.delete))
        ),
        Tooltip(
          message: 'Izvoz liste',
          child: IconButton(onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/add-edit-lista'),
              builder: (context) => AddEditListaScreen(
                lista: searchSelectedLista,
                onAddLista: fetchListe,
                onUpdateLista: fetchListe,
              ),
            ),
          );
        }, icon: const Icon(Icons.upload))
        ),
        Tooltip(
          message: 'Odustani',
          child: IconButton(onPressed: () async {
          _toggleSearchModeOff();
        }, icon: const Icon(Icons.cancel)),
        ),
      ],
    );
  }

  _deleteLista(int id) async {
    var confirmDelete = await ConfirmationDialog.openConfirmationDialog("Brisanje liste", 'Jeste li sigurni da želite trajno obrisati listu?', context);

    if(confirmDelete) {
      var deleted = await _listeService!.delete(id);

      if(deleted > 0 ) {
        var snackBar = const SnackBar(content: Text("Lista uspješno obrisana!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if(isSearchMode) {
          _toggleSearchModeOff();
        }
        await fetchListe();
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