import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'dart:io';
import 'dart:async';



class SqliteBaseService {
    Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"inventura.db"); //create path to database

      return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db,int version) async{
        await db.execute("""
          CREATE TABLE Artikli(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barkod TEXT,
            naziv TEXT,
            kod TEXT,
            cijena NUMERIC(16,4),
            predefiniranaKolicina NUMERIC(16,4),
            napomena TEXT,
            jedinicaMjere TEXT,
            pdv NUMERIC(16,4)
          )
          """
      );

      await db.execute("""
        CREATE TABLE Liste(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          naziv TEXT,
          napomena TEXT,
          skladiste TEXT,
          datumKreiranja TEXT
        )"""
      );

      await db.execute("""
        CREATE TABLE ListItems(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          listaId INTEGER,
          artiklId INTEGER,
          barkod TEXT,
          naziv TEXT,
          kod TEXT,
          cijena NUMERIC(16,4),
          kolicina NUMERIC(16,4),
          nazivArtikla TEXT,
          jedinicaMjere TEXT
        );
      """);


      await db.execute("""
        CREATE TABLE Primke(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          naziv TEXT,
          napomena TEXT,
          skladiste TEXT,
          datumKreiranja TEXT
        )"""
      );

      await db.execute("""
        CREATE TABLE AppSettings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,

          odabranoSkladiste TEXT,

          defaultSearchInputMethod TEXT,
          scannerInputModeSearchByFields TEXT,
          keyboardInputModeSearchByFields TEXT,
          numberOfResultsPerSearch INTEGER,

          trimLeadingZeros INT,
          obrisiArtiklePrilikomUvoza INT,
          csvDelimiterSimbolImport TEXT,
          restApiLinkImportArtikli TEXT,

          csvDelimiterSimbolExport TEXT,
          exportDataFields TEXT,
          izveziKaoOdvojeneDatoteke INTEGER,
          defaultImportMethod TEXT
        );
      """);

      
      // INSERT INITIAL DATA
      await db.execute("""
        INSERT INTO AppSettings(id, defaultSearchInputMethod, scannerInputModeSearchByFields, keyboardInputModeSearchByFields, numberOfResultsPerSearch, trimLeadingZeros, obrisiArtiklePrilikomUvoza, csvDelimiterSimbolImport, restApiLinkImportArtikli, csvDelimiterSimbolExport, exportDataFields, izveziKaoOdvojeneDatoteke, defaultImportMethod, odabranoSkladiste) 
        VALUES(1, 'scanner', 'barkod, sifra, naziv', 'barkod, sifra, naziv', 20, 0, 1, '#', 'http://192.168.5.200:8888/ords/opus/artikl/barkodovi', '#', 'barkod, sifra, naziv', 1, 'rest api', 'Skladiste 1')
      """);
      
    });
  }
}