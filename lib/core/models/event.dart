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
  final String description;

  @HiveField(3)
  final String? longDescription;

  @HiveField(4)
  final DateTime startDateTime;

  @HiveField(5)
  final DateTime? endDateTime;

  @HiveField(6)
  final bool isMultiDay;

  @HiveField(7)
  final String? openingHours;

  @HiveField(8)
  final bool isFree;

  @HiveField(9)
  final String? priceText;

  @HiveField(10)
  final String providerId;

  @HiveField(11)
  final String? locationName;

  @HiveField(12)
  final String? address;

  @HiveField(13)
  final String url;

  @HiveField(14)
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
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
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
