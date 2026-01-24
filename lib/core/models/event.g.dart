// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      longDescription: fields[3] as String?,
      startDateTime: fields[4] as DateTime,
      endDateTime: fields[5] as DateTime?,
      isMultiDay: fields[6] as bool,
      openingHours: fields[7] as String?,
      isFree: fields[8] as bool,
      priceText: fields[9] as String?,
      providerId: fields[10] as String,
      locationName: fields[11] as String?,
      address: fields[12] as String?,
      url: fields[13] as String,
      imageUrl: fields[14] as String?,
      region: fields[15] as String?,
      latitude: fields[16] as double?,
      longitude: fields[17] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.longDescription)
      ..writeByte(4)
      ..write(obj.startDateTime)
      ..writeByte(5)
      ..write(obj.endDateTime)
      ..writeByte(6)
      ..write(obj.isMultiDay)
      ..writeByte(7)
      ..write(obj.openingHours)
      ..writeByte(8)
      ..write(obj.isFree)
      ..writeByte(9)
      ..write(obj.priceText)
      ..writeByte(10)
      ..write(obj.providerId)
      ..writeByte(11)
      ..write(obj.locationName)
      ..writeByte(12)
      ..write(obj.address)
      ..writeByte(13)
      ..write(obj.url)
      ..writeByte(14)
      ..write(obj.imageUrl)
      ..writeByte(15)
      ..write(obj.region)
      ..writeByte(16)
      ..write(obj.latitude)
      ..writeByte(17)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      longDescription: json['longDescription'] as String?,
      startDateTime: DateTime.parse(json['start_date'] as String),
      endDateTime: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isMultiDay: json['isMultiDay'] as bool? ?? false,
      openingHours: json['openingHours'] as String?,
      isFree: json['isFree'] as bool? ?? false,
      priceText: json['cost'] as String?,
      providerId: json['provider_id'] as String,
      locationName: json['locationName'] as String?,
      address: json['location'] as String?,
      url: json['source_url'] as String,
      imageUrl: json['imageUrl'] as String?,
      region: json['region'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'longDescription': instance.longDescription,
      'start_date': instance.startDateTime.toIso8601String(),
      'end_date': instance.endDateTime?.toIso8601String(),
      'isMultiDay': instance.isMultiDay,
      'openingHours': instance.openingHours,
      'isFree': instance.isFree,
      'cost': instance.priceText,
      'provider_id': instance.providerId,
      'locationName': instance.locationName,
      'location': instance.address,
      'source_url': instance.url,
      'imageUrl': instance.imageUrl,
      'region': instance.region,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
