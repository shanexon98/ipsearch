import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ip_info_model.dart';

abstract class IpRemoteDataSource {
  Future<IpInfoModel> getIpInfo(String ip);
}

class IpRemoteDataSourceImpl implements IpRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.ipquery.io';

  IpRemoteDataSourceImpl({required this.client});

  @override
  Future<IpInfoModel> getIpInfo(String ip) async {
    final response = await client.get(Uri.parse('$baseUrl/$ip'));

    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
      final model = IpInfoModel.fromJson(json.decode(response.body));
      print('Parsed Model: ${model.toJson()}');
      return model;
    } else {
      throw Exception('Failed to load IP info');
    }
  }
}