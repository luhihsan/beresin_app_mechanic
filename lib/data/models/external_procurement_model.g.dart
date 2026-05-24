// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_procurement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExternalProcurementModelImpl _$$ExternalProcurementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExternalProcurementModelImpl(
      partName: json['partName'] as String,
      supplierStore: json['supplierStore'] as String,
      cost: (json['cost'] as num).toInt(),
      receiptPhotoUrl: json['receiptPhotoUrl'] as String,
    );

Map<String, dynamic> _$$ExternalProcurementModelImplToJson(
        _$ExternalProcurementModelImpl instance) =>
    <String, dynamic>{
      'partName': instance.partName,
      'supplierStore': instance.supplierStore,
      'cost': instance.cost,
      'receiptPhotoUrl': instance.receiptPhotoUrl,
    };
