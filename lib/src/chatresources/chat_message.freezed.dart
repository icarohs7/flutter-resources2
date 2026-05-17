// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatMessage {

 bool get showSender; bool get fromMe; String? get sender; DateTime? get timestamp; String? get message; Widget? get child;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.showSender, showSender) || other.showSender == showSender)&&(identical(other.fromMe, fromMe) || other.fromMe == fromMe)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.child, child) || other.child == child));
}


@override
int get hashCode => Object.hash(runtimeType,showSender,fromMe,sender,timestamp,message,child);

@override
String toString() {
  return 'ChatMessage(showSender: $showSender, fromMe: $fromMe, sender: $sender, timestamp: $timestamp, message: $message, child: $child)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 bool showSender, bool fromMe, String? sender, DateTime? timestamp, String? message, Widget? child
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showSender = null,Object? fromMe = null,Object? sender = freezed,Object? timestamp = freezed,Object? message = freezed,Object? child = freezed,}) {
  return _then(_self.copyWith(
showSender: null == showSender ? _self.showSender : showSender // ignore: cast_nullable_to_non_nullable
as bool,fromMe: null == fromMe ? _self.fromMe : fromMe // ignore: cast_nullable_to_non_nullable
as bool,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as Widget?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showSender,  bool fromMe,  String? sender,  DateTime? timestamp,  String? message,  Widget? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.showSender,_that.fromMe,_that.sender,_that.timestamp,_that.message,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showSender,  bool fromMe,  String? sender,  DateTime? timestamp,  String? message,  Widget? child)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.showSender,_that.fromMe,_that.sender,_that.timestamp,_that.message,_that.child);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showSender,  bool fromMe,  String? sender,  DateTime? timestamp,  String? message,  Widget? child)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.showSender,_that.fromMe,_that.sender,_that.timestamp,_that.message,_that.child);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMessage implements ChatMessage {
  const _ChatMessage({this.showSender = true, this.fromMe = true, this.sender, this.timestamp, this.message, this.child});
  

@override@JsonKey() final  bool showSender;
@override@JsonKey() final  bool fromMe;
@override final  String? sender;
@override final  DateTime? timestamp;
@override final  String? message;
@override final  Widget? child;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.showSender, showSender) || other.showSender == showSender)&&(identical(other.fromMe, fromMe) || other.fromMe == fromMe)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.child, child) || other.child == child));
}


@override
int get hashCode => Object.hash(runtimeType,showSender,fromMe,sender,timestamp,message,child);

@override
String toString() {
  return 'ChatMessage(showSender: $showSender, fromMe: $fromMe, sender: $sender, timestamp: $timestamp, message: $message, child: $child)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 bool showSender, bool fromMe, String? sender, DateTime? timestamp, String? message, Widget? child
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showSender = null,Object? fromMe = null,Object? sender = freezed,Object? timestamp = freezed,Object? message = freezed,Object? child = freezed,}) {
  return _then(_ChatMessage(
showSender: null == showSender ? _self.showSender : showSender // ignore: cast_nullable_to_non_nullable
as bool,fromMe: null == fromMe ? _self.fromMe : fromMe // ignore: cast_nullable_to_non_nullable
as bool,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as Widget?,
  ));
}


}

// dart format on
