import 'package:flutter/material.dart';
import 'package:inventura_app/common/app_bar.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ArtikliService _artikliService = ArtikliService();
  List<Artikl> _artikli = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {
      var artikli = await _artikliService.fetchArtikli();
      setState(() {
        _artikli = artikli;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar.buildAppBar('Inventura app', '', context),
         body: _buildBody(),
        drawer: MenuDrawer.getDrawer());
  }

  _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
  
  _buildBody() {
    return Column(
      children: [
        _artikli.isEmpty ? const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Nema artikala za prikaz.', style: TextStyle(color: ColorPalette.warning)),
        ) : SizedBox(),
        Expanded(child: 
        !isLoading ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _artikli.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              // padding: EdgeInsets.zero,
              child: Card(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      onTap: () {
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
                                    Text(_artikli[index].naziv!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: ColorPalette.basic[900], fontSize: 18, fontWeight: FontWeight.bold ),)
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
                                      Text(_artikli[index].barkod!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      Text(_artikli[index].kod!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(_artikli[index].cijena!.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      Text(_artikli[index].jedinicaMjere!, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
    );
  }



}
