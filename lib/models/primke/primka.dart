import 'package:inventura_app/models/list_item.dart';

class Primka {
  int? id;
  String? naziv;
  String? napomena;
  String? skladiste;
  String? datumKreiranja;
  bool? isCheckedForExport = false;
  bool? isFinished = false;
  // int? kolicinaSkeniranih;
  // int? potrebnaKolicina;
  List<ListItem>? items = [];

  Primka({ this.id, this.naziv, this.napomena, this.skladiste, this.items, this.datumKreiranja, this.isFinished });


  
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'naziv': naziv,
      'napomena': napomena,
      'skladiste': skladiste,
      'items': items,
      'isCheckedForExport': isCheckedForExport,
      'datumKreiranja': datumKreiranja,
      'isFinished': isFinished
    };
  }
}
