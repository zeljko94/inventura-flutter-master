

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/services/sqlite/artikli_service.dart';

class DataImportService {
  final ArtikliService? _artikliService = ArtikliService();

  Future<List<Artikl>?> getArtikliFromRestApi(context) async {
    final response = await http.get(Uri.parse('http://192.168.5.200:8888/ords/opus/artikl/barkodovi'));
    if (response.statusCode == 200) {
      try {
        var jsonresponse = jsonDecode(utf8.decode(response.bodyBytes));
        jsonresponse = jsonresponse["Artikli"];
        var artikli = <Artikl>[];
        for(var i=0; i<jsonresponse.length; i++) {
          var barkodovi = jsonresponse[i]["BARKODOVI"] ?? [];
          for(var j=0; j<barkodovi.length; j++) {
            artikli.add(Artikl( naziv: jsonresponse[i]["NAZIV"], kod: jsonresponse[i]["SIFRA"], jedinicaMjere: jsonresponse[i]["JMJ"], barkod: barkodovi[j]['BARKOD'].toString()));
          }
        }
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

    try {
     final input = File(file.path).openRead();

     final fields = await input
         .transform(utf8.decoder)
         .transform(const CsvToListConverter(fieldDelimiter: '#', eol: '\r\n'))
         .toList();
      //final headers = ['sifra', 'naziv', 'barkod', 'jedinicaMjere', 'pdv', 'cijena'];

      var artikli = <Artikl>[];
      for(var i=0; i<fields.length; i++) {
        var pdv = num.tryParse(fields[i][4].toString().replaceAll(',', '.'));
        var cijena = num.tryParse(fields[i][5].toString().replaceAll(',', '.'));
        artikli.add(Artikl(
          kod: fields[i][0].toString(),  
          naziv: fields[i][1].toString(), 
          barkod: fields[i][2].toString(), 
          jedinicaMjere: fields[i][3].toString(), 
          pdv: pdv ?? 0,
          cijena: cijena ?? 0
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