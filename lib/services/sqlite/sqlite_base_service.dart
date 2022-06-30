import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'dart:io';
import 'dart:async';



class SqliteBaseService {
    Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"inventura.db"); //create path to database

      return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
            CREATE TABLE MjerneJedinice(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              opis TEXT,
              naziv TEXT
            )"""
          );

          await db.execute("""
          CREATE TABLE Artikli(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barkod TEXT,
            naziv TEXT,
            kod TEXT,
            cijena NUMERIC(16,4),
            mjernaJedinicaId INTEGER,
            predefiniranaKolicina NUMERIC(16,4),
            napomena TEXT
          )
          """
      );

      await db.execute("""
        CREATE TABLE Liste(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          naziv TEXT,
          napomena TEXT,
          skladiste TEXT
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
          kolicina NUMERIC(16,4)
        );
      """);

      
      // INSERT INITIAL DATA
      await db.execute("""
        INSERT INTO MjerneJedinice(id, opis, naziv) VALUES(1, 'Komad', 'komad'),(2, 'Kg', 'kilogram'),(3, 'L', 'litar')
      """);

      await db.execute("""
        INSERT INTO Artikli(id, barkod, naziv, kod, cijena, napomena, predefiniranaKolicina, mjernaJedinicaId) 
        VALUES(1, '1111-barkod', 'Marlboro red', '1111-kod', 6, 'Napomena', 0, 1),(2, '2222-barkod', 'Marlboro lights', '2222-kod', 6, 'Napomena', 0, 1),(3, '3333-barkod', 'Banane', '3333-kod', 2, 'Napomena', 0, 2),(4, '4444-barkod', 'Coca Cola', '4444-kod', 1, 'Napomena', 0, 3)
      """);

      await db.execute("""
        INSERT INTO Liste(id, naziv, napomena, skladiste) VALUES(1, 'Lista 1', 'Napomena', 'Skladiste 1'),(2, 'Lista 2', 'Napomena', 'Skladiste 2')
      """);
    });
  }
}