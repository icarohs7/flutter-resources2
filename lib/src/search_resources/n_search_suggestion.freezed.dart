// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'n_search_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NSearchSuggestion implements DiagnosticableTreeMixin {

 String get title; String get subtitle; void Function(BuildContext context) get action; Widget Function(BuildContext context)? get tileBuilder;
/// Create a copy of NSearchSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NSearchSuggestionCopyWith<NSearchSuggestion> get copyWith => _$NSearchSuggestionCopyWithImpl<NSearchSuggestion>(this as NSearchSuggestion, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NSearchSuggestion'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('subtitle', subtitle))..add(DiagnosticsProperty('action', action))..add(DiagnosticsProperty('tileBuilder', tileBuilder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NSearchSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.action, action) || other.action == action)&&(identical(other.tileBuilder, tileBuilder) || other.tileBuilder == tileBuilder));
}


@override
int get hashCode => Object.hash(runtimeType,title,subtitle,action,tileBuilder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NSearchSuggestion(title: $title, subtitle: $subtitle, action: $action, tileBuilder: $tileBuilder)';
}


}

/// @nodoc
abstract mixin class $NSearchSuggestionCopyWith<$Res>  {
  factory $NSearchSuggestionCopyWith(NSearchSuggestion value, $Res Function(NSearchSuggestion) _then) = _$NSearchSuggestionCopyWithImpl;
@useResult
$Res call({
 String title, String subtitle, void Function(BuildContext context) action, Widget Function(BuildContext context)? tileBuilder
});




}
/// @nodoc
class _$NSearchSuggestionCopyWithImpl<$Res>
    implements $NSearchSuggestionCopyWith<$Res> {
  _$NSearchSuggestionCopyWithImpl(this._self, this._then);

  final NSearchSuggestion _self;
  final $Res Function(NSearchSuggestion) _then;

/// Create a copy of NSearchSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? subtitle = null,Object? action = null,Object? tileBuilder = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as void Function(BuildContext context),tileBuilder: freezed == tileBuilder ? _self.tileBuilder : tileBuilder // ignore: cast_nullable_to_non_nullable
as Widget Function(BuildContext context)?,
  ));
}

}


/// Adds pattern-matching-related methods to [NSearchSuggestion].
extension NSearchSuggestionPatterns on NSearchSuggestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NSearchSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NSearchSuggestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NSearchSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _NSearchSuggestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NSearchSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _NSearchSuggestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String subtitle,  void Function(BuildContext context) action,  Widget Function(BuildContext context)? tileBuilder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NSearchSuggestion() when $default != null:
return $default(_that.title,_that.subtitle,_that.action,_that.tileBuilder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String subtitle,  void Function(BuildContext context) action,  Widget Function(BuildContext context)? tileBuilder)  $default,) {final _that = this;
switch (_that) {
case _NSearchSuggestion():
return $default(_that.title,_that.subtitle,_that.action,_that.tileBuilder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String subtitle,  void Function(BuildContext context) action,  Widget Function(BuildContext context)? tileBuilder)?  $default,) {final _that = this;
switch (_that) {
case _NSearchSuggestion() when $default != null:
return $default(_that.title,_that.subtitle,_that.action,_that.tileBuilder);case _:
  return null;

}
}

}

/// @nodoc


class _NSearchSuggestion with DiagnosticableTreeMixin implements NSearchSuggestion {
  const _NSearchSuggestion({required this.title, required this.subtitle, required this.action, this.tileBuilder});
  

@override final  String title;
@override final  String subtitle;
@override final  void Function(BuildContext context) action;
@override final  Widget Function(BuildContext context)? tileBuilder;

/// Create a copy of NSearchSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NSearchSuggestionCopyWith<_NSearchSuggestion> get copyWith => __$NSearchSuggestionCopyWithImpl<_NSearchSuggestion>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NSearchSuggestion'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('subtitle', subtitle))..add(DiagnosticsProperty('action', action))..add(DiagnosticsProperty('tileBuilder', tileBuilder));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NSearchSuggestion&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.action, action) || other.action == action)&&(identical(other.tileBuilder, tileBuilder) || other.tileBuilder == tileBuilder));
}


@override
int get hashCode => Object.hash(runtimeType,title,subtitle,action,tileBuilder);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NSearchSuggestion(title: $title, subtitle: $subtitle, action: $action, tileBuilder: $tileBuilder)';
}


}

/// @nodoc
abstract mixin class _$NSearchSuggestionCopyWith<$Res> implements $NSearchSuggestionCopyWith<$Res> {
  factory _$NSearchSuggestionCopyWith(_NSearchSuggestion value, $Res Function(_NSearchSuggestion) _then) = __$NSearchSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String title, String subtitle, void Function(BuildContext context) action, Widget Function(BuildContext context)? tileBuilder
});




}
/// @nodoc
class __$NSearchSuggestionCopyWithImpl<$Res>
    implements _$NSearchSuggestionCopyWith<$Res> {
  __$NSearchSuggestionCopyWithImpl(this._self, this._then);

  final _NSearchSuggestion _self;
  final $Res Function(_NSearchSuggestion) _then;

/// Create a copy of NSearchSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? subtitle = null,Object? action = null,Object? tileBuilder = freezed,}) {
  return _then(_NSearchSuggestion(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as void Function(BuildContext context),tileBuilder: freezed == tileBuilder ? _self.tileBuilder : tileBuilder // ignore: cast_nullable_to_non_nullable
as Widget Function(BuildContext context)?,
  ));
}


}

// dart format on
