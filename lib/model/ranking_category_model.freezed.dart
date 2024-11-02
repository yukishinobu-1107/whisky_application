// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RankingCategory _$RankingCategoryFromJson(Map<String, dynamic> json) {
  return _RankingCategory.fromJson(json);
}

/// @nodoc
mixin _$RankingCategory {
  String get name => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this RankingCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingCategoryCopyWith<RankingCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingCategoryCopyWith<$Res> {
  factory $RankingCategoryCopyWith(
          RankingCategory value, $Res Function(RankingCategory) then) =
      _$RankingCategoryCopyWithImpl<$Res, RankingCategory>;
  @useResult
  $Res call(
      {String name,
      int categoryId,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted});
}

/// @nodoc
class _$RankingCategoryCopyWithImpl<$Res, $Val extends RankingCategory>
    implements $RankingCategoryCopyWith<$Res> {
  _$RankingCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$RankingCategoryImplCopyWith<$Res>
    implements $RankingCategoryCopyWith<$Res> {
  factory _$$RankingCategoryImplCopyWith(_$RankingCategoryImpl value,
          $Res Function(_$RankingCategoryImpl) then) =
      __$$RankingCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int categoryId,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$RankingCategoryImplCopyWithImpl<$Res>
    extends _$RankingCategoryCopyWithImpl<$Res, _$RankingCategoryImpl>
    implements _$$RankingCategoryImplCopyWith<$Res> {
  __$$RankingCategoryImplCopyWithImpl(
      _$RankingCategoryImpl _value, $Res Function(_$RankingCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of RankingCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDeleted = null,
  }) {
    return _then(_$RankingCategoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$RankingCategoryImpl implements _RankingCategory {
  _$RankingCategoryImpl(
      {required this.name,
      required this.categoryId,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt,
      required this.isDeleted});

  factory _$RankingCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingCategoryImplFromJson(json);

  @override
  final String name;
  @override
  final int categoryId;
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
    return 'RankingCategory(name: $name, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingCategoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, categoryId, createdAt, updatedAt, isDeleted);

  /// Create a copy of RankingCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingCategoryImplCopyWith<_$RankingCategoryImpl> get copyWith =>
      __$$RankingCategoryImplCopyWithImpl<_$RankingCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingCategoryImplToJson(
      this,
    );
  }
}

abstract class _RankingCategory implements RankingCategory {
  factory _RankingCategory(
      {required final String name,
      required final int categoryId,
      @TimestampConverter() required final DateTime createdAt,
      @TimestampConverter() required final DateTime updatedAt,
      required final bool isDeleted}) = _$RankingCategoryImpl;

  factory _RankingCategory.fromJson(Map<String, dynamic> json) =
      _$RankingCategoryImpl.fromJson;

  @override
  String get name;
  @override
  int get categoryId;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  bool get isDeleted;

  /// Create a copy of RankingCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingCategoryImplCopyWith<_$RankingCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
