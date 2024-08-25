import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/advice_model.dart';

abstract class AdviceRemoteDatasource{
  /// requests a random advice from api
  /// returns [AdviceModel] if succesfull
  /// throw a server-Exception if status is not 200
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDatasourceImpl implements AdviceRemoteDatasource{
  final client = http.Client();
  
  @override
  Future<AdviceModel> getRandomAdviceFromApi() async{
    final response = await client.get(Uri.parse('https://api.flutter-community.com/api/v1/advice'),
    headers: {
      'content-type': 'application/json',
    },);
    final responseBody = jsonDecode(response.body);
    return AdviceModel.fromJson(responseBody);
  }

}