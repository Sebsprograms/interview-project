import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensor_bloc.dart';
import 'sensor_state.dart';
import 'sensor_event.dart';
import 'model/sensor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  

  @override
  Widget build(BuildContext context) {
    
  
    void _showEditDialog(Sensor sensor) {

    final nameController = TextEditingController(text: sensor.name);
    final descController = TextEditingController(text: sensor.description);

    final bloc = context.read<SensorBloc>();
  

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Sensor ${sensor.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
             

             bloc.add(
                    EditSensorDetails(sensor.id, nameController.text, descController.text),
                  ); print('pressed');

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermal Sensors'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by name or description...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SensorBloc, SensorState>(
        builder: (context, state) {
          final filteredSensors = state.sensors.where((sensor) {
            final q = searchQuery.toLowerCase();
            return sensor.name.toLowerCase().contains(q) ||
                sensor.description.toLowerCase().contains(q);
          }).toList();

          if (filteredSensors.isEmpty) {
            return const Center(child: Text('No sensors found.'));
          }

          return ListView.builder(
            itemCount: filteredSensors.length,
            itemBuilder: (context, index) {
              final sensor = filteredSensors[index];
              return ListTile(
                title: Text('${sensor.name} (${sensor.id})'),
                subtitle: Text('Value: ${sensor.value.toStringAsFixed(2)}\n${sensor.description}'),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Update Sensor',
                      onPressed: () {
                        context.read<SensorBloc>().add(UpdateSensorValue(sensor));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Sensor',
                      onPressed: () => _showEditDialog(sensor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
