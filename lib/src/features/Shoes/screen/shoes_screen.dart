import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/data/services/size_conversion_service.dart';

class ShoesScreen extends StatefulWidget {
  const ShoesScreen({super.key});

  @override
  State<ShoesScreen> createState() => _ShoesScreenState();
}

class _ShoesScreenState extends State<ShoesScreen> {
  Gender _selectedGender = Gender.men;

  final TextEditingController _footController = TextEditingController();
  final TextEditingController _euSizeController = TextEditingController();
  final TextEditingController _usSizeController = TextEditingController();
  final TextEditingController _ukSizeController = TextEditingController();
  String _fitHint = '';

  @override
  void dispose() {
    _footController.dispose();
    _euSizeController.dispose();
    _usSizeController.dispose();
    _ukSizeController.dispose();
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
      'shoes',
      cm,
      _selectedGender,
    );

    if (result != null) {
      setState(() {
        _euSizeController.text = result['eu'].toString();
        _usSizeController.text = result['us']?.toString() ?? '-';
        _ukSizeController.text = result['uk']?.toString() ?? '-';
        _fitHint = result['category'] ?? '';
      });
    } else {
      _clearFields(keepInput: true);
    }
  }

  void _updateFromEu(String value) {
    if (value.isEmpty) return;

    final result = context.read<SizeConversionService>().findByEu(
      'shoes',
      value,
      _selectedGender,
    );

    if (result != null) {
      setState(() {
        double avg = ((result['min_cm'] as num) + (result['max_cm'] as num)) / 2;
        _footController.text = avg.toStringAsFixed(1);
        _usSizeController.text = result['us']?.toString() ?? '-';
        _ukSizeController.text = result['uk']?.toString() ?? '-';
        _fitHint = result['category'] ?? '';
      });
    }
  }

  void _clearFields({bool keepInput = false}) {
    setState(() {
      if (!keepInput) _footController.clear();
      _euSizeController.clear();
      _usSizeController.clear();
      _ukSizeController.clear();
      _fitHint = 'Size not found';
    });
  }

  void _loadFromProfile() {
    final profile = context.read<SharedPreferencesService>().currentProfile;
    if (profile?.footLength != null) {
      _footController.text = profile!.footLength.toString();
      _updateSizes(_footController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foot length loaded successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No foot length found in profile!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoes Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.women, label: Text('Women'), icon: Icon(Icons.woman)),
                ButtonSegment(value: Gender.men, label: Text('Men'), icon: Icon(Icons.man)),
                ButtonSegment(value: Gender.kids, label: Text('Kids'), icon: Icon(Icons.child_care)),
              ],
              selected: {_selectedGender},
              onSelectionChanged: (set) {
                setState(() => _selectedGender = set.first);
                _updateSizes(_footController.text);
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
              controller: _footController,
              decoration: const InputDecoration(
                labelText: 'Foot Length (cm)',
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
                labelText: 'EU Size (e.g. 42)',
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
              controller: _ukSizeController,
              decoration: const InputDecoration(
                labelText: 'UK Size',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.public),
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