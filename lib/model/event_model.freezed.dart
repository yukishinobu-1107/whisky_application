// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get eventDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get startTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get endTime => throw _privateConstructorUsedError;
  String get place => throw _privateConstructorUsedError;
  String get coverImageUrl => throw _privateConstructorUsedError;
  List<String>? get otherImageUrls => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError; // 既存の住所フィールド
  String get details => throw _privateConstructorUsedError; // 追加するイベント詳細のフィールド
  String get prefecture => throw _privateConstructorUsedError;
  String get organizer => throw _privateConstructorUsedError;
  int get eventType => throw _privateConstructorUsedError;
  String? get eventUrl => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      String name,
      @TimestampConverter() DateTime eventDate,
      @TimestampConverter() DateTime startTime,
      @TimestampConverter() DateTime endTime,
      String place,
      String coverImageUrl,
      List<String>? otherImageUrls,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted,
      String address,
      String details,
      String prefecture,
      String organizer,
      int eventType,
      String? eventUrl,
      String uid});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? place = null,
    Object? coverImageUrl = null,
    Object? otherImageUrls = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? address = null,
    Object? details = null,
    Object? prefecture = null,
    Object? organizer = null,
    Object? eventType = null,
    Object? eventUrl = freezed,
    Object? uid = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: null == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      otherImageUrls: freezed == otherImageUrls
          ? _value.otherImageUrls
          : otherImageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      prefecture: null == prefecture
          ? _value.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as String,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as int,
      eventUrl: freezed == eventUrl
          ? _value.eventUrl
          : eventUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @TimestampConverter() DateTime eventDate,
      @TimestampConverter() DateTime startTime,
      @TimestampConverter() DateTime endTime,
      String place,
      String coverImageUrl,
      List<String>? otherImageUrls,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted,
      String address,
      String details,
      String prefecture,
      String organizer,
      int eventType,
      String? eventUrl,
      String uid});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? place = null,
    Object? coverImageUrl = null,
    Object? otherImageUrls = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
    Object? address = null,
    Object? details = null,
    Object? prefecture = null,
    Object? organizer = null,
    Object? eventType = null,
    Object? eventUrl = freezed,
    Object? uid = null,
  }) {
    return _then(_$EventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: null == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      otherImageUrls: freezed == otherImageUrls
          ? _value._otherImageUrls
          : otherImageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      prefecture: null == prefecture
          ? _value.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as String,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as int,
      eventUrl: freezed == eventUrl
          ? _value.eventUrl
          : eventUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {required this.id,
      required this.name,
      @TimestampConverter() required this.eventDate,
      @TimestampConverter() required this.startTime,
      @TimestampConverter() required this.endTime,
      required this.place,
      required this.coverImageUrl,
      final List<String>? otherImageUrls,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt,
      required this.isDeleted,
      required this.address,
      required this.details,
      required this.prefecture,
      required this.organizer,
      required this.eventType,
      this.eventUrl,
      required this.uid})
      : _otherImageUrls = otherImageUrls;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @TimestampConverter()
  final DateTime eventDate;
  @override
  @TimestampConverter()
  final DateTime startTime;
  @override
  @TimestampConverter()
  final DateTime endTime;
  @override
  final String place;
  @override
  final String coverImageUrl;
  final List<String>? _otherImageUrls;
  @override
  List<String>? get otherImageUrls {
    final value = _otherImageUrls;
    if (value == null) return null;
    if (_otherImageUrls is EqualUnmodifiableListView) return _otherImageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final bool isDeleted;
  @override
  final String address;
// 既存の住所フィールド
  @override
  final String details;
// 追加するイベント詳細のフィールド
  @override
  final String prefecture;
  @override
  final String organizer;
  @override
  final int eventType;
  @override
  final String? eventUrl;
  @override
  final String uid;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, eventDate: $eventDate, startTime: $startTime, endTime: $endTime, place: $place, coverImageUrl: $coverImageUrl, otherImageUrls: $otherImageUrls, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, address: $address, details: $details, prefecture: $prefecture, organizer: $organizer, eventType: $eventType, eventUrl: $eventUrl, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._otherImageUrls, _otherImageUrls) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.prefecture, prefecture) ||
                other.prefecture == prefecture) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventUrl, eventUrl) ||
                other.eventUrl == eventUrl) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      eventDate,
      startTime,
      endTime,
      place,
      coverImageUrl,
      const DeepCollectionEquality().hash(_otherImageUrls),
      createdAt,
      updatedAt,
      isDeleted,
      address,
      details,
      prefecture,
      organizer,
      eventType,
      eventUrl,
      uid);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String id,
      required final String name,
      @TimestampConverter() required final DateTime eventDate,
      @TimestampConverter() required final DateTime startTime,
      @TimestampConverter() required final DateTime endTime,
      required final String place,
      required final String coverImageUrl,
      final List<String>? otherImageUrls,
      @TimestampConverter() required final DateTime createdAt,
      @TimestampConverter() required final DateTime updatedAt,
      required final bool isDeleted,
      required final String address,
      required final String details,
      required final String prefecture,
      required final String organizer,
      required final int eventType,
      final String? eventUrl,
      required final String uid}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @TimestampConverter()
  DateTime get eventDate;
  @override
  @TimestampConverter()
  DateTime get startTime;
  @override
  @TimestampConverter()
  DateTime get endTime;
  @override
  String get place;
  @override
  String get coverImageUrl;
  @override
  List<String>? get otherImageUrls;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  bool get isDeleted;
  @override
  String get address; // 既存の住所フィールド
  @override
  String get details; // 追加するイベント詳細のフィールド
  @override
  String get prefecture;
  @override
  String get organizer;
  @override
  int get eventType;
  @override
  String? get eventUrl;
  @override
  String get uid;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
