import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:inventura_app/common/menu_drawer.dart';
import 'package:inventura_app/common/sorting_options_screen.dart';
import 'package:inventura_app/common/text_styles.dart';
import 'package:inventura_app/custom_icons_icons.dart';

class PrimkaDetailsScreen extends StatefulWidget {
  const PrimkaDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PrimkaDetailsScreen> createState() => _PrimkaDetailsScreenState();
}

class _PrimkaDetailsScreenState extends State<PrimkaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchAppBarNormal('Pregled primke', 'Naziv primke', context),
      body: _buildBody(),
      drawer: MenuDrawer.getDrawer(),
      // floatingActionButton: _buildButton(),
    );
  }

  _buildBody() {
    return Text("DETALJI");
  }

  _applySorting(var result) {

  }


  AppBar buildSearchAppBarNormal(String title, String subtitle, BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(title),
        subtitle != '' ? Text(subtitle, style: TextStyles.subtitleAppBar,) : const SizedBox()
      ]),
      actions: <Widget>[
          IconButton(icon: const Icon(Icons.sort), onPressed: () async {
            SortingOptions? result = await Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/sorting-options'),
                builder: (context) => const SortingOptionsScreen(
                  type: 'lista_pregled_artikala',
                ),
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