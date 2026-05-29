// lib/data/models/car_details_model.dart
import '../../domain/entities/car_details_entity.dart';

class CarDetailsModel {
  final String carId;
  final String brand;
  final String type;
  final String plate;
  final String year;
  final String color;
  final String engineType;
  final String transmission;

  const CarDetailsModel({
    required this.carId,
    required this.brand,
    required this.type,
    required this.plate,
    required this.year,
    required this.color,
    required this.engineType,
    required this.transmission,
  });

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    return CarDetailsModel(
      carId: json['carId'] ?? '',
      brand: json['brand'] ?? '',
      type: json['type'] ?? '',
      plate: json['plate'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
      engineType: json['engineType'] ?? '',
      transmission: json['transmission'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'brand': brand,
      'type': type,
      'plate': plate,
      'year': year,
      'color': color,
      'engineType': engineType,
      'transmission': transmission,
    };
  }

  CarDetailsEntity toEntity() {
    return CarDetailsEntity(
      carId: carId,
      brand: brand,
      type: type,
      plate: plate,
      year: year,
      color: color,
      engineType: engineType,
      transmission: transmission,
    );
  }

  factory CarDetailsModel.fromEntity(CarDetailsEntity entity) {
    return CarDetailsModel(
      carId: entity.carId,
      brand: entity.brand,
      type: entity.type,
      plate: entity.plate,
      year: entity.year,
      color: entity.color,
      engineType: entity.engineType,
      transmission: entity.transmission,
    );
  }
}