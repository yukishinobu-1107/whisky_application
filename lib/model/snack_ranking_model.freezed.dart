// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snack_ranking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SnackRankingModel _$SnackRankingModelFromJson(Map<String, dynamic> json) {
  return _SnackRankingModel.fromJson(json);
}

/// @nodoc
mixin _$SnackRankingModel {
  String? get id => throw _privateConstructorUsedError; // FirestoreのドキュメントID
  int get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get like => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this SnackRankingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SnackRankingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnackRankingModelCopyWith<SnackRankingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnackRankingModelCopyWith<$Res> {
  factory $SnackRankingModelCopyWith(
          SnackRankingModel value, $Res Function(SnackRankingModel) then) =
      _$SnackRankingModelCopyWithImpl<$Res, SnackRankingModel>;
  @useResult
  $Res call(
      {String? id,
      int categoryId,
      String name,
      int like,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted});
}

/// @nodoc
class _$SnackRankingModelCopyWithImpl<$Res, $Val extends SnackRankingModel>
    implements $SnackRankingModelCopyWith<$Res> {
  _$SnackRankingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnackRankingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? categoryId = null,
    Object? name = null,
    Object? like = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      like: null == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SnackRankingModelImplCopyWith<$Res>
    implements $SnackRankingModelCopyWith<$Res> {
  factory _$$SnackRankingModelImplCopyWith(_$SnackRankingModelImpl value,
          $Res Function(_$SnackRankingModelImpl) then) =
      __$$SnackRankingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      int categoryId,
      String name,
      int like,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$SnackRankingModelImplCopyWithImpl<$Res>
    extends _$SnackRankingModelCopyWithImpl<$Res, _$SnackRankingModelImpl>
    implements _$$SnackRankingModelImplCopyWith<$Res> {
  __$$SnackRankingModelImplCopyWithImpl(_$SnackRankingModelImpl _value,
      $Res Function(_$SnackRankingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SnackRankingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? categoryId = null,
    Object? name = null,
    Object? like = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_$SnackRankingModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      like: null == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SnackRankingModelImpl implements _SnackRankingModel {
  _$SnackRankingModelImpl(
      {this.id,
      required this.categoryId,
      required this.name,
      required this.like,
      required this.createdBy,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt,
      required this.isDeleted});

  factory _$SnackRankingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnackRankingModelImplFromJson(json);

  @override
  final String? id;
// FirestoreのドキュメントID
  @override
  final int categoryId;
  @override
  final String name;
  @override
  final int like;
  @override
  final String createdBy;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final bool isDeleted;

  @override
  String toString() {
    return 'SnackRankingModel(id: $id, categoryId: $categoryId, name: $name, like: $like, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnackRankingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.like, like) || other.like == like) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, name, like,
      createdBy, createdAt, updatedAt, isDeleted);

  /// Create a copy of SnackRankingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnackRankingModelImplCopyWith<_$SnackRankingModelImpl> get copyWith =>
      __$$SnackRankingModelImplCopyWithImpl<_$SnackRankingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnackRankingModelImplToJson(
      this,
    );
  }
}

abstract class _SnackRankingModel implements SnackRankingModel {
  factory _SnackRankingModel(
      {final String? id,
      required final int categoryId,
      required final String name,
      required final int like,
      required final String createdBy,
      @TimestampConverter() required final DateTime createdAt,
      @TimestampConverter() required final DateTime updatedAt,
      required final bool isDeleted}) = _$SnackRankingModelImpl;

  factory _SnackRankingModel.fromJson(Map<String, dynamic> json) =
      _$SnackRankingModelImpl.fromJson;

  @override
  String? get id; // FirestoreのドキュメントID
  @override
  int get categoryId;
  @override
  String get name;
  @override
  int get like;
  @override
  String get createdBy;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  bool get isDeleted;

  /// Create a copy of SnackRankingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnackRankingModelImplCopyWith<_$SnackRankingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
