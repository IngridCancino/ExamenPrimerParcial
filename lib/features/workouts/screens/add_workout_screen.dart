
import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedCategory = 'Fuerza';

  final List<String> _categories = [
    'Fuerza',
    'Cardio',
    'Flexibilidad',
  ];

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final newWorkout = WorkoutModel(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        durationMinutes: int.parse(
          _durationController.text.trim(),
        ),
      );

      Navigator.pop(context, newWorkout);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva rutina'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la rutina',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre de la rutina';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duración (minutos)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa los minutos';
                  }

                  final duration = int.tryParse(value.trim());

                  if (duration == null) {
                    return 'Solo se permiten valores numéricos';
                  }

                  if (duration <= 0) {
                    return 'La duración debe ser mayor a cero';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: const Text('Guardar rutina'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
