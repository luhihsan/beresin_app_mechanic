// lib/data/models/external_procurement_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/external_procurement_entity.dart';

part 'external_procurement_model.freezed.dart';
part 'external_procurement_model.g.dart';

@freezed
class ExternalProcurementModel with _$ExternalProcurementModel {
  const factory ExternalProcurementModel({
    required String partName,
    required String supplierStore,
    required int cost,
    required String receiptPhotoUrl,
  }) = _ExternalProcurementModel;

  const ExternalProcurementModel._();

  /// Mengonversi dari format JSON map milik Firestore
  factory ExternalProcurementModel.fromJson(Map<String, dynamic> json) =>
      _$ExternalProcurementModelFromJson(json);

  /// Mapping dari Data Model (DTO) ke Domain Entity
  ExternalProcurementEntity toEntity() {
    return ExternalProcurementEntity(
      partName: partName,
      supplierStore: supplierStore,
      cost: cost,
      receiptPhotoUrl: receiptPhotoUrl,
    );
  }

  /// Mapping dari Domain Entity kembali ke Data Model
  factory ExternalProcurementModel.fromEntity(ExternalProcurementEntity entity) {
    return ExternalProcurementModel(
      partName: entity.partName,
      supplierStore: entity.supplierStore,
      cost: entity.cost.round(), // Menjamin pembulatan diselesaikan di client side
      receiptPhotoUrl: entity.receiptPhotoUrl,
    );
  }
}