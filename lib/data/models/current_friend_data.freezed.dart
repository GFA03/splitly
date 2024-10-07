// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_friend_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrentFriendData {
  List<FriendProfile> get currentFriends => throw _privateConstructorUsedError;
  List<Expense> get currentExpenses => throw _privateConstructorUsedError;

  /// Create a copy of CurrentFriendData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentFriendDataCopyWith<CurrentFriendData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentFriendDataCopyWith<$Res> {
  factory $CurrentFriendDataCopyWith(
          CurrentFriendData value, $Res Function(CurrentFriendData) then) =
      _$CurrentFriendDataCopyWithImpl<$Res, CurrentFriendData>;
  @useResult
  $Res call(
      {List<FriendProfile> currentFriends, List<Expense> currentExpenses});
}

/// @nodoc
class _$CurrentFriendDataCopyWithImpl<$Res, $Val extends CurrentFriendData>
    implements $CurrentFriendDataCopyWith<$Res> {
  _$CurrentFriendDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentFriendData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentFriends = null,
    Object? currentExpenses = null,
  }) {
    return _then(_value.copyWith(
      currentFriends: null == currentFriends
          ? _value.currentFriends
          : currentFriends // ignore: cast_nullable_to_non_nullable
              as List<FriendProfile>,
      currentExpenses: null == currentExpenses
          ? _value.currentExpenses
          : currentExpenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentFriendDataImplCopyWith<$Res>
    implements $CurrentFriendDataCopyWith<$Res> {
  factory _$$CurrentFriendDataImplCopyWith(_$CurrentFriendDataImpl value,
          $Res Function(_$CurrentFriendDataImpl) then) =
      __$$CurrentFriendDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FriendProfile> currentFriends, List<Expense> currentExpenses});
}

/// @nodoc
class __$$CurrentFriendDataImplCopyWithImpl<$Res>
    extends _$CurrentFriendDataCopyWithImpl<$Res, _$CurrentFriendDataImpl>
    implements _$$CurrentFriendDataImplCopyWith<$Res> {
  __$$CurrentFriendDataImplCopyWithImpl(_$CurrentFriendDataImpl _value,
      $Res Function(_$CurrentFriendDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentFriendData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentFriends = null,
    Object? currentExpenses = null,
  }) {
    return _then(_$CurrentFriendDataImpl(
      currentFriends: null == currentFriends
          ? _value._currentFriends
          : currentFriends // ignore: cast_nullable_to_non_nullable
              as List<FriendProfile>,
      currentExpenses: null == currentExpenses
          ? _value._currentExpenses
          : currentExpenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ));
  }
}

/// @nodoc

class _$CurrentFriendDataImpl extends _CurrentFriendData {
  const _$CurrentFriendDataImpl(
      {final List<FriendProfile> currentFriends = const <FriendProfile>[
        ...dummyFriendData
      ],
      final List<Expense> currentExpenses = const <Expense>[]})
      : _currentFriends = currentFriends,
        _currentExpenses = currentExpenses,
        super._();

  final List<FriendProfile> _currentFriends;
  @override
  @JsonKey()
  List<FriendProfile> get currentFriends {
    if (_currentFriends is EqualUnmodifiableListView) return _currentFriends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentFriends);
  }

  final List<Expense> _currentExpenses;
  @override
  @JsonKey()
  List<Expense> get currentExpenses {
    if (_currentExpenses is EqualUnmodifiableListView) return _currentExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentExpenses);
  }

  @override
  String toString() {
    return 'CurrentFriendData(currentFriends: $currentFriends, currentExpenses: $currentExpenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentFriendDataImpl &&
            const DeepCollectionEquality()
                .equals(other._currentFriends, _currentFriends) &&
            const DeepCollectionEquality()
                .equals(other._currentExpenses, _currentExpenses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_currentFriends),
      const DeepCollectionEquality().hash(_currentExpenses));

  /// Create a copy of CurrentFriendData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentFriendDataImplCopyWith<_$CurrentFriendDataImpl> get copyWith =>
      __$$CurrentFriendDataImplCopyWithImpl<_$CurrentFriendDataImpl>(
          this, _$identity);
}

abstract class _CurrentFriendData extends CurrentFriendData {
  const factory _CurrentFriendData(
      {final List<FriendProfile> currentFriends,
      final List<Expense> currentExpenses}) = _$CurrentFriendDataImpl;
  const _CurrentFriendData._() : super._();

  @override
  List<FriendProfile> get currentFriends;
  @override
  List<Expense> get currentExpenses;

  /// Create a copy of CurrentFriendData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentFriendDataImplCopyWith<_$CurrentFriendDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
