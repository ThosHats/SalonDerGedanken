// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderConfig _$ProviderConfigFromJson(Map<String, dynamic> json) =>
    ProviderConfig(
      id: json['id'] as String,
      name: json['name'] as String?,
      enabled: json['enabled'] as bool,
      module: json['module'] as String,
      updateInterval: json['update_interval'] as String,
      region: json['region'] as String?,
      params: json['params'] as Map<String, dynamic>?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProviderConfigToJson(ProviderConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enabled': instance.enabled,
      'module': instance.module,
      'update_interval': instance.updateInterval,
      'region': instance.region,
      'params': instance.params,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
