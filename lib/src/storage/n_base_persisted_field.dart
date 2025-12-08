import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:stream_resources/stream_resources.dart';


/// A base class for persistent field storage that manages reading, writing,
/// and observing values of type [T] using Hive storage.
///
/// This class provides a type-safe way to persist and retrieve values with
/// automatic serialization and deserialization support.
abstract class NBasePersistedField<T> {
  final String key;
  final T? defaultValue;
  final T Function(String json) deserialize;
  final String Function(T value) serialize;

  /// Creates a new [BasePersistedField] instance.
  ///
  /// [key] - The unique identifier for storing the value.
  /// [defaultValue] - The value to return when no value is stored.
  /// [deserialize] - Function to convert stored JSON string to type [T].
  /// [serialize] - Function to convert type [T] to JSON string for storage.
  NBasePersistedField({
    required this.key,
    required this.defaultValue,
    required this.deserialize,
    required this.serialize,
  });

  /// The Hive storage box used for persistence.
  Box<String> get box;

  /// A reactive container that provides the current value and updates.
  late final listenable = _watch().asRc();

  /// Retrieves the current value from storage.
  ///
  /// Returns [defaultValue] if no value is stored.
  T? get() => box.get(key)?.apply(deserialize) ?? defaultValue;

  /// Provides quick access to the current value through callable syntax.
  T? call() => listenable.value;

  /// Stores the provided [value] in persistent storage.
  Future<void> set(T value) => box.put(key, serialize(value));

  /// Removes the stored value from persistent storage.
  Future<void> clear() => box.delete(key);

  /// Creates a value stream that watches for changes to the stored value.
  ValueStream<T?> _watch() =>
      box.watch(key: key).map((event) => get()).shareValueSeeded(get() ?? defaultValue);
}
