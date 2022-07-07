
class AppSettings {
  int? id;
  String? defaultSearchInputMethod;
  String? scannerInputModeSearchByFields;
  String? keyboardInputModeSearchByFields;
  int? numberOfResultsPerSearch;

  int? trimLeadingZeros;
  int? obrisiArtiklePrilikomUvoza;
  String? csvDelimiterSimbol;
  String? restApiLinkImportArtikli;

  AppSettings({ this.id, this.defaultSearchInputMethod, this.scannerInputModeSearchByFields, this.keyboardInputModeSearchByFields, this.numberOfResultsPerSearch, 
  this.trimLeadingZeros, this.obrisiArtiklePrilikomUvoza, this.csvDelimiterSimbol, this.restApiLinkImportArtikli });

  
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'defaultSearchInputMethod': defaultSearchInputMethod,
      'scannerInputModeSearchByFields': scannerInputModeSearchByFields,
      'keyboardInputModeSearchByFields': keyboardInputModeSearchByFields,
      'numberOfResultsPerSearch': numberOfResultsPerSearch,
      'trimLeadingZeros': trimLeadingZeros,
      'obrisiArtiklePrilikomUvoza': obrisiArtiklePrilikomUvoza,
      'csvDelimiterSimbol': csvDelimiterSimbol,
      'restApiLinkImportArtikli': restApiLinkImportArtikli,
    };
  }
}