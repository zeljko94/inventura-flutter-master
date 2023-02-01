


import 'package:inventura_app/models/primke/primka.dart';
import 'package:inventura_app/services/rest/base_rest_api_service.dart';

class PrimkeRestService extends BaseRestApiService {

  Future<List<Primka>?> getPrimke() {
    return Future.delayed(Duration(seconds: 2), () {
      return [];
    });
  }
}