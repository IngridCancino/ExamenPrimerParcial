
import 'package:flutter/material.dart';

import '../models/workout_model.dart';
import '../services/local_workout_service.dart';
import 'add_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workouts = await _dbService.getWorkouts();

      if (!mounted) return;

      setState(() {
        _workouts = workouts;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar rutinas: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  Future<void> _navigateToAddWorkout() async {
    final newWorkout = await Navigator.push<WorkoutModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWorkoutScreen(),
      ),
    );

    if (!mounted || newWorkout == null) return;

    try {
      await _dbService.insertWorkout(newWorkout);

      if (!mounted) return;

      await _loadWorkouts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rutina guardada correctamente'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar rutina: $e'),
        ),
      );
    }
  }


  Future<void> _deleteWorkout(int id, String title) async {
    try {
      await _dbService.deleteWorkout(id);

      if (!mounted) return;

      await _loadWorkouts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rutina eliminada: $title'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar rutina: $e'),
        ),
      );
    }
  }

  // Editar una rutina existente
  Future<void> _editWorkout(WorkoutModel workout) async {
    final titleController = TextEditingController(
      text: workout.title,
    );

    final durationController = TextEditingController(
      text: workout.durationMinutes.toString(),
    );

    String selectedCategory = workout.category;

    try {
      final updatedWorkout = await showDialog<WorkoutModel>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return AlertDialog(
                title: const Text('Editar rutina'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                        ),
                        items: [
                          'Fuerza',
                          'Cardio',
                          'Flexibilidad',
                        ].map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duración (minutos)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      final duration = int.tryParse(
                        durationController.text.trim(),
                      );

                      if (title.isEmpty ||
                          duration == null ||
                          duration <= 0) {
                        return;
                      }

                      Navigator.pop(
                        dialogContext,
                        WorkoutModel(
                          localId: workout.localId,
                          title: title,
                          category: selectedCategory,
                          durationMinutes: duration,
                        ),
                      );
                    },
                    child: const Text('Actualizar'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (!mounted || updatedWorkout == null) return;

      await _dbService.updateWorkout(updatedWorkout);

      if (!mounted) return;

      await _loadWorkouts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rutina actualizada'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al editar rutina: $e'),
        ),
      );
    } finally {
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
      titleController.dispose();
      durationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis entrenamientos'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _workouts.isEmpty
              ? const Center(
                  child: Text('No tienes rutinas creadas'),
                )
              : ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final workout = _workouts[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.fitness_center),
                        ),
                        title: Text(
                          workout.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${workout.category} - '
                          '${workout.durationMinutes} min',
                        ),
                        onTap: () => _editWorkout(workout),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editWorkout(workout);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (workout.localId != null) {
                                  _deleteWorkout(
                                    workout.localId!,
                                    workout.title,
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }
}
