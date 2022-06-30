class DataImport {
  int? id;
  String? naziv;
  DateTime? datum;
  String? tipImporta;
  

  DataImport({ this.id, this.naziv, this.datum, this.tipImporta });

    Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'naziv': naziv,
      'datum': datum,
      'tipImporta': tipImporta
    };
  }
}