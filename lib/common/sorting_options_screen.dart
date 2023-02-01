import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';

class SortingOptionsScreen extends StatefulWidget {
  final String? type;
  const SortingOptionsScreen({ Key? key, this.type }) : super(key: key);

  @override
  _SortingOptionsScreenState createState() => _SortingOptionsScreenState();
}

class _SortingOptionsScreenState extends State<SortingOptionsScreen> {
  List<String> sortColumnChips = [
    'Naziv',
    'Barkod',
    'Sifra',
    'Cijena',
    'Jedinica mjere',
  ];

  String selectedSortColumnChip = 'Naziv';
  String selectedSortOrder = 'Ascending';

  @override
  void initState() {
    super.initState();
    
    if(widget.type == 'artikli') {
      
    }
    else if(widget.type == 'liste') {
      setState(() {
        sortColumnChips = ['Naziv', 'Datum kreiranja', 'Broj artikala'];
      });
    }
    else if(widget.type == 'lista_pregled_artikala') {
      setState(() {
        sortColumnChips.add('Kolicina');
        sortColumnChips.add('Id');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Sorting options', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
    );
  }
  
  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text('SORT BY', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Wrap(
          children: [
            for(var chip in sortColumnChips) Padding(
              padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    selectedSortColumnChip = chip;
                  });
                },
                child: Chip(label: Text(chip, style: TextStyle(color: ColorPalette.basic[50],)), backgroundColor: chip == selectedSortColumnChip ? ColorPalette.primary : ColorPalette.secondaryText,),
              ),
            )
          ],
        ),

        
        const Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text('SORT ORDER', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                  child: InkWell(
                    child: Chip(
                    label: Text('Ascending', style: TextStyle(color: ColorPalette.basic[50],)), 
                    backgroundColor: selectedSortOrder == 'Ascending' ? ColorPalette.primary : ColorPalette.secondaryText,
                  ),
                  onTap: () async {
                    setState(() {
                      selectedSortOrder = 'Ascending';
                    });
                  },
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(2),
              child: InkWell(
                child: Chip(
                label: Text('Descending', style: TextStyle(color: ColorPalette.basic[50],)),
                backgroundColor: selectedSortOrder == 'Descending' ? ColorPalette.primary : ColorPalette.secondaryText,
              ),
              onTap: () async {
                setState(() {
                  selectedSortOrder = 'Descending';
                });
              },
              ),
            )
          ],
        )
      ],
    );
  }


  
  AppBar buildAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        Tooltip(
          message: 'Primjeni',
          child: IconButton(onPressed: () async {
            Navigator.pop(context, SortingOptions(sortByColumn: selectedSortColumnChip, sortOrder: selectedSortOrder));
        }, icon: const Icon(Icons.check)),
        ),
      ],
    );
  }

  
}

class SortingOptions {
  String? sortByColumn;
  String? sortOrder;

  SortingOptions({ this.sortByColumn, this.sortOrder });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'sortByColumn': sortByColumn,
      'sortOrder': sortOrder
    };
  }
}