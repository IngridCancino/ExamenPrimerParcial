
import 'package:flutter/material.dart';
import '../models/weight_model.dart';
import 'add_weight_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  List<WeightModel> registros = [];

  Future<void> _agregarPeso() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWeightScreen(),
      ),
    );

    if (!mounted) return;

    if (resultado != null && resultado is WeightModel) {
      registros.add(resultado);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Peso'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: registros.isEmpty
          ? Center(
              child: Text('No hay registros'),
            )
          : ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];

                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.monitor_weight),
                    ),
                    title: Text(registro.fecha),
                    subtitle: Text(
                      '${registro.pesoKilos} kg',
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarPeso,
        child: Icon(Icons.add),
      ),
    );
  }
}
