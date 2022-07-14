import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:inventura_app/common/snackbar.service.dart';
import 'package:inventura_app/models/app_settings.dart';
import 'package:inventura_app/models/list_item.dart';
import 'package:inventura_app/services/sqlite/app_settings_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class DataExportService {
  final AppSettingsService _appSettingsService = AppSettingsService();
  AppSettings? _settings;

  Future<String?> getDownloadPath() async {
      Directory? directory;
      try {
        if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) directory = await getExternalStorageDirectory();
        }
      } catch (err, stack) {
        print("Cannot get download folder path");
      }
      return directory?.path;
    }

  Future<bool> exportCsv(List<ListItem> items, String filename, BuildContext context) async {
    try {
      _settings = await _appSettingsService.getSettings();

      List<List<dynamic>> rows = [];
      for (int i = 0; i < items.length; i++) {
        List<dynamic> row = [];
        var columnsFromSettins = _settings!.exportDataFields!.split(',').toList();

        
        if(columnsFromSettins.contains('naziv'))
          row.add(items[i].nazivArtikla);
        if(columnsFromSettins.contains('barkod'))
          row.add(items[i].barkod);
        if(columnsFromSettins.contains('šifra'))
          row.add(items[i].kod);
        if(columnsFromSettins.contains('količina'))
          row.add(items[i].kolicina);
        if(columnsFromSettins.contains('jedinica mjere'))
          row.add(items[i].jedinicaMjere);

        rows.add(row);
      }
      if (!await Permission.storage.request().isGranted) {
        print("STORAGE PERMISSION NOT GRANTED!");
        return false;
      }

      String? dir = await getDownloadPath();
      if(dir == null) return false;

      String file = "$dir";
      File f = File(file + "/" + filename + ".csv");
      SnackbarService.show(file + "/" + filename + ".csv", context);
      String csv = ListToCsvConverter(fieldDelimiter: _settings!.csvDelimiterSimbolExport!, eol: '\r\n').convert(rows);
      f.writeAsString(csv);
      return true;
    } 
    catch(exception) {
      print("EXCEPTION");
      print(exception);
      return false;
    }
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

      String? path = await getDownloadPath();
      if(path == null) return false;
      
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

  
  Future<void> _openFile(String path) async {
    final _result = await OpenFile.open(path);
  }
}