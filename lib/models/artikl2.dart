
class Artikl2 {
  int? id;
  String? sifra;
  String? naziv;
  String? jmj;
  List<Barkod>? barkodovi;

  Artikl2({ this.id, this.sifra, this.naziv, this.jmj, this.barkodovi });

  Artikl2.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    sifra = json['SIFRA'];
    naziv = json['NAZIV'];
    jmj = json['JMJ'];
    if (json['BARKODOVI'] != null) {
      barkodovi = <Barkod>[];
      json['BARKODOVI'].forEach((v) {
        barkodovi!.add(Barkod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = id;
    data['SIFRA'] = sifra;
    data['NAZIV'] = naziv;
    data['JMJ'] = jmj;
    if (barkodovi != null) {
      data['BARKODOVI'] = barkodovi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Barkod {
  int? id;
  int? barkod;
  int? artiklId;

  Barkod({this.id, this.barkod, this.artiklId });

  Barkod.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    barkod = json['BARKOD'];
    artiklId = json['ARTIKL_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = id;
    data['BARKOD'] = barkod;
    data['ARTIKL_ID'] = artiklId;
    return data;
  }
}