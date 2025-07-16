import 'package:flutter/material.dart';

import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/stores/senor_list_store.dart';

class EditSensor extends StatelessWidget {
  const EditSensor({super.key, required this.sensor, required this.store});

  final Sensor sensor;
  final SensorListStore store;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: sensor.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: sensor.description,
    );
    final TextEditingController valueController = TextEditingController(
      text: sensor.value.toString(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Sensor')),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: sensor.name),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: sensor.description),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: valueController,
              decoration: InputDecoration(hintText: sensor.value.toString()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Value is required';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
                store.updateSensor(
                  sensor.copyWith(
                    name: nameController.text,
                    description: descriptionController.text,
                    value: double.parse(valueController.text),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
