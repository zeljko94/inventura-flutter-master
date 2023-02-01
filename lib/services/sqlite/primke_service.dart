


import 'package:inventura_app/models/primke/primka.dart';
import 'package:inventura_app/services/sqlite/sqlite_base_service.dart';
import 'package:sqflite/sqflite.dart';

class PrimkeService extends SqliteBaseService {

  Future<int?> add(Primka primka) async{ 
    try {
      final db = await init(); 
      var map = primka.toMap();
      map.remove("id");
      map.remove("items");
      map.remove("isCheckedForExport");
      var insertedListaId = await db.insert("Primke", map, conflictAlgorithm: ConflictAlgorithm.ignore,);

      if(insertedListaId > 0) {
        for(var i=0; i<primka.items!.length; i++) {
          primka.items![i].listaId = insertedListaId;
          // await _listItemService!.add(primka.items![i]);
        }
      }

      return insertedListaId;
    }
    catch(exception) {
      print(exception);
      return null;
    }
  }

 Future<List<Primka>> fetchAll() async {
    final db = await init();
    final maps = await db.query("Primke");

    var liste = List.generate(maps.length, (i) { 
      return Primka(              
        id: maps[i]['id'] as int,
        naziv: maps[i]['naziv'] as String,
        napomena: maps[i]['napomena'] as String,
        skladiste: maps[i]['skladiste'] as String,
        datumKreiranja: maps[i]['datumKreiranja'] as String,
        items: []
      );
    });

    for(var i=0; i<liste.length; i++) {
      // liste[i].items = await _listItemService!.getListItems(liste[i].id!);
    }

    return liste;
  }

  Future<int> delete(int id) async{ //returns number of items deleted
    final db = await init();

    // await _listItemService!.deleteListItems(id);
  
    int result = await db.delete(
      "Primke",
      where: "id = ?",
      whereArgs: [id] 
    );

    return result;
  }

  Future<int> update(int id, Primka primka) async{
    final db = await init();
    var map = primka.toMap();
    map.remove("items");
    map.remove("isCheckedForExport");
  
    int result = await db.update(
      "Primke", 
      map,
      where: "id = ?",
      whereArgs: [id]
    );
    // if(result > 0) {
    //   await _listItemService!.deleteListItems(id);
    //   for(var i=0; i<primka.items!.length; i++) {
    //     await _listItemService!.add(primka.items![i]);
    //   }
    // }

    return result;
 }
}