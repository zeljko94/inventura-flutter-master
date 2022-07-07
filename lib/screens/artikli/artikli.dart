
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/common/sorting_and_filtering_options_screen.dart';
import 'package:inventura_app/custom_icons_icons.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/screens/artikli/add_edit_artikl_screen.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class ArtikliScreen extends StatefulWidget {
  const ArtikliScreen({ Key? key }) : super(key: key);

  @override
  _ArtikliScreenState createState() => _ArtikliScreenState();
}

class _ArtikliScreenState extends State<ArtikliScreen> {
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
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.33), BlendMode.dstATop),
          image: AssetImage("assets/images/background2.jpg"),
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
          artikli.isEmpty ? Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Nema artikala za prikaz.', style: TextStyle(color: ColorPalette.secondaryText[50])),
          ) : SizedBox(),
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
                                        Text(artikli[index].cijena!.toString() + ' KM', maxLines: 1, overflow: TextOverflow.ellipsis,),
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
  
  _applySorting(SortingAndFilteringOptions options) async {
    setState(() {
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
    });
  }

  AppBar buildSearchAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.sort), onPressed: () async {
            SortingAndFilteringOptions? result = await Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/sorting-and-filtering-options'),
                builder: (context) => const SortingAndFilteringOptionsScreen(),
              ),
            );
            if(result != null) {
              _applySorting(result);
            }
        }),
        IconButton(icon: const Icon(CustomIcons.filter), onPressed: () async {}),
      ],
    );
  }
}