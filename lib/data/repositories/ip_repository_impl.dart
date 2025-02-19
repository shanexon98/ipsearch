import 'package:ip_query_app/data/datasources/ip_remote_data_source.dart';
import 'package:ip_query_app/domain/entities/ip_info.dart';
import 'package:ip_query_app/domain/repositories/ip_repository.dart';

class IpRepositoryImpl implements IpRepository {
  final IpRemoteDataSource remoteDataSource;

  IpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<IpInfo> getIpInfo(String ip) async {
    return await remoteDataSource.getIpInfo(ip);
  }
}