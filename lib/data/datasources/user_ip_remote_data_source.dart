import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_ip_model.dart';

abstract class UserIpRemoteDataSource {
  Future<UserIpModel> getUserIp();
}

class UserIpRemoteDataSourceImpl implements UserIpRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.ipify.org';

  UserIpRemoteDataSourceImpl({required this.client});

  @override
  Future<UserIpModel> getUserIp() async {
    final response = await client.get(Uri.parse('$baseUrl?format=json'));

    if (response.statusCode == 200) {
      return UserIpModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch user IP');
    }
  }
}