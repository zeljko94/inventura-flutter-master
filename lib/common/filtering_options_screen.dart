

import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';

class FilteringOptionsScreen extends StatefulWidget {
  final String? type;
  const FilteringOptionsScreen({Key? key, this.type }) : super(key: key);

  @override
  State<FilteringOptionsScreen> createState() => _FilteringOptionsScreenState();
}

class _FilteringOptionsScreenState extends State<FilteringOptionsScreen> {
    List<ChipItem> filterColumnChips = [
    ChipItem(text: 'Naziv', isChecked: false),
    ChipItem(text: 'Barkod', isChecked: false),
    ChipItem(text: 'Sifra', isChecked: false),
    ChipItem(text: 'Cijena', isChecked: false),
    ChipItem(text: 'Jedinica mjere', isChecked: false),
  ];


@override
  void initState() {
    super.initState();
    
    if(widget.type == 'artikli') {
      
    }
    else if(widget.type == 'liste') {
      setState(() {
      });
    }
    else if(widget.type == 'lista_pregled_artikala') {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Filtering options', context), 
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
          child: Text('FILTER BY', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Wrap(
          children: [
            for(var i=0; i<filterColumnChips.length; i++) Padding(
              padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    filterColumnChips[i].isChecked = !filterColumnChips[i].isChecked!;
                  });
                },
                child: Chip(label: Text(filterColumnChips[i].text!, style: TextStyle(color: ColorPalette.basic[50],)), backgroundColor: filterColumnChips[i].isChecked! ? ColorPalette.primary : ColorPalette.secondaryText,),
              ),
            )
          ],
        ),
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
            Navigator.pop(context, FilteringOptions(filterByColumns: filterColumnChips.map((e) => e.text!).toList()));
        }, icon: const Icon(Icons.check)),
        ),
      ],
    );
  }
}

class FilteringOptions {
  List<String>? filterByColumns;

  FilteringOptions({ this.filterByColumns });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'filterByColumn': filterByColumns,
    };
  }
}

class ChipItem {
  String? text;
  bool? isChecked;

  ChipItem({ this.text, this.isChecked });
}