import '../entities/ip_info.dart';

abstract class IpRepository {
  Future<IpInfo> getIpInfo(String ip);
}