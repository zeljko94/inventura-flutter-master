import 'package:inventura_app/models/artikl.dart';


class ListItem {
  int? id;
  int? artiklId;
  int? listaId;
  num? kolicina;
  num? cijena;
  String? barkod;
  String? kod;
  String? naziv;

  ListItem({ this.id, this.artiklId, this.listaId, this.artikl, this.naziv, this.kolicina, this.cijena, this.barkod, this.kod });

  Artikl? artikl;

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'artiklId': artiklId as int,
      'listaId': listaId as int,
      'kolicina': kolicina as num,
      'naziv': naziv != null ? naziv as String : '',
      'cijena': cijena != null ? cijena as num : 0,
      'barkod': barkod != null ? barkod as String : '',
      'kod': kod != null ? kod as String : ''
    };
  }
}

