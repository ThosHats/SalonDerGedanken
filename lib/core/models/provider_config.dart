import 'package:json_annotation/json_annotation.dart';

part 'provider_config.g.dart';

@JsonSerializable()
class ProviderConfig {
  final String id;
  final String? name;
  final bool enabled;
  final String module;
  
  @JsonKey(name: 'update_interval')
  final String updateInterval;
  
  final String? region;
  final Map<String, dynamic>? params;
  final String? address;
  final double? latitude;
  final double? longitude;

  ProviderConfig({
    required this.id,
    this.name,
    required this.enabled,
    required this.module,
    required this.updateInterval,
    this.region,
    this.params,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory ProviderConfig.fromJson(Map<String, dynamic> json) => _$ProviderConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderConfigToJson(this);
}
