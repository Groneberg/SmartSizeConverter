import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum Gender { men, women, kids }

class SizeConversionService extends ChangeNotifier {
  Map<String, dynamic>? _sourceData;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadDefinitionData() async {
    final String response = await rootBundle.loadString('assets/data/size_conversion_data.json');
    _sourceData = json.decode(response);
    _isLoaded = true;
    notifyListeners();
  }

  /// Universal converter for tops, bottoms and shoes based on chest/waist/foot length
  Map<String, dynamic>? convert(String category, double value, Gender gender) {
    if (!_isLoaded) return null;
    
    final String genderKey = gender.name;
    final section = _sourceData!['converters'][category][genderKey];
    if (section == null) return null;
    
    final List<dynamic> data = section['data'];
    
    try {
      return data.firstWhere((row) {
        
        final double min = (row['min_cm'] ?? row['min_waist_cm'] ?? row['min_height_cm'] as num).toDouble();
        final double max = (row['max_cm'] ?? row['max_waist_cm'] ?? row['max_height_cm'] as num).toDouble();
        return value >= min && value <= max;
      });
    } catch (e) {
      return null;
    }
  }

  /// Finds a size entry based on EU size (for tops and bottoms)
  Map<String, dynamic>? findByEu(String category, String euValue, Gender gender) {
    if (!_isLoaded) return null;
    final String genderKey = gender.name;
    final List<dynamic> data = _sourceData!['converters'][category][genderKey]['data'];
    
    try {
      return data.firstWhere((row) => row['eu'].toString() == euValue);
    } catch (e) {
      return null;
    }
  }
}