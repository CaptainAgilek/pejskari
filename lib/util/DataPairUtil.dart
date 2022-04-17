import 'package:flutter/material.dart';

/// Utility class for pairing data.
class DataPairUtil {
  /// Pairs data by title and value.
  static Map<String, String> createMapForAttribute(String title, String value) {
    final Map<String, String> map = {
      "title": title,
      "value": value,
    };
    return map;
  }
}
