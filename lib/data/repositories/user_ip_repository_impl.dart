import 'package:ip_query_app/data/datasources/user_ip_remote_data_source.dart';
import 'package:ip_query_app/domain/repositories/user_ip_repository.dart';

class UserIpRepositoryImpl implements UserIpRepository {
  final UserIpRemoteDataSource remoteDataSource;

  UserIpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getUserIp() async {
    final userIpModel = await remoteDataSource.getUserIp();
    return userIpModel.ip;
  }
}