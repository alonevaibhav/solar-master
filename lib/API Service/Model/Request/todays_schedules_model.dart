class Inspection {
  final int id;
  final int plantId;
  final int inspectorId;
  final String week;
  final String day;
  final String time;
  final int isActive;
  final int assignedBy;
  final DateTime scheduleDate;
  final String status;
  final String? notes;
  final String inspectorName;
  final String plantName;
  final String plantAddress;
  final String plantLocation;
  final int totalPanels;
  final double capacityW;
  final double areaSqurM;
  final dynamic latlng;
  final int plantIsActive;
  final int plantIsDeleted;
  final String cleanerName;
  final String stateName;
  final String? distributorName;
  final String talukaName;
  final String areaName;

  Inspection({
    required this.id,
    required this.plantId,
    required this.inspectorId,
    required this.week,
    required this.day,
    required this.time,
    required this.isActive,
    required this.assignedBy,
    required this.scheduleDate,
    required this.status,
    this.notes,
    required this.inspectorName,
    required this.plantName,
    required this.plantAddress,
    required this.plantLocation,
    required this.totalPanels,
    required this.capacityW,
    required this.areaSqurM,
    this.latlng,
    required this.plantIsActive,
    required this.plantIsDeleted,
    required this.cleanerName,
    required this.stateName,
    this.distributorName,
    required this.talukaName,
    required this.areaName,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'],
      plantId: json['plant_id'],
      inspectorId: json['inspector_id'],
      week: json['week'],
      day: json['day'],
      time: json['time'],
      isActive: json['isActive'],
      assignedBy: json['assignedBy'],
      scheduleDate: DateTime.parse(json['schedule_date']),
      status: json['status'],
      notes: json['notes'],
      inspectorName: json['inspector_name'],
      plantName: json['plant_name'],
      plantAddress: json['plant_address'],
      plantLocation: json['plant_location'],
      totalPanels: json['total_panels'],
      capacityW: json['capacity_w'],
      areaSqurM: json['area_squrM'],
      latlng: json['latlng'],
      plantIsActive: json['plant_isActive'],
      plantIsDeleted: json['plant_isDeleted'],
      cleanerName: json['cleaner_name'],
      stateName: json['state_name'],
      distributorName: json['distributor_name'],
      talukaName: json['taluka_name'],
      areaName: json['area_name'],
    );
  }
}
