import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'n_base_persisted_field.dart';

/// A secure persisted field that stores integer values.
///
/// Provides serialization and deserialization of integer values to/from string format
/// for secure storage.
class NSecurePersistedFieldInt extends NSecurePersistedField<int> {
  NSecurePersistedFieldInt({required super.key, super.defaultValue})
    : super(
        deserialize: (json) => int.tryParse(json) ?? defaultValue ?? 0,
        serialize: (value) => value.toString(),
      );
}

/// A secure persisted field that stores double values.
///
/// Provides serialization and deserialization of double values to/from string format
/// for secure storage.
class NSecurePersistedFieldDouble extends NSecurePersistedField<double> {
  NSecurePersistedFieldDouble({required super.key, super.defaultValue})
    : super(
        deserialize: (json) => double.tryParse(json) ?? defaultValue ?? 0.0,
        serialize: (value) => value.toString(),
      );
}

/// A secure persisted field that stores boolean values.
///
/// Provides serialization and deserialization of boolean values to/from string format
/// for secure storage.
class NSecurePersistedFieldBool extends NSecurePersistedField<bool> {
  NSecurePersistedFieldBool({required super.key, super.defaultValue})
    : super(deserialize: (json) => json == 'true', serialize: (value) => value.toString());
}

/// A secure persisted field that stores string values.
///
/// Uses identity function for both serialization and deserialization since
/// the values are already in string format.
class NSecurePersistedFieldString extends NSecurePersistedField<String> {
  NSecurePersistedFieldString({required super.key, super.defaultValue})
    : super(deserialize: identity, serialize: identity);
}

/// Base class for secure persisted fields that provides encrypted storage functionality.
///
/// Uses Hive for storage with AES encryption. The encryption key is stored securely
/// using FlutterSecureStorage. Supports generic type [T] for storing different
/// data types.
class NSecurePersistedField<T> extends NBasePersistedField<T> {
  static const String _boxName = 'n_secure_box';
  static const String _encryptionKeyName = 'n_secure_box_hive_encryption_key';
  static late Box<String> _box;

  NSecurePersistedField({
    required super.key,
    super.defaultValue,
    required super.deserialize,
    super.serialize = jsonEncode,
  });

  /// Initializes the secure storage by setting up an encrypted Hive box.
  ///
  /// This method must be called before using any NSecurePersistedField instances.
  /// It creates or opens an encrypted Hive box using AES encryption.
  ///
  /// Parameters:
  /// - [box]: Optional pre-configured Hive box. If not provided, a new encrypted
  ///   box will be created using the default configuration.
  ///
  /// Throws an exception if initialization fails or encryption setup encounters
  /// an error.
  static Future<void> init([Box<String>? box]) async {
    _box =
        box ??
        await Hive.openBox(
          _boxName,
          encryptionCipher: HiveAesCipher(await _getOrCreateEncryptionKey()),
        );
  }

  @override
  Box<String> get box => _box;

  static Future<List<int>> _getOrCreateEncryptionKey() async {
    const secureStorage = FlutterSecureStorage();
    String? keyString = await secureStorage.read(key: _encryptionKeyName);

    if (keyString == null) {
      final key = Hive.generateSecureKey();
      keyString = base64Url.encode(key);
      await secureStorage.write(key: _encryptionKeyName, value: keyString);
      return key;
    }

    return base64Url.decode(keyString);
  }
}
