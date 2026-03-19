import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/data/services/size_conversion_service.dart';

class TopsScreen extends StatefulWidget {
  const TopsScreen({super.key});

  @override
  State<TopsScreen> createState() => _TopsScreenState();
}

class _TopsScreenState extends State<TopsScreen> {
  Gender _selectedGender = Gender.men;

  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _euSizeController = TextEditingController();
  final TextEditingController _intlSizeController = TextEditingController();
  final TextEditingController _usSizeController = TextEditingController();
  String _fitHint = '';

  @override
  void dispose() {
    _chestController.dispose();
    _euSizeController.dispose();
    _intlSizeController.dispose();
    _usSizeController.dispose();
    super.dispose();
  }

  void _updateSizes(String value) {
    if (value.isEmpty) {
      _clearFields();
      return;
    }
    final double? cm = double.tryParse(value.replaceAll(',', '.'));
    if (cm == null) return;

    final result = context.read<SizeConversionService>().convert(
      'tops',
      cm,
      _selectedGender,
    );

    if (result != null) {
      setState(() {
        _euSizeController.text = result['eu'].toString();
        _intlSizeController.text = result['intl'] ?? '-';
        _usSizeController.text = result['us']?.toString() ?? '-';
        _fitHint = result['category'] ?? '';
      });
    } else {
      _clearFields(keepInput: true);
    }
  }

  void _updateFromEu(String value) {
    if (value.isEmpty) return;

    final result = context.read<SizeConversionService>().findByEu(
      'tops',
      value,
      _selectedGender,
    );

    if (result != null) {
      setState(() {
        double avg = ((result['min_cm'] as num) + (result['max_cm'] as num)) / 2;
        _chestController.text = avg.toStringAsFixed(1);
        _intlSizeController.text = result['intl'] ?? '-';
        _usSizeController.text = result['us']?.toString() ?? '-';
        _fitHint = result['category'] ?? '';
      });
    }
  }

  void _clearFields({bool keepInput = false}) {
    setState(() {
      if (!keepInput) _chestController.clear();
      _euSizeController.clear();
      _intlSizeController.clear();
      _usSizeController.clear();
      _fitHint = 'Size not found';
    });
  }

  void _loadFromProfile() {
    final profile = context.read<SharedPreferencesService>().currentProfile;
    if (profile?.chestCircumference != null) {
      _chestController.text = profile!.chestCircumference.toString();
      _updateSizes(_chestController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chest measurement loaded successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No chest measurement found in profile!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tops Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(
                  value: Gender.women,
                  label: Text('Women'),
                  icon: Icon(Icons.woman),
                ),
                ButtonSegment(
                  value: Gender.men,
                  label: Text('Men'),
                  icon: Icon(Icons.man),
                ),
                ButtonSegment(
                  value: Gender.kids,
                  label: Text('Kids'),
                  icon: Icon(Icons.child_care),
                ),
              ],
              selected: {_selectedGender},
              onSelectionChanged: (set) {
                setState(() {
                  _selectedGender = set.first;
                });
                _updateSizes(_chestController.text);
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
              controller: _chestController,
              decoration: const InputDecoration(
                labelText: 'Chest Circumference (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
              controller: _usSizeController,
              decoration: const InputDecoration(
                labelText: 'US Size',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag_circle_outlined),
              ),
              readOnly: true,
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

            if (_fitHint.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Note: $_fitHint',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}