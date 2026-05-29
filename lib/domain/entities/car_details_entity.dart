// lib/domain/entities/car_details_entity.dart
class CarDetailsEntity {
  final String carId;
  final String brand;
  final String type;
  final String plate;
  final String year;
  final String color;
  final String engineType;
  final String transmission;

  const CarDetailsEntity({
    required this.carId,
    required this.brand,
    required this.type,
    required this.plate,
    required this.year,
    required this.color,
    required this.engineType,
    required this.transmission,
  });
}