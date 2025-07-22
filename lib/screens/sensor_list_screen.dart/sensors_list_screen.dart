import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/bloc/sensors_cubit.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';

/*
I mentioned in the interview, but I like using pure stateless widgets 
for UI where possible, leaving allll state management to the bloc. 
I use this Screen/Content combo so the Bloc is only available on the screen, 
even though its technically overkill for a one-page app. Typically I'd break 
out certain components into their own widgets/components dir, but I tried to 
stay true to the spirit of the task and not over-engineer just because i have
extra time, and the files under 200 lines.

Typically Id also extrapolate a lot of these hardcoded numbers for 
padding/fontsize/etc, but for time i just put what looked good
*/

class SensorsListScreen extends StatelessWidget {
  const SensorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SensorsCubit(SensorRepository())..initialize(),
      child: SensorsListScreenContent(),
    );
  }
}

class SensorsListScreenContent extends StatelessWidget {
  const SensorsListScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<SensorsCubit, SensorsState>(
        builder: (context, state) => switch (state.status) {
          StateStatus.initial => getInitialWidget(),
          StateStatus.loading => getLoadingWidget(),
          StateStatus.loaded => getLoadedWidget(
            state,
            context.read<SensorsCubit>().searchSensors,
          ),
          StateStatus.error => getErrorWidget(
            state.errorMessage ?? 'Unknown error',
          ),
        },
      ),
    );
  }

  Widget getLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget getErrorWidget(String errorMessage) {
    return Center(child: Text(errorMessage));
  }

  Widget getInitialWidget() {
    return const Center(child: Text("Welcome! App should be loading shortly"));
  }

  Widget getLoadedWidget(SensorsState state, Function(String) searchSensors) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search sensors...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: searchSensors,
          ),
        ),
        Expanded(
          child: state.filteredSensors.isEmpty
              ? const Center(
                  child: Text(
                    'No sensors found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: state.filteredSensors.length,
                  itemBuilder: (context, index) {
                    final sensor = state.filteredSensors[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: Text(
                            '#${sensor.id}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        title: Text(
                          sensor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(sensor.description),
                        trailing: Text(
                          '${sensor.value.toStringAsFixed(1)}°F',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _showEditDialog(context, sensor),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, Sensor sensor) {
    final nameController = TextEditingController(text: sensor.name);
    final descController = TextEditingController(text: sensor.description);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Sensor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(dialogContext).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SensorsCubit>().updateSensorDetails(
                sensor.copyWith(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
