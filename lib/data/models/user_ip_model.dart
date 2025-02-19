class UserIpModel {
  final String ip;

  UserIpModel({required this.ip});

  factory UserIpModel.fromJson(Map<String, dynamic> json) {
    return UserIpModel(
      ip: json['ip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
    };
  }
}