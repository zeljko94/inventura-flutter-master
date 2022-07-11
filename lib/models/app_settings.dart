
class AppSettings {
  int? id;
  String? defaultSearchInputMethod;
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;

  int? trimLeadingZeros;
  int? obrisiArtiklePrilikomUvoza;
  String? csvDelimiterSimbolImport;
  String? restApiLinkImportArtikli;

  String? csvDelimiterSimbolExport;
  String? exportDataFields;

  AppSettings({ this.id, this.defaultSearchInputMethod, this.scannerInputModeSearchByFields, this.keyboardInputModeSearchByFields, this.numberOfResultsPerSearch, 
  this.trimLeadingZeros, this.obrisiArtiklePrilikomUvoza, this.csvDelimiterSimbolImport, this.restApiLinkImportArtikli, this.csvDelimiterSimbolExport, this.exportDataFields });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'defaultSearchInputMethod': defaultSearchInputMethod,
      'scannerInputModeSearchByFields': scannerInputModeSearchByFields,
      'keyboardInputModeSearchByFields': keyboardInputModeSearchByFields,
      'numberOfResultsPerSearch': numberOfResultsPerSearch,
      'trimLeadingZeros': trimLeadingZeros,
      'obrisiArtiklePrilikomUvoza': obrisiArtiklePrilikomUvoza,
      'csvDelimiterSimbolImport': csvDelimiterSimbolImport,
      'restApiLinkImportArtikli': restApiLinkImportArtikli,
      'csvDelimiterSimbolExport': csvDelimiterSimbolExport,
      'exportDataFields': exportDataFields
    };
  }
}