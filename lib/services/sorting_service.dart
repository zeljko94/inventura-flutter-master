

import 'package:inventura_app/common/sorting_options_screen.dart';

class SortingAndFilteringService {

  static SortingAndFilteringOptions sortingAndFilteringOptions = SortingAndFilteringOptions(sortByColumn: 'naziv', sortOrder: 'asc');

  static const columnMappings = <String, String> {
    'Naziv': 'naziv',
    'Sifra': 'kod',
    'Barkod': 'barkod',
    'Jedinica mjere': 'jedinicaMjere',
    'Cijena': 'cijena'
  };


  static get() {

  }


  static update() {

  }

  // static apply(List<dynamic> data) {

  // }
}