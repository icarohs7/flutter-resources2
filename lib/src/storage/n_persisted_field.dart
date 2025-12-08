import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'n_base_persisted_field.dart';

/// A persisted field implementation for storing integer values.
///
/// Provides serialization and deserialization of integer values to/from string format
/// with a default value of 0 if parsing fails.
class NPersistedFieldInt extends NPersistedField<int> {
  NPersistedFieldInt({required super.key, super.defaultValue})
    : super(
        deserialize: (json) => int.tryParse(json) ?? defaultValue ?? 0,
        serialize: (value) => value.toString(),
      );
}

/// A persisted field implementation for storing double values.
///
/// Provides serialization and deserialization of double values to/from string format
/// with a default value of 0.0 if parsing fails.
class NPersistedFieldDouble extends NPersistedField<double> {
  NPersistedFieldDouble({required super.key, super.defaultValue})
    : super(
        deserialize: (json) => double.tryParse(json) ?? defaultValue ?? 0.0,
        serialize: (value) => value.toString(),
      );
}

/// A persisted field implementation for storing boolean values.
///
/// Provides serialization and deserialization of boolean values to/from string format,
/// where 'true' string represents true value.
class NPersistedFieldBool extends NPersistedField<bool> {
  NPersistedFieldBool({required super.key, super.defaultValue})
    : super(deserialize: (json) => json == 'true', serialize: (value) => value.toString());
}

/// A persisted field implementation for storing string values.
///
/// Uses direct string values without any transformation for storage and retrieval.
class NPersistedFieldString extends NPersistedField<String> {
  NPersistedFieldString({required super.key, super.defaultValue})
    : super(deserialize: identity, serialize: identity);
}

/// Base implementation of a persisted field that stores values in an unsecured Hive box.
///
/// Provides generic type storage with customizable serialization and deserialization.
/// Values are stored as strings in a Hive box named 'n_unsecure_box'.
class NPersistedField<T> extends NBasePersistedField<T> {
  static const String _boxName = 'n_unsecure_box';
  static late Box<String> _box;

  NPersistedField({
    required super.key,
    super.defaultValue,
    required super.deserialize,
    super.serialize = jsonEncode,
  });

  /// Initializes the persistent storage by setting up the Hive box.
  ///
  /// If a [box] is provided, it will be used as the storage box.
  /// Otherwise, a new box will be opened with the name `unsecure_box`.
  /// This method must be called before using any NPersistedField instances.
  static Future<void> init([Box<String>? box]) async {
    _box = box ?? await Hive.openBox(_boxName);
  }

  @override
  Box<String> get box => _box;
}
