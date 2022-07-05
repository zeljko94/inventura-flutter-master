

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:inventura_app/models/artikl.dart';

import 'package:inventura_app/models/artikl2.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class DataImportService {
  final ArtikliService? _artikliService = ArtikliService();

  Future<List<Artikl2>?> getArtikli(context) async {
    final response = await http.get(Uri.parse('http://192.168.5.200:8888/ords/opus/artikl/barkodovi'));
    print(response.body);
    if (response.statusCode == 200) {
      try {
        Iterable iterable = json.decode(response.body);
        print(iterable);
        List<Artikl2> artikli = List<Artikl2>.from(iterable.map((model)=> Artikl2.fromJson(model)));
        return artikli;
      } catch(exception) {
        print(exception);
        return null;
      }
    } else {
      return null;
    }
  }


  Future<List<Artikl>?> getArtikliFromCsv(PlatformFile platformFile) async 
  {
    File file = File(platformFile.path!);
    // var text = latin1.decode(await file.readAsBytes());
    // file.openRead()
    //   .transform(latin1.decoder)
    //   .transform(new LineSplitter())
    //   .forEach((element) {print(element); });
    try {
     final input = File(file.path).openRead();
     final fields = await input
         .transform(latin1.decoder)
         .transform(const CsvToListConverter(fieldDelimiter: '#', eol: '\r\n'))
         .toList();
      //final headers = ['barkod', 'nesto', 'naziv', 'jmj', 'pdv'];

      var artikli = <Artikl>[];
      for(var i=0; i<fields.length; i++) {
        var pdv = num.tryParse(fields[i][4]);
        artikli.add(Artikl(
          barkod: fields[i][0].toString(), 
          kod: fields[i][1].toString(),  
          naziv: fields[i][2].toString(), 
          jedinicaMjere: fields[i][3].toString(), 
          pdv: pdv ?? 0
        ));
      }

      return artikli;
    }
    catch(exception) {
      print(exception);
      return null;
    }
  }
}