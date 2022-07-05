// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventura_app/common/text_styles.dart';
// import 'package:intranet_it4/screens/administracija/profil/profil.dart';
// import 'package:intranet_it4/screens/auth/promjena_lozinke.dart';

class MainAppBar {
  static AppBar buildAppBar(String title, String subtitle, BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(title),
        subtitle != '' ? Text(subtitle, style: TextStyles.subtitleAppBar,) : const SizedBox()
      ]),
      actions: <Widget>[
        // BackButton(onPressed: () {
        //   Navigator.of(context).maybePop();
        // }),
        // IconButton(onPressed: () async {}, icon: const Icon(Icons.search)),
        // IconButton(onPressed: () async {}, icon: const Icon(Icons.sort)),
        // IconButton(onPressed: () async {}, icon: const Icon(Icons.export)),
        // PopupMenuButton(
        //   icon: const Icon(Icons.person),
        //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        //     const PopupMenuItem(
        //       child: ListTile(
        //         leading: Icon(Icons.person),
        //         title: Text('Moj profil'),
        //       ),
        //       value: 1,
        //     ),
        //     const PopupMenuItem(
        //       child: ListTile(
        //         leading: Icon(Icons.lock),
        //         title: Text('Promjena lozinke'),
        //       ),
        //       value: 2,
        //     ),
        //     const PopupMenuItem(
        //       child: ListTile(
        //         leading: Icon(Icons.logout),
        //         title: Text('Odjavi se'),
        //       ),
        //       value: 3,
        //     ),
        //   ],
        //   // onSelected: (value) {
        //   //   switch (value) {
        //   //     case 1:
        //   //       Navigator.pushReplacement(context,
        //   //           MaterialPageRoute(builder: (context) {
        //   //         return MojProfil();
        //   //       }));
        //   //       break;
        //   //     case 2:
        //   //       Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   //         return PromjenaLozike(recovery: false);
        //   //       }));
        //   //       break;
        //   //     case 3:
        //   //       Navigator.of(context).pushReplacementNamed('/logout');
        //   //       break;
        //   //   }
        //   // },
        // )
      ],
    );
  }
}
