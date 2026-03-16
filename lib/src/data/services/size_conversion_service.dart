import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum Gender { men, women, kids }

class SizeConversionService extends ChangeNotifier {
  Map<String, dynamic>? _sourceData;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Loads the JSON data from assets
  Future<void> loadDefinitionData() async {
    final String response = await rootBundle.loadString(
      'assets/data/size_conversion_data.json',
    );
    _sourceData = json.decode(response);
    _isLoaded = true;
    notifyListeners();
  }

  /// Generic finder logic for intervals. Now supports custom keys!
  Map<String, dynamic>? _findMatch(
    List<dynamic> data,
    double value, {
    String minKey = 'min_cm',
    String maxKey = 'max_cm',
  }) {
    try {
      return data.firstWhere((row) {
        if (row[minKey] == null || row[maxKey] == null) return false;

        final double min = (row[minKey] as num).toDouble();
        final double max = (row[maxKey] as num).toDouble();
        return value >= min && value <= max;
      });
    } catch (e) {
      return null;
    }
  }

  /// Specific conversion for Tops
  Map<String, dynamic>? convertTops(double chestCm, Gender gender) {
    if (!_isLoaded) return null;

    final String genderKey = gender == Gender.men ? 'men' : 'women';
    final List<dynamic> data =
        _sourceData!['converters']['tops'][genderKey]['data'];

    return _findMatch(data, chestCm);
  }

  /// Specific conversion for Bottoms
  Map<String, dynamic>? convertBottoms(double waistCm, Gender gender) {
    if (!_isLoaded) return null;

    final String genderKey = gender == Gender.men
        ? 'men_standard'
        : 'women_plus';
    final List<dynamic> data =
        _sourceData!['converters']['bottoms'][genderKey]['data'];

    return _findMatch(data, waistCm, minKey: 'waist_min', maxKey: 'waist_max');
  }

  /// Specific conversion for Shoes
  Map<String, dynamic>? convertShoes(double footCm) {
    if (!_isLoaded) return null;
    final List<dynamic> data = _sourceData!['converters']['shoes']['data'];
    return _findMatch(data, footCm);
  }

  /// Finds a size entry by EU size for Tops
  Map<String, dynamic>? findByEuSize(String euValue, Gender gender) {
    if (!_isLoaded) return null;

    final String genderKey = gender == Gender.men ? 'men' : 'women';
    final List<dynamic> data =
        _sourceData!['converters']['tops'][genderKey]['data'];

    try {
      return data.firstWhere((row) {
        return row['eu'].toString() == euValue;
      });
    } catch (e) {
      return null;
    }
  }
}
