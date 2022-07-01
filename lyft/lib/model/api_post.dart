import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:lyft/model/constants.dart';

class ApiServicePost {
  Future<void> postInit(String priv_key, String maxBidPrice,
      String pickupLocation, String dropLocation) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpointInitPost);
      await http.post(url, body: {
        'priv_key':
            "93727907902f1ee17195a126b055b77d28eaed23eda2e54e2204612941471d7f",
        'maxBidPrice': maxBidPrice,
        'pickupLocation': pickupLocation,
        'dropLocation': dropLocation,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postBid(String priv_key, String tripID, String bid) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpointBidPost);
      await http.post(url, body: {
        'priv_key':
            "44c64e640cbe280121c65843f77514f079ca5d2910966bcd54a8f2947dec03aa",
        'tripID': tripID,
        'bid': bid,
      });
      // if (response.statusCode == 200) {
      //   List<UserModel> _model = userModelFromJson(response.body);
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postAccept(String priv_key, String tripID, String bidID) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.usersEndpointAcceptPost);
      await http.post(url, body: {
        'priv_key':
            "93727907902f1ee17195a126b055b77d28eaed23eda2e54e2204612941471d7f",
        'tripID': tripID,
        'bidID': bidID,
      });
      // if (response.statusCode == 200) {
      //   List<UserModel> _model = userModelFromJson(response.body);
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postComplete(String priv_key, String tripID) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.usersEndpointCompletePost);
      await http.post(url, body: {
        'priv_key':
            "93727907902f1ee17195a126b055b77d28eaed23eda2e54e2204612941471d7f",
        'tripID': tripID,
      });
      // if (response.statusCode == 200) {
      //   List<UserModel> _model = userModelFromJson(response.body);
      // }
    } catch (e) {
      log(e.toString());
    }
  }
}
