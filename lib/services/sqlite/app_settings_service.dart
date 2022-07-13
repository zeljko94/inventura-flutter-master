import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/services/sqlite/sqlite_base_service.dart';
import 'package:sqflite/sqflite.dart';

class AppSettingsService extends SqliteBaseService {


  Future<int> add(AppSettings appSettings) async{ 
    final db = await init(); //open database
    var map = appSettings.toMap();
    map.remove("id");
    return db.insert("AppSettings", map, conflictAlgorithm: ConflictAlgorithm.ignore);
  }


   Future<AppSettings> getSettings() async {
    final db = await init();
    final maps = await db.query("AppSettings");

    return List.generate(maps.length, (i) {
      return AppSettings(              
        id: maps[i]['id'] as int,
        defaultSearchInputMethod: maps[i]['defaultSearchInputMethod'] as String,
        scannerInputModeSearchByFields: maps[i]['scannerInputModeSearchByFields'] as String,
        keyboardInputModeSearchByFields: maps[i]['keyboardInputModeSearchByFields'] as String,
        numberOfResultsPerSearch: maps[i]['numberOfResultsPerSearch'] as int,
        trimLeadingZeros: maps[i]['trimLeadingZeros'] as int,
        obrisiArtiklePrilikomUvoza: maps[i]['obrisiArtiklePrilikomUvoza'] as int,
        csvDelimiterSimbolImport: maps[i]['csvDelimiterSimbolImport'] as String,
        restApiLinkImportArtikli: maps[i]['restApiLinkImportArtikli'] as String,
        csvDelimiterSimbolExport: maps[i]['csvDelimiterSimbolExport'] as String,
        exportDataFields: maps[i]['exportDataFields'] as String,
        izveziKaoOdvojeneDatoteke: maps[i]['izveziKaoOdvojeneDatoteke'] as int
      );
  }).first;
  }


  Future<int> update(int id, AppSettings item) async{
    final db = await init();
  
    int result = await db.update(
        "AppSettings", 
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
      );
      return result;
 }
}