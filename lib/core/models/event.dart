import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? longDescription;

  @JsonKey(name: 'start_date')
  @HiveField(4)
  final DateTime startDateTime;

  @JsonKey(name: 'end_date')
  @HiveField(5)
  final DateTime? endDateTime;

  @HiveField(6)
  final bool isMultiDay;

  @HiveField(7)
  final String? openingHours;

  @HiveField(8)
  final bool isFree;

  @JsonKey(name: 'cost')
  @HiveField(9)
  final String? priceText;

  @JsonKey(name: 'provider_id')
  @HiveField(10)
  final String providerId;

  @HiveField(11)
  final String? locationName;

  @JsonKey(name: 'location')
  @HiveField(12)
  final String? address;

  @JsonKey(name: 'source_url')
  @HiveField(13)
  final String url;

  @HiveField(14)
  final String? imageUrl;
  
  @HiveField(15)
  @JsonKey(name: 'region')
  final String? region;
  
  @HiveField(16)
  @JsonKey(name: 'latitude')
  final double? latitude;
  
  @HiveField(17)
  @JsonKey(name: 'longitude')
  final double? longitude;

  Event({
    required this.id,
    required this.title,
    this.description,
    this.longDescription,
    required this.startDateTime,
    this.endDateTime,
    this.isMultiDay = false,
    this.openingHours,
    this.isFree = false,
    this.priceText,
    required this.providerId,
    this.locationName,
    this.address,
    required this.url,
    this.imageUrl,
    this.region,
    this.latitude,
    this.longitude,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
