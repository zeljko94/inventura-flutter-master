
import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/screens/artikli/add_edit_artikl_screen.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class ArtikliScreen extends StatefulWidget {
  const ArtikliScreen({ Key? key }) : super(key: key);

  @override
  _ArtikliScreenState createState() => _ArtikliScreenState();
}

class _ArtikliScreenState extends State<ArtikliScreen> {
  final ArtikliService _sqlLiteService = ArtikliService();
  List<Artikl> artikli = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
        await fetchArtikli();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar.buildAppBar('Artikli', context),
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
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: artikli.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              child: Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/add-edit-artikl'),
                            builder: (context) => AddEditArtiklScreen(
                              artikl: artikli[index],
                              onAddArtikl: fetchArtikli,
                              onUpdateArtikl: fetchArtikli,
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await _deleteArtikl(artikli[index].id!);
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(artikli[index].naziv!),
                          Text(artikli[index].napomena!, style: TextStyle(color: ColorPalette.warning[600]),)
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
                settings: const RouteSettings(name: '/add-edit-artikl'),
                builder: (context) => AddEditArtiklScreen(
                      onAddArtikl: fetchArtikli,
                      onUpdateArtikl: fetchArtikli,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
  }

  fetchArtikli() async {
    var artikliData = await _sqlLiteService.fetchArtikli();
    setState(() {
      artikli = artikliData;
    });
  }

  _deleteArtikl(int id) async {
    var deleted = await _sqlLiteService.deleteArtikl(id);

    if(deleted > 0 ) {
      var snackBar = const SnackBar(content: Text("Artikl uspješno obrisan!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await fetchArtikli();
    }
  }
}