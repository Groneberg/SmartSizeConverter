import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/data/services/size_conversion_service.dart';

class BottomsScreen extends StatefulWidget {
  const BottomsScreen({super.key});

  @override
  State<BottomsScreen> createState() => _BottomsScreenState();
}

class _BottomsScreenState extends State<BottomsScreen> {
  Gender _selectedGender = Gender.men;
  
  // Controller
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _euSizeController = TextEditingController();
  final TextEditingController _intlSizeController = TextEditingController();
  final TextEditingController _extraInfoController = TextEditingController(); // Für Beinlänge/Hüfte
  String _fitHint = '';

  @override
  void dispose() {
    _waistController.dispose();
    _euSizeController.dispose();
    _intlSizeController.dispose();
    _extraInfoController.dispose();
    super.dispose();
  }

  void _updateSizes(String value) {
    if (value.isEmpty) return;
    final double? waist = double.tryParse(value.replaceAll(',', '.'));
    if (waist == null) return;

    final result = context.read<SizeConversionService>().convertBottoms(waist, _selectedGender);

    if (result != null) {
      setState(() {
        _euSizeController.text = result['eu'].toString();
        _intlSizeController.text = result['intl'] ?? '-';
        _fitHint = result['category'] ?? ''; 
        
        if (_selectedGender == Gender.men && result['leg_length'] != null) {
           _extraInfoController.text = '${result['leg_length']} cm (Leg Length)';
        } else if (_selectedGender == Gender.women && result['hip_max'] != null) {
           _extraInfoController.text = 'up to ${result['hip_max']} cm (Hip)';
        } else {
           _extraInfoController.text = '-';
        }
      });
    } else {
      _clearFields(keepWaist: true);
    }
  }

  void _updateFromEu(String value) {
    if (value.isEmpty) return;

    final result = context.read<SizeConversionService>().findByEuSizeBottoms(value, _selectedGender);

    if (result != null) {
      setState(() {
        // Mittelwert aus waist_min und waist_max berechnen
        double avg = ((result['waist_min'] as num) + (result['waist_max'] as num)) / 2;
        _waistController.text = avg.toStringAsFixed(1);
        _intlSizeController.text = result['intl'] ?? '-';
        _fitHint = result['category'] ?? '';

        if (_selectedGender == Gender.men && result['leg_length'] != null) {
           _extraInfoController.text = '${result['leg_length']} cm (Leg Length)';
        } else if (_selectedGender == Gender.women && result['hip_max'] != null) {
           _extraInfoController.text = 'up to ${result['hip_max']} cm (Hip)';
        } else {
           _extraInfoController.text = '-';
        }
      });
    }
  }

  void _clearFields({bool keepWaist = false}) {
    setState(() {
      if (!keepWaist) _waistController.clear();
      _euSizeController.clear();
      _intlSizeController.clear();
      _extraInfoController.clear();
      _fitHint = 'Size not found';
    });
  }

  void _loadFromProfile() {
    final profile = context.read<SharedPreferencesService>().currentProfile;
    if (profile?.waistCircumference != null) {
      _waistController.text = profile!.waistCircumference.toString();
      _updateSizes(_waistController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waist measurement loaded successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No waist measurement found in profile!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottoms Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Gender Toggle
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.women, label: Text('Women'), icon: Icon(Icons.woman)),
                ButtonSegment(value: Gender.men, label: Text('Men'), icon: Icon(Icons.man)),
              ],
              selected: {_selectedGender},
              onSelectionChanged: (set) {
                setState(() => _selectedGender = set.first);
                _updateSizes(_waistController.text);
              },
            ),
            const SizedBox(height: 24),
            
            FilledButton.icon(
              onPressed: _loadFromProfile,
              icon: const Icon(Icons.person),
              label: const Text('Load Size from Profile'),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _waistController,
              decoration: const InputDecoration(
                labelText: 'Waist Circumference (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateSizes,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _euSizeController,
              decoration: const InputDecoration(
                labelText: 'EU Size (e.g. 48)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.euro),
              ),
              keyboardType: TextInputType.text,
              onChanged: _updateFromEu,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _intlSizeController,
              decoration: const InputDecoration(
                labelText: 'International Size',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.public),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _extraInfoController,
              decoration: const InputDecoration(
                labelText: 'Details (Leg Length / Hip)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
              ),
              readOnly: true,
            ),

            if (_fitHint.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Note: $_fitHint', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ),
          ],
        ),
      ),
    );
  }
}