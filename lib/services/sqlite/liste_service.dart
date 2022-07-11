
import 'package:inventura_app/models/lista.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';
import 'package:inventura_app/services/sqlite/list_item_service.dart';
import 'package:inventura_app/services/sqlite/sqlite_base_service.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'dart:async';


class ListeService extends SqliteBaseService {
    final ListItemService? _listItemService = ListItemService();
    final ArtikliService? _artikliService = ArtikliService();

  Future<int> add(Lista lista) async{ 
    final db = await init(); 
    var map = lista.toMap();
    map.remove("id");
    map.remove("items");
    map.remove("isCheckedForExport");
    var insertedListaId = await db.insert("Liste", map, conflictAlgorithm: ConflictAlgorithm.ignore,);

    if(insertedListaId > 0) {
      for(var i=0; i<lista.items!.length; i++) {
        lista.items![i].listaId = insertedListaId;
        await _listItemService!.add(lista.items![i]);
      }
    }

    return insertedListaId;
  }

 Future<List<Lista>> fetchAll() async {
    final db = await init();
    final maps = await db.query("Liste");

    var liste = List.generate(maps.length, (i) { 
      return Lista(              
        id: maps[i]['id'] as int,
        naziv: maps[i]['naziv'] as String,
        napomena: maps[i]['napomena'] as String,
        skladiste: maps[i]['skladiste'] as String,
        items: []
      );
    });

    for(var i=0; i<liste.length; i++) {
      liste[i].items = await _listItemService!.getListItems(liste[i].id!);
      // for(var j=0; j<liste[i].items!.length; j++) {
      //   liste[i].items![j].artikl = await _artikliService!.getById(liste[i].items![j].artiklId!);
      // }
    }

    return liste;
  }

  Future<int> delete(int id) async{ //returns number of items deleted
    final db = await init();

    await _listItemService!.deleteListItems(id);
  
    int result = await db.delete(
      "Liste",
      where: "id = ?",
      whereArgs: [id] 
    );

    return result;
  }

  Future<int> update(int id, Lista lista) async{
    final db = await init();
    var map = lista.toMap();
    map.remove("items");
    map.remove("isCheckedForExport");
  
    int result = await db.update(
      "Liste", 
      map,
      where: "id = ?",
      whereArgs: [id]
    );
    if(result > 0) {
      await _listItemService!.deleteListItems(id);
      for(var i=0; i<lista.items!.length; i++) {
        await _listItemService!.add(lista.items![i]);
      }
    }

    return result;
 }
}