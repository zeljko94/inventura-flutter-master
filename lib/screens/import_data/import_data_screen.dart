import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/data_import.dart';
import 'package:inventura_app/screens/import_data/add_edit_data_import_screen.dart';

class ImportDataScreen extends StatefulWidget {
  const ImportDataScreen({ Key? key }) : super(key: key);

  @override
  State<ImportDataScreen> createState() => _ImportDataScreenState();
}

class _ImportDataScreenState extends State<ImportDataScreen> {

  List<DataImport> dataImports = [];


  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
        await fetchDataImports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar.buildAppBar('Data imports', context),
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
          itemCount: dataImports.length,
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
                            builder: (context) => AddEditDataImportScreen(
                              dataImport: dataImports[index],
                              onAddDataImport: fetchDataImports,
                              onUpdateDataImport: fetchDataImports,
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await _deleteDataImport(dataImports[index].id!);
                      },
                      title:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dataImports[index].naziv!, style: TextStyle(fontSize: 16),),
                              Text(DateFormat('dd. MM. yyyy. HH:mm:ss').format(dataImports[index].datum!))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(dataImports[index].tipImporta!)
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
                settings: const RouteSettings(name: '/add-edit-artikl'),
                builder: (context) => AddEditDataImportScreen(
                      onAddDataImport: fetchDataImports,
                      onUpdateDataImport: fetchDataImports,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
  }

  fetchDataImports() async {
    return Future.delayed(Duration.zero, () async {
      List<DataImport> dataImportsList = [];
      dataImportsList.add(DataImport(id: 1, naziv: 'Data import 1', datum: DateTime.now(), tipImporta: 'txt'));
      dataImportsList.add(DataImport(id: 2, naziv: 'Data import 2', datum: DateTime.now().add(const Duration(days: 1)), tipImporta: 'csv'));
      dataImportsList.add(DataImport(id: 3, naziv: 'Data import 3', datum: DateTime.now().add(const Duration(days: 2)), tipImporta: 'xls'));

      setState(() {
        dataImports = List.of(dataImportsList);
      });
      return dataImports;
    });
  }

  _deleteDataImport(int id) async {
    // var deleted = await _sqlLiteService.deleteArtikl(id);

    var deleted = 1;
    dataImports.remove(dataImports.firstWhere((x) => x.id == id));
    if(deleted > 0 ) {
      var snackBar = const SnackBar(content: Text("Import uspješno obrisan!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // await fetchDataImports();
      setState(() {
        dataImports = List.of(dataImports);
      });
    }
  }
}