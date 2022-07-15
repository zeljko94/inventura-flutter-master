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
      items.sort((a, b) => b.id!.compareTo(a.id!));

      List<List<dynamic>> rows = [];
      var columnsFromSettins = _settings!.exportDataFields!.split(',').toList();
    
      for (int i = 0; i < items.length; i++) {
        List<dynamic> row = [];

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

      print("OPEN FILE: " + file + "/" + filename + ".csv");
      await _openFile(file + "/" + filename + ".csv");
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
      _settings = await _appSettingsService.getSettings();
      var columnsFromSettings = _settings!.exportDataFields!.split(',').toList();
      items.sort((a, b) => b.id!.compareTo(a.id!));

      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      var columnMappings = <String, String> {};
      var columnIndex = 65;
      if(columnsFromSettings.contains('barkod')) {
        sheet.getRangeByName(String.fromCharCode(columnIndex) + '1').setText('Barkod');
        columnMappings["barkod"] = String.fromCharCode(columnIndex);
        columnIndex++;
      }

      if(columnsFromSettings.contains('šifra')) {
        sheet.getRangeByName(String.fromCharCode(columnIndex) + '1').setText('Šifra');
        columnMappings["kod"] = String.fromCharCode(columnIndex);
        columnIndex++;
      }

      if(columnsFromSettings.contains('količina')) {
        sheet.getRangeByName(String.fromCharCode(columnIndex) + '1').setText('Količina');
        columnMappings["kolicina"] = String.fromCharCode(columnIndex);
        columnIndex++;
      }

      if(columnsFromSettings.contains('naziv')) {
        sheet.getRangeByName(String.fromCharCode(columnIndex) + '1').setText('Naziv');
        columnMappings["naziv"] = String.fromCharCode(columnIndex);
        columnIndex++;
      }

      if(columnsFromSettings.contains('jedinica mjere')) {
        sheet.getRangeByName(String.fromCharCode(columnIndex) + '1').setText('Jedinica mjere');
        columnMappings["jedinicaMjere"] = String.fromCharCode(columnIndex);
        columnIndex++;
      }

      

      for(var i=0; i<items.length; i++) {
        if(columnMappings["barkod"] != null) sheet.getRangeByName(columnMappings["barkod"]! + (i+2).toString()).setText(items[i].barkod);
        if(columnMappings["kod"] != null) sheet.getRangeByName(columnMappings["kod"]! + (i+2).toString()).setText(items[i].kod);
        if(columnMappings["kolicina"] != null) sheet.getRangeByName(columnMappings["kolicina"]! + (i+2).toString()).setText(items[i].kolicina.toString());
        if(columnMappings["naziv"] != null) sheet.getRangeByName(columnMappings["naziv"]! + (i+2).toString()).setText(items[i].naziv.toString());
        if(columnMappings["jedinicaMjere"] != null) sheet.getRangeByName(columnMappings["jedinicaMjere"]! + (i+2).toString()).setText(items[i].jedinicaMjere.toString());
      }
      
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      String? path = await getDownloadPath();
      if(path == null) return false;
      
      File file = File('$path/$filename.xlsx');
      await file.writeAsBytes(bytes, flush: true);
      await _openFile('$path/$filename.xlsx');
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