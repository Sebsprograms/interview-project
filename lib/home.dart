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
  bool isAscending = true;

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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
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
                );
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
        toolbarHeight: 80,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/ecolab.png', // Ensure this path is correct
              height: 40, // Adjust the height as needed
            ),
            const SizedBox(height: 10), // Add spacing between the image and the title
            const Text('Thermal Sensors'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
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
      body: Column(
        children: [
          // Sorting toggle button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  tooltip: 'Sort by Temperature',
                  onPressed: () {
                    setState(() {
                      isAscending = !isAscending; // Toggle sorting order
                    });
                  },
                ),
                Text(
                  isAscending ? 'Sort Ascending' : 'Sort Descending',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Sensor list
          Expanded(
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                final filteredSensors = state.sensors.where((sensor) {
                  final q = searchQuery.toLowerCase();
                  return sensor.name.toLowerCase().contains(q) ||
                      sensor.description.toLowerCase().contains(q);
                }).toList();

                filteredSensors.sort((a, b) => isAscending
                    ? a.value.compareTo(b.value)
                    : b.value.compareTo(a.value));

                if (filteredSensors.isEmpty) {
                  return const Center(child: Text('No sensors found.'));
                }

                return ListView.builder(
                  itemCount: filteredSensors.length,
                  itemBuilder: (context, index) {
                    final sensor = filteredSensors[index];
                    return ListTile(
                      title: Text('${sensor.name} (${sensor.id})'),
                      subtitle: Text(
                        'Value: ${sensor.value.toStringAsFixed(2)}\n${sensor.description}',
                      ),
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
          ),
        ],
      ),
    );
  }
}
