import 'package:inventura_app/models/artikl.dart';
import 'package:inventura_app/services/rest/base_rest_api_service.dart';

class ArtikliRestService extends BaseRestApiService {

  Future<List<Artikl>?> getArtikli() {
    return Future.delayed(Duration(seconds: 2), () async {
      return [];
    });
  }
}