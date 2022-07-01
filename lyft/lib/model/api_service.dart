import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:lyft/model/constants.dart';
import 'package:lyft/model/market_model.dart';

class ApiService {
  Future<List<Bids>?> getUsers() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpointGetBids);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Bids> _model = bidsFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
