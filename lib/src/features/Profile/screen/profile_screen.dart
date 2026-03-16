import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/model/user_profile.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _footLengthController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  final _chestController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = context.read<SharedPreferencesService>().currentProfile;
    if (profile != null) {
      _footLengthController.text = profile.footLength?.toString() ?? '';
      _waistController.text = profile.waistCircumference?.toString() ?? '';
      _hipController.text = profile.hipCircumference?.toString() ?? '';
      _chestController.text = profile.chestCircumference?.toString() ?? '';
      _notesController.text = profile.notes ?? '';
    }
  }

  @override
  void dispose() {
    _footLengthController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    _chestController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// helper-methode for validating number inputs, allows empty values since all fields are optional
  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; 
    }
    
    final normalizedValue = value.replaceAll(',', '.');
    if (double.tryParse(normalizedValue) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final service = context.read<SharedPreferencesService>();
      
      final profile = service.currentProfile ?? UserProfile();

      double? parseValue(String text) {
        if (text.trim().isEmpty) return null;
        return double.tryParse(text.replaceAll(',', '.'));
      }

      profile.footLength = parseValue(_footLengthController.text);
      profile.waistCircumference = parseValue(_waistController.text);
      profile.hipCircumference = parseValue(_hipController.text);
      profile.chestCircumference = parseValue(_chestController.text);
      
      final notesText = _notesController.text.trim();
      profile.notes = notesText.isEmpty ? null : notesText;

      service.saveProfile(profile).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
        Navigator.pop(context); // Zurück zum HomeScreen
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while saving.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Body measurements (in cm)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _footLengthController,
                decoration: const InputDecoration(
                  labelText: 'Foot length',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _chestController,
                decoration: const InputDecoration(
                  labelText: 'Chest size',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _waistController,
                decoration: const InputDecoration(
                  labelText: 'Waist size',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _hipController,
                decoration: const InputDecoration(
                  labelText: 'Hip circumference',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNumber,
              ),
              const SizedBox(height: 24),

              const Text(
                'Notes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional information (e.g., wide feet)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Save profile', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}