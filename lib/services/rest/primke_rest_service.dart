


import 'package:inventura_app/models/primke/primka.dart';
import 'package:inventura_app/services/rest/base_rest_api_service.dart';

class PrimkeRestService extends BaseRestApiService {

  Future<List<Primka>?> getPrimke() {
    return Future.delayed(Duration(milliseconds: 600), () {
      return [
        Primka(id: 1, naziv: "Primka 1", napomena: "Napomena 1", skladiste: "Skladiste 1", items: [], datumKreiranja: DateTime.now().toString(), isFinished: false),
        Primka(id: 2, naziv: "Primka 2", napomena: "Napomena 2", skladiste: "Skladiste 2", items: [], datumKreiranja: DateTime.now().subtract(Duration(days: 1)).toString(), isFinished: false),
        Primka(id: 3, naziv: "Primka 3", napomena: "Napomena 3", skladiste: "Skladiste 3", items: [], datumKreiranja: DateTime.now().subtract(Duration(days: 2)).toString(), isFinished: false),
        Primka(id: 4, naziv: "Primka 4", napomena: "Napomena 4", skladiste: "Skladiste 4", items: [], datumKreiranja: DateTime.now().subtract(Duration(days: 3)).toString(), isFinished: false),
        Primka(id: 5, naziv: "Primka 5", napomena: "Napomena 5", skladiste: "Skladiste 5", items: [], datumKreiranja: DateTime.now().subtract(Duration(days: 4)).toString(), isFinished: false),
      ];
    });
  }
}