
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/confirmation_dialog.dart';
import 'package:inventura_app/common/filtering_options_screen.dart';
import 'package:inventura_app/common/loading_spinner.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/common/sorting_options_screen.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/screens/artikli/add_edit_artikl_screen.dart';
import 'package:inventura_app/screens/import_data/add_edit_data_import_screen.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class ArtikliScreen extends StatefulWidget {
  const ArtikliScreen({ Key? key }) : super(key: key);

  @override
  _ArtikliScreenState createState() => _ArtikliScreenState();
}

class _ArtikliScreenState extends State<ArtikliScreen> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;
  final ArtikliService _artikliService = ArtikliService();

  bool isLoading = false;
  List<Artikl> artikli = [];
  List<Artikl> artikliStore = [];
  bool isSearchMode = false;

  TextEditingController searchController = TextEditingController();
  var currencyFormat = NumberFormat.currency(locale: "hr_HR", symbol: "KM");

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
        await fetchAppSettings();
        await fetchArtikli();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchAppBar('Artikli', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      floatingActionButton: _buildButton(),
    );
  }

  _buildBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
          image: AssetImage(ColorPalette.backgroundImagePath),
           fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            controller: searchController,
            cursorColor: ColorPalette.primary,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    searchController.text = '';
                    setState(() {
                      artikli = List.of(artikliStore);
                    });
                },
                  icon: Icon(CustomIcons.times), 
                  iconSize: 14,
              ),
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
          artikli.isEmpty && !isLoading ? Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Nema artikala za prikaz.', style: TextStyle(color: ColorPalette.secondaryText[50])),
          ) : SizedBox(),
          
          // if(artikliStore.isEmpty && !isLoading) 
          //   ElevatedButton.icon(
          //     icon: Icon(Icons.add),
          //     label: Text('Uvezi artikle'),
          //     onPressed: () async {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             settings: const RouteSettings(name: '/import-data'),
          //             builder: (context) => AddEditDataImportScreen(
          //             ),
          //           ),
          //         );
          //     },
          //   ),
          Expanded(child: 
          !isLoading ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: artikli.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                // padding: EdgeInsets.zero,
                child: Card(
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        tileColor: ColorPalette.listItemTileBackgroundColor,
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
                        },
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(artikli[index].naziv!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: ColorPalette.basic[900], fontSize: 18, fontWeight: FontWeight.bold ),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(artikli[index].barkod!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        Text(artikli[index].kod!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(currencyFormat.format(artikli[index].cijena!), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        Text(artikli[index].jedinicaMjere!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    ),
              );
            },
          ) : const Center(child: CircularProgressIndicator(),),)
        ],
      ),
    );
  }

  _buildButton() {
    // return FloatingActionButton(
    //       heroTag: null,
    //       backgroundColor: ColorPalette.info,
    //       onPressed: () async {
    //         await fetchArtikli();
    //       },
    //       child: const Icon(Icons.add),
    //     );
  }

  fetchAppSettings() async {
    var settings = await _appSettingsService.getSettings();
    setState(() {
      _settings = settings;
    });
  }

  fetchArtikli() async {
    _setIsLoading(true);
    try {
      var artikliData = await _artikliService.fetchArtikli();
      setState(() {
        artikli = artikliData;
        artikliStore = List.of(artikliData);
      });
      _setIsLoading(false);
    }
    catch(exception) {
      print(exception);
      _setIsLoading(false);
    }
  }

  _deleteArtikl(int id) async {
    var deleted = await _artikliService.deleteArtikl(id);

    if(deleted > 0 ) {
      var snackBar = const SnackBar(content: Text("Artikl uspješno obrisan!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await fetchArtikli();
    }
  }

  _searchOnChange(String value) {
    setState(() {
      if(value.isEmpty) {
        artikli = List.of(artikliStore);
      }
      else {
        artikli = artikliStore.where((element) => element.naziv!.toLowerCase().contains(value.toLowerCase()) || 
        element.barkod!.toLowerCase().contains(value.toLowerCase()) || element.kod!.toLowerCase().contains(value.toLowerCase())).toList();
      }
    });
  }


  _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
  
  _applySorting(SortingOptions options) async {
    setState(() {
      if(options.sortOrder == 'Ascending') {
        if(options.sortByColumn == 'Naziv') {
          artikli.sort((a, b) => a.naziv!.compareTo(b.naziv!));
        }
        else if(options.sortByColumn == 'Barkod') {
          artikli.sort((a, b) => a.barkod!.compareTo(b.barkod!));
        }
        else if(options.sortByColumn == 'Sifra') {
          artikli.sort((a, b) => a.kod!.compareTo(b.kod!));
        }
        else if(options.sortByColumn == 'Cijena') {
          artikli.sort((a, b) => a.cijena!.compareTo(b.cijena!));
        }
        else if(options.sortByColumn == 'Jedinica mjere') {
          artikli.sort((a, b) => a.jedinicaMjere!.compareTo(b.jedinicaMjere!));
        }
      }
      else if(options.sortOrder == 'Descending') {
        if(options.sortByColumn == 'Naziv') {
          artikli.sort((a, b) => b.naziv!.compareTo(a.naziv!));
        }
        else if(options.sortByColumn == 'Barkod') {
          artikli.sort((a, b) => b.barkod!.compareTo(a.barkod!));
        }
        else if(options.sortByColumn == 'Sifra') {
          artikli.sort((a, b) => b.kod!.compareTo(a.kod!));
        }
        else if(options.sortByColumn == 'Cijena') {
          artikli.sort((a, b) => b.cijena!.compareTo(a.cijena!));
        }
        else if(options.sortByColumn == 'Jedinica mjere') {
          artikli.sort((a, b) => b.jedinicaMjere!.compareTo(a.jedinicaMjere!));
        }
      }
    });
  }

  _applyFiltering(FilteringOptions options) {

  }

  AppBar buildSearchAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.sync), onPressed: () async { await _onSyncPress(); }),
        IconButton(icon: const Icon(Icons.sort), onPressed: () async {
            SortingOptions? result = await Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/sorting-options'),
                builder: (context) => const SortingOptionsScreen(),
              ),
            );
            if(result != null) {
              _applySorting(result);
            }
        }),
        IconButton(icon: const Icon(CustomIcons.filter), onPressed: () async {
            FilteringOptions? result = await Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/filtering-options'),
                builder: (context) => const FilteringOptionsScreen(),
              ),
            );
            if(result != null) {
              _applyFiltering(result);
            }
        }),
      ],
    );
  }

  _onSyncPress() async {
    var result = await ConfirmationDialog.openConfirmationDialog('', 'Želite li pokrenuti sinkronizaciju artikala?', context);

    

    if(result) {
      if(_settings!.defaultImportMethod == 'csv') {       
          Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/import-data'),
                builder: (context) => AddEditDataImportScreen(
                ),
              ),
            );
        // if(files.isNotEmpty) {
        //   buildLoadingSpinner('Učitavanje...', context);
        //   var artikli = await _dataImportService!.getArtikliFromCsv(files.first);
        //   if(artikli == null) {
        //     removeLoadingSpinner(context);
        //     var snackBar = const SnackBar(content: Text("Greška prilikom uvoza podataka!"));
        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //     return;
        //   }

        //   await _artikliService!.deleteAll();
        //   var isOkInsert = await _artikliService!.bulkInsert(artikli);

        //   if(isOkInsert) {
        //     removeLoadingSpinner(context);
        //     var snackBar = const SnackBar(content: Text("Artikli uspješno uvezeni!"));
        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //     return;
        //   }
        //   else {
        //     removeLoadingSpinner(context);
        //     var snackBar = const SnackBar(content: Text("Greška prilikom spremanja podataka u sqlite bazu!"));
        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //     return;
        //   }
        // }
        // else {
        //   var snackBar = const SnackBar(content: Text("Odaberite datoteku za uvoz!"));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      }
      else if(_settings!.defaultImportMethod == 'rest api') {
        // buildLoadingSpinner('Učitavanje...', context);
        // var artikli = await _dataImportService!.getArtikliFromRestApi(restApiLinkController.text);
        // await _artikliService!.deleteAll();
        // await _artikliService!.bulkInsert(artikli!);
        // removeLoadingSpinner(context);
      }
    }
  }
}