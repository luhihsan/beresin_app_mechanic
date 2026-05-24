class ExternalProcurementEntity {
  final String partName;
  final String supplierStore;
  final int cost; 
  final String receiptPhotoUrl;

  const ExternalProcurementEntity({
    required this.partName,
    required this.supplierStore,
    required this.cost,
    required this.receiptPhotoUrl,
  });
}