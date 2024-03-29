import 'package:inventura_app/common/sorting_options_screen.dart';
import 'package:inventura_app/screens/artikli/add_edit_artikl_screen.dart';
import 'package:inventura_app/screens/artikli/artikli.dart';
import 'package:inventura_app/screens/auth/login.dart';
import 'package:inventura_app/screens/export_data/export_data_screen.dart';
import 'package:inventura_app/screens/import_data/add_edit_data_import_screen.dart';
import 'package:inventura_app/screens/liste/add_edit_dodani_artikl.dart';
import 'package:inventura_app/screens/liste/add_edit_lista_screen.dart';
import 'package:inventura_app/screens/liste/lista_pregled_artikala_screen.dart';
import 'package:inventura_app/screens/liste/liste.dart';
import 'package:inventura_app/screens/primke/primka_details.dart';
import 'package:inventura_app/screens/primke/primke.dart';
import 'package:inventura_app/screens/settings/settings.dart';

var routes = {
   '/login': (ctx) => const LoginScreen(),

  //  '/dashboard': (ctx) => const DashboardScreen(title: 'Početna'),
   
   '/artikli': (ctx) => const ArtikliScreen(),
   '/add-edit-artikl': (ctx) => const AddEditArtiklScreen(),

   '/liste': (ctx) => const ListeScreen(),
   '/lista-pregled-artikala': (ctx) => const ListaPregledArtikalaScreen(),
   '/add-edit-lista': (ctx) => const AddEditListaScreen(),
   '/add-edit-dodani-artikl': (ctx) => const AddEditDodaniArtikl(),

   '/primke': (ctx) => const PrimkeScreen(),
   '/primka-details': (ctx) => const PrimkaDetailsScreen(),


   '/import-data': (ctx) => const AddEditDataImportScreen(),
   '/export-data': (ctx) => const ExportDataScreen(),

   '/sorting-options': (ctx) => const SortingOptionsScreen(),
   '/filtering-options': (ctx) => const SortingOptionsScreen(),

   '/postavke': (ctx) => const SettingsScreen(),
};