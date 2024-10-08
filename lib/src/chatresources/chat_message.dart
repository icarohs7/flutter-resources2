import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @Default(true) bool showSender,
    @Default(true) bool fromMe,
    String? sender,
    DateTime? timestamp,
    String? message,
    Widget? child,
  }) = _ChatMessage;
}
