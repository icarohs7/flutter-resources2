// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'n_search_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NSearchSuggestion {
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  void Function(BuildContext) get action => throw _privateConstructorUsedError;
  Widget Function(BuildContext)? get tileBuilder =>
      throw _privateConstructorUsedError;

  /// Create a copy of NSearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NSearchSuggestionCopyWith<NSearchSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NSearchSuggestionCopyWith<$Res> {
  factory $NSearchSuggestionCopyWith(
          NSearchSuggestion value, $Res Function(NSearchSuggestion) then) =
      _$NSearchSuggestionCopyWithImpl<$Res, NSearchSuggestion>;
  @useResult
  $Res call(
      {String title,
      String subtitle,
      void Function(BuildContext) action,
      Widget Function(BuildContext)? tileBuilder});
}

/// @nodoc
class _$NSearchSuggestionCopyWithImpl<$Res, $Val extends NSearchSuggestion>
    implements $NSearchSuggestionCopyWith<$Res> {
  _$NSearchSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NSearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
    Object? action = null,
    Object? tileBuilder = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as void Function(BuildContext),
      tileBuilder: freezed == tileBuilder
          ? _value.tileBuilder
          : tileBuilder // ignore: cast_nullable_to_non_nullable
              as Widget Function(BuildContext)?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NSearchSuggestionImplCopyWith<$Res>
    implements $NSearchSuggestionCopyWith<$Res> {
  factory _$$NSearchSuggestionImplCopyWith(_$NSearchSuggestionImpl value,
          $Res Function(_$NSearchSuggestionImpl) then) =
      __$$NSearchSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String subtitle,
      void Function(BuildContext) action,
      Widget Function(BuildContext)? tileBuilder});
}

/// @nodoc
class __$$NSearchSuggestionImplCopyWithImpl<$Res>
    extends _$NSearchSuggestionCopyWithImpl<$Res, _$NSearchSuggestionImpl>
    implements _$$NSearchSuggestionImplCopyWith<$Res> {
  __$$NSearchSuggestionImplCopyWithImpl(_$NSearchSuggestionImpl _value,
      $Res Function(_$NSearchSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of NSearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
    Object? action = null,
    Object? tileBuilder = freezed,
  }) {
    return _then(_$NSearchSuggestionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as void Function(BuildContext),
      tileBuilder: freezed == tileBuilder
          ? _value.tileBuilder
          : tileBuilder // ignore: cast_nullable_to_non_nullable
              as Widget Function(BuildContext)?,
    ));
  }
}

/// @nodoc

class _$NSearchSuggestionImpl
    with DiagnosticableTreeMixin
    implements _NSearchSuggestion {
  const _$NSearchSuggestionImpl(
      {required this.title,
      required this.subtitle,
      required this.action,
      this.tileBuilder});

  @override
  final String title;
  @override
  final String subtitle;
  @override
  final void Function(BuildContext) action;
  @override
  final Widget Function(BuildContext)? tileBuilder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NSearchSuggestion(title: $title, subtitle: $subtitle, action: $action, tileBuilder: $tileBuilder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NSearchSuggestion'))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty('action', action))
      ..add(DiagnosticsProperty('tileBuilder', tileBuilder));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NSearchSuggestionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.tileBuilder, tileBuilder) ||
                other.tileBuilder == tileBuilder));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, subtitle, action, tileBuilder);

  /// Create a copy of NSearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NSearchSuggestionImplCopyWith<_$NSearchSuggestionImpl> get copyWith =>
      __$$NSearchSuggestionImplCopyWithImpl<_$NSearchSuggestionImpl>(
          this, _$identity);
}

abstract class _NSearchSuggestion implements NSearchSuggestion {
  const factory _NSearchSuggestion(
          {required final String title,
          required final String subtitle,
          required final void Function(BuildContext) action,
          final Widget Function(BuildContext)? tileBuilder}) =
      _$NSearchSuggestionImpl;

  @override
  String get title;
  @override
  String get subtitle;
  @override
  void Function(BuildContext) get action;
  @override
  Widget Function(BuildContext)? get tileBuilder;

  /// Create a copy of NSearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NSearchSuggestionImplCopyWith<_$NSearchSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
