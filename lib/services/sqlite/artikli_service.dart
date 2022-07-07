
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/services/sqlite/mjerne_jedinice_service.dart';
import 'package:inventura_app/services/sqlite/sqlite_base_service.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'dart:async';


class ArtikliService extends SqliteBaseService {
  final MjerneJediniceService _mjerneJediniceService = MjerneJediniceService();

  Future<int> addArtikl(Artikl artikl) async{ //retur
    final db = await init(); //open data
    var map = artikl.toMap();
    map.remove("id");
    return db.insert("Artikli", map, conflictAlgorithm: ConflictAlgorithm.ignore,);
 }

 Future<List<Artikl>> fetchArtikli() async{
    final db = await init();
    final maps = await db.query("Artikli");

    var artikli = List.generate(maps.length, (i) { 
      return Artikl(              
        id: maps[i]['id'] as int,
        barkod: maps[i]['barkod'] as String,
        naziv: maps[i]['naziv'] != null ? maps[i]['naziv'] as String : '',
        kod: maps[i]['kod'] != null ? maps[i]['kod'] as String : '',
        cijena: maps[i]['cijena'] != null ? maps[i]['cijena'] as num : 0,
        napomena: maps[i]['napomena'] != null ? maps[i]['napomena'] as String : '',
        // predefiniranaKolicina: maps[i]['predefiniranaKolicina'] != null ? maps[i]['predefiniranaKolicina'] as num : 0,
        jedinicaMjere: maps[i]['jedinicaMjere'] != null ? maps[i]['jedinicaMjere'] as String : '',
        pdv: maps[i]['pdv'] != null ? maps[i]['pdv'] as num : 0
      );
    });

    return artikli;
  }

  Future<List<Artikl>> pageFetch(int perPage, int offset) async {
    final db = await init();
    final maps = await db.query("Artikli", limit: perPage, offset: offset);

    var artikli = List.generate(maps.length, (i) { 
      return Artikl(              
        id: maps[i]['id'] as int,
        barkod: maps[i]['barkod'] as String,
        naziv: maps[i]['naziv'] != null ? maps[i]['naziv'] as String : '',
        kod: maps[i]['kod'] != null ? maps[i]['kod'] as String : '',
        cijena: maps[i]['cijena'] != null ? maps[i]['cijena'] as num : 0,
        napomena: maps[i]['napomena'] != null ? maps[i]['napomena'] as String : '',
        // predefiniranaKolicina: maps[i]['predefiniranaKolicina'] != null ? maps[i]['predefiniranaKolicina'] as num : 0,
        jedinicaMjere: maps[i]['jedinicaMjere'] != null ? maps[i]['jedinicaMjere'] as String : '',
        pdv: maps[i]['pdv'] != null ? maps[i]['pdv'] as num : 0
      );
    });

    return artikli;
  }

  Future<Artikl?> getById(int id) async {
    try {
      final db = await init();
      final maps = await db.query("Artikli", where: 'id = ?', whereArgs: [id]);

      var items = List.generate(maps.length, (i) { 
        return Artikl(              
          id: maps[i]['id'] as int,
          barkod: maps[i]['barkod'] as String,
          naziv: maps[i]['naziv'] != null ? maps[i]['naziv'] as String : '',
          kod: maps[i]['kod'] != null ? maps[i]['kod'] as String : '',
          cijena: maps[i]['cijena'] != null ? maps[i]['cijena'] as num : 0,
          napomena: maps[i]['napomena'] != null ? maps[i]['napomena'] as String : '',
          jedinicaMjere: maps[i]['jedinicaMjere'] != null ? maps[i]['jedinicaMjere'] as String : '',
          pdv: maps[i]['pdv'] != null ? maps[i]['pdv'] as num : 0
        );
    });

    return items.isNotEmpty ? items.first : null;
    }
    catch(exception) {
      print("artikl.getById");
      print(exception);
      return null;
    }
  }
  

  Future<bool> bulkInsert(List<Artikl> artikli) async {
    try {
      final db = await init();

      Batch batch = db.batch();
      artikli.forEach((artikl) { 
        batch.insert("Artikli", artikl.toMap());
      });
      await batch.commit(noResult: true);
      return true;
    }
    catch(exception) {
      print(exception);
      return false;
    }
  }

  Future<int> deleteAll() async {
    final db = await init();

    int result =  await db.delete(
      "Artikli",
    );

    return result;
  }

  Future<int> deleteArtikl(int id) async{ //returns number of items deleted
    final db = await init();
  
    int result = await db.delete(
      "Artikli",
      where: "id = ?",
      whereArgs: [id] 
    );

    return result;
  }

  Future<int> updateArtikl(int id, Artikl item) async{
    final db = await init();
  
    int result = await db.update(
        "Artikli", 
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
      );
      return result;
 }
}