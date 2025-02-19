import '../repositories/user_ip_repository.dart';

class GetUserIpUseCase {
  final UserIpRepository repository;

  GetUserIpUseCase({required this.repository});

  Future<String> execute() async {
    return await repository.getUserIp();
  }
}