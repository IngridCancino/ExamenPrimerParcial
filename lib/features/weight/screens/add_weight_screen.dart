
import 'package:flutter/material.dart';
import '../models/weight_model.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fechaController = TextEditingController();
  final _pesoController = TextEditingController();

  void _guardarPeso() {
    if (_formKey.currentState!.validate()) {
      final nuevoPeso = WeightModel(
        fecha: _fechaController.text.trim(),
        pesoKilos: double.parse(_pesoController.text.trim()),
      );

      Navigator.pop(context, nuevoPeso);
    }
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar peso'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una fecha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa tu peso';
                  }

                  final peso = double.tryParse(value.trim());

                  if (peso == null || !peso.isFinite || peso <= 0) {
                    return 'Ingresa un peso válido mayor a 0';
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarPeso,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
