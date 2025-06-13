class Plant {
  final int id;
  final String name;
  final String uuid;
  final int userId;
  final int distributorId;
  final int distributorAdminId;
  final int inspectorId;
  final int cleanerId;
  final int stateId;
  final int distId;
  final int talukaId;
  final int areaId;
  final String address;
  final int totalPanels;
  final double capacityW;
  final double areaSqurM;
  final String location;
  final dynamic latlng;
  final int isActive;
  final int isDeleted;
  final String createAt;
  final dynamic updatedAt;
  final int installedBy;
  final int underMaintenance;
  final String info;
  final String inspectorName;
  final String cleanerName;
  final String installedByName;
  final String stateName;
  final String districtName;
  final String talukaName;
  final String areaName;
  final String autoCleanTime;
  final bool isOnline;

  Plant({
    required this.id,
    required this.name,
    required this.uuid,
    required this.userId,
    required this.distributorId,
    required this.distributorAdminId,
    required this.inspectorId,
    required this.cleanerId,
    required this.stateId,
    required this.distId,
    required this.talukaId,
    required this.areaId,
    required this.address,
    required this.totalPanels,
    required this.capacityW,
    required this.areaSqurM,
    required this.location,
    required this.latlng,
    required this.isActive,
    required this.isDeleted,
    required this.createAt,
    required this.updatedAt,
    required this.installedBy,
    required this.underMaintenance,
    required this.info,
    required this.inspectorName,
    required this.cleanerName,
    required this.installedByName,
    required this.stateName,
    required this.districtName,
    required this.talukaName,
    required this.areaName,
    required this.autoCleanTime,
    required this.isOnline,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'] ?? '',
      uuid: json['uuid'] ?? '',
      userId: json['user_id'] ?? 0,
      distributorId: json['distributor_id'] ?? 0,
      distributorAdminId: json['distributor_admin_id'] ?? 0,
      inspectorId: json['inspector_id'] ?? 0,
      cleanerId: json['cleaner_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      distId: json['dist_id'] ?? 0,
      talukaId: json['taluka_id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      address: json['address'] ?? '',
      totalPanels: json['total_panels'] ?? 0,
      // FIX: Safe conversion for double fields
      capacityW: (json['capacity_w'] as num?)?.toDouble() ?? 0.0,
      areaSqurM: (json['area_squrM'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] ?? '',
      latlng: json['latlng'],
      isActive: json['isActive'] ?? 0,
      isDeleted: json['isDeleted'] ?? 0,
      createAt: json['createAt'] ?? '',
      updatedAt: json['UpdatedAt'],
      installedBy: json['installed_by'] ?? 0,
      underMaintenance: json['under_maintenance'] ?? 0,
      info: json['info'] ?? '',
      inspectorName: json['inspector_name'] ?? '',
      cleanerName: json['cleaner_name'] ?? '',
      installedByName: json['installed_by_name'] ?? '',
      stateName: json['state_name'] ?? '',
      districtName: json['district_name'] ?? '',
      talukaName: json['taluka_name'] ?? '',
      areaName: json['area_name'] ?? '',
      autoCleanTime: json['autoCleanTime'] ?? '',
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'uuid': uuid,
      'user_id': userId,
      'distributor_id': distributorId,
      'distributor_admin_id': distributorAdminId,
      'inspector_id': inspectorId,
      'cleaner_id': cleanerId,
      'state_id': stateId,
      'dist_id': distId,
      'taluka_id': talukaId,
      'area_id': areaId,
      'address': address,
      'total_panels': totalPanels,
      'capacity_w': capacityW,
      'area_squrM': areaSqurM,
      'location': location,
      'latlng': latlng,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createAt': createAt,
      'UpdatedAt': updatedAt,
      'installed_by': installedBy,
      'under_maintenance': underMaintenance,
      'info': info,
      'inspector_name': inspectorName,
      'cleaner_name': cleanerName,
      'installed_by_name': installedByName,
      'state_name': stateName,
      'district_name': districtName,
      'taluka_name': talukaName,
      'area_name': areaName,
      'autoCleanTime': autoCleanTime,
      'isOnline': isOnline,
    };
  }
}