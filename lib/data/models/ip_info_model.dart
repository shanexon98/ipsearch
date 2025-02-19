import '../../domain/entities/ip_info.dart';

class IpInfoModel extends IpInfo {
  IpInfoModel({
    required String ip,
    required String city,
    required String region,
    required String country,
    required String loc,
    required String org,
    required String postal,
    required String timezone,
  }) : super(
          ip: ip,
          city: city,
          region: region,
          country: country,
          loc: loc,
          org: org,
          postal: postal,
          timezone: timezone,
        );

  factory IpInfoModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final isp = json['isp'] as Map<String, dynamic>? ?? {};
    
    return IpInfoModel(
      ip: json['ip'] ?? '',
      city: location['city'] ?? '',
      region: location['state'] ?? '',
      country: location['country'] ?? '',
      loc: '${location['latitude'] ?? ''}, ${location['longitude'] ?? ''}',
      org: isp['org'] ?? '',
      postal: location['zipcode'] ?? '',
      timezone: location['timezone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'city': city,
      'region': region,
      'country': country,
      'loc': loc,
      'org': org,
      'postal': postal,
      'timezone': timezone,
    };
  }
}