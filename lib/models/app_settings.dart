
class AppSettings {
  int? id;

  String? odabranoSkladiste;

  String? defaultSearchInputMethod;
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;

  String? defaultImportMethod;
  int? trimLeadingZeros;
  int? obrisiArtiklePrilikomUvoza;
  String? csvDelimiterSimbolImport;
  String? restApiLinkImportArtikli;

  String? csvDelimiterSimbolExport;
  String? exportDataFields;
  int? izveziKaoOdvojeneDatoteke;

  AppSettings({ this.id, this.defaultSearchInputMethod, this.scannerInputModeSearchByFields, this.keyboardInputModeSearchByFields, this.numberOfResultsPerSearch, 
  this.trimLeadingZeros, this.obrisiArtiklePrilikomUvoza, this.csvDelimiterSimbolImport, this.restApiLinkImportArtikli, this.csvDelimiterSimbolExport, this.exportDataFields, this.izveziKaoOdvojeneDatoteke, this.defaultImportMethod, this.odabranoSkladiste });

  
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
      'exportDataFields': exportDataFields,
      'izveziKaoOdvojeneDatoteke': izveziKaoOdvojeneDatoteke,
      'defaultImportMethod': defaultImportMethod,
      'odabranoSkladiste': odabranoSkladiste,
    };
  }
}