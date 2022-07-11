

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class DataExportService {

  static const String ANDROID_DOWNLOAD_PATH = '/storage/emulated/0/Download';

  Future<void> _openFile(String path) async {
    final _result = await OpenFile.open(path);

  }

  Future<bool> exportCsv(List<ListItem> items, String filename) async {
    try {
      List<List<dynamic>> rows = [];
      for (int i = 0; i < items.length; i++) {
        List<dynamic> row = [];
        row.add(items[i].barkod);
        // row.add(items[i].kod);
        row.add(items[i].kolicina);
        rows.add(row);
      }
      if (!await Permission.storage.request().isGranted) {
        print("STORAGE PERMISSION NOT GRANTED!");
        return false;
      }
      String androidDownloadsDir = ANDROID_DOWNLOAD_PATH;
      String dir = (Platform.isAndroid ? androidDownloadsDir /*(await getExternalStorageDirectory())!.path*/ : (await getApplicationSupportDirectory()).path);
      String file = "$dir";
      File f = File(file + "/" + filename + ".csv");
      print("IZVOZ PODATAKA CSV  " + f.path);
      String csv = const ListToCsvConverter(fieldDelimiter: '#', eol: '\r\n').convert(rows);
      f.writeAsString(csv);
      return true;
    } 
    catch(exception) {
      print(exception);
      return false;
    }
  }
  
  Future<void> excelTest() async {    
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    const String path = ANDROID_DOWNLOAD_PATH;
    String filename = '$path/Output.xlsx';
    File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);

  }

  Future<bool> exportExcel(List<ListItem> items, String filename) async {    
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Barkod');
      sheet.getRangeByName('B1').setText('Šifra');
      sheet.getRangeByName('C1').setText('Količina');

      for(var i=0; i<items.length; i++) {
        sheet.getRangeByName('A' + (i+2).toString()).setText(items[i].barkod);
        sheet.getRangeByName('B' + (i+2).toString()).setText(items[i].kod);
        sheet.getRangeByName('C' + (i+2).toString()).setText(items[i].kolicina.toString());
      }
      
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      const String path = ANDROID_DOWNLOAD_PATH;
      File file = File('$path/$filename.xlsx');
      await file.writeAsBytes(bytes, flush: true);
      return true;
    }
    catch(exception) {
      print(exception);
      return false;
    }
  }
  
  Future<bool> exportRestApi(List<ListItem> items) async {
    return Future.delayed(Duration.zero, () async {
      return false;
    });
  }
}