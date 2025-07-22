import 'dart:math';

class Sensor {
  final int id;
  final String name;
  final String description;

  /// Always in Fahrenheit for this demo
  final double value;

  Sensor({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
  });

  factory Sensor.random() {
    final random = Random();
    final sensorNumber = random.nextInt(1000);
    return Sensor(
      id: Random().nextInt(1000),
      name: 'Sensor $sensorNumber',
      description: 'Some description of sensor: #$sensorNumber...',
      value: Random().nextDouble() * 100,
    );
  }
  // i was shown this early on and its become a habit for me for easy searchability
  bool matchesSearchQuery(String query) {
    String lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery);
  }

  Sensor copyWith({double? value, String? name, String? description}) {
    return Sensor(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }
}
