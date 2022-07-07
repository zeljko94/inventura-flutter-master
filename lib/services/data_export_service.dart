

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DataExportService {

  Future<void> _openFile(String path) async {
    final _result = await OpenFile.open(path);
    print(_result.message);

  }

  Future<bool> exportCsv(List<ListItem> items, String filename) async {
    try {
      List<List<dynamic>> rows = [];
      for (int i = 0; i < items.length; i++) {
        List<dynamic> row = [];
        row.add(items[i].barkod);
        row.add(items[i].kolicina);
        rows.add(row);
      }
      if (!await Permission.storage.request().isGranted) {
        print("STORAGE PERMISSION NOT GRANTED!");
        return false;
      }
      String dir =
          (Platform.isAndroid ? (await getExternalStorageDirectory())!.path : (await getApplicationSupportDirectory()).path);
      String file = "$dir";
      File f = File(file + "/" + filename + ".csv");
      print("IZVOZ PODATAKA CSV" + f.path);
      String csv = const ListToCsvConverter(fieldDelimiter: '#', eol: '\r\n').convert(rows);
      f.writeAsString(csv);
      return true;
    } 
    catch(exception) {
      print(exception);
      return false;
    }
  }
  

  // Future<bool> exportExcel(List<ListItem> items, String filename) async {    
  //   try {
  //     var excel = Excel.createExcel();
  //     if (!await Permission.storage.request().isGranted) {
  //       print("STORAGE PERMISSION NOT GRANTED!");
  //       return false;
  //     }
  //     String dir =
  //         (Platform.isAndroid ? (await getExternalStorageDirectory())!.path : (await getApplicationSupportDirectory()).path);
  //     String file = "$dir";
  //     File f = File(file + "/" + filename + ".xlsx");
  //     print("IZVOZ PODATAKA EXCEL" + f.path);
  //     await f.writeAsBytes(await excel.encode());
  //     return true;
  //   }
  //   catch(exception) {
  //     print(exception);
  //     return false;
  //   }
  // }
  
  Future<bool> exportRestApi(List<ListItem> items) async {
    return Future.delayed(Duration.zero, () async {
      return false;
    });
  }
}