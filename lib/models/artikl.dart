

class Artikl {
  int? id;
  String? barkod;
  String? naziv;
  String? kod;
  num? cijena;
  // num? kolicina;
  String? napomena;
  num? predefiniranaKolicina;
  int? mjernaJedinicaId;

  Artikl({this.id, this.barkod, this.naziv, this.kod, this.cijena, this.napomena, this.predefiniranaKolicina, this.mjernaJedinicaId });


  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'barkod': barkod,
      'naziv': naziv,
      'kod': kod,
      'cijena': cijena,
      // 'kolicina': kolicina,
      'napomena': napomena,
      'predefiniranaKolicina': predefiniranaKolicina,
      'mjernaJedinicaId': mjernaJedinicaId
    };
  }
}