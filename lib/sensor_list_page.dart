import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:interview_project/edit_sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:interview_project/stores/senor_list_store.dart';

class SensorListPage extends StatelessWidget {
  const SensorListPage({super.key});

  Icon _getSortIcon(TemperatureSort sortState) {
    switch (sortState) {
      case TemperatureSort.ascending:
        return const Icon(Icons.arrow_upward);
      case TemperatureSort.descending:
        return const Icon(Icons.arrow_downward);
      case TemperatureSort.none:
        return const Icon(Icons.unfold_more);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorRepository = SensorRepository();
    final sensorListStore = SensorListStore(sensorRepository);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor List'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search Sensors',
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.teal,
                          width: 2,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      sensorListStore.searchSensors(value);
                    },
                    onEditingComplete: () {
                      sensorListStore.searchSensors(
                        sensorListStore.searchQuery,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sensorListStore.searchSensors(sensorListStore.searchQuery);
                  },
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sort, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Sort by temperature',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Observer(
                      builder: (context) =>
                          sensorListStore.temperatureSortState !=
                              TemperatureSort.none
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: () {
                                  sensorListStore.resetTemperatureSort();
                                },
                                icon: const Icon(Icons.clear),
                                tooltip: 'Clear sorting',
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Observer(
                      builder: (context) => IconButton(
                        onPressed: () {
                          sensorListStore.sortSensorsByTemperature();
                        },
                        icon: _getSortIcon(
                          sensorListStore.temperatureSortState,
                        ),
                        tooltip: sensorListStore.sortStateDescription,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (context) {
                if (sensorListStore.sensors.isEmpty) {
                  return const Center(child: Text('No sensors found'));
                }
                return ListView.builder(
                  itemCount: sensorListStore.sensors.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          sensorListStore.sensors[index]?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          sensorListStore.sensors[index]?.description ?? '',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${sensorListStore.sensors[index]?.value.toStringAsFixed(3) ?? ''}°F',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSensor(
                                sensor: sensorListStore.sensors[index]!,
                                store: sensorListStore,
                              ),
                            ),
                          );
                        },
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
