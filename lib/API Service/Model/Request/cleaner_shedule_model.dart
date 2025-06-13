class CleanerSchedule {
  final int id;
  final int cleanerId;
  final int inspectorId;
  final int plantId;
  final String week;
  final String day;
  final String scheduleDate;
  final String cleaningStartTime;
  final String inspectionTime;
  final int duration;
  final int isActive;
  final String cleanerName;
  final String inspectorName;
  final int plantUserId;
  final int plantDistId;
  final int plantTalukaId;
  final int plantAreaId;
  final int plantTotalPanels;
  final double plantCapacityW;
  final String plantLocation;
  final dynamic plantLatlng;
  final int plantIsActive;
  final int plantIsDeleted;
  final int plantUnderMaintenance;
  final String plantInfo;
  final dynamic distributorName;
  final String talukaName;
  final String areaName;

  CleanerSchedule({
    required this.id,
    required this.cleanerId,
    required this.inspectorId,
    required this.plantId,
    required this.week,
    required this.day,
    required this.scheduleDate,
    required this.cleaningStartTime,
    required this.inspectionTime,
    required this.duration,
    required this.isActive,
    required this.cleanerName,
    required this.inspectorName,
    required this.plantUserId,
    required this.plantDistId,
    required this.plantTalukaId,
    required this.plantAreaId,
    required this.plantTotalPanels,
    required this.plantCapacityW,
    required this.plantLocation,
    required this.plantLatlng,
    required this.plantIsActive,
    required this.plantIsDeleted,
    required this.plantUnderMaintenance,
    required this.plantInfo,
    required this.distributorName,
    required this.talukaName,
    required this.areaName,
  });

  factory CleanerSchedule.fromJson(Map<String, dynamic> json) {
    return CleanerSchedule(
      id: json['id'],
      cleanerId: json['cleaner_id'],
      inspectorId: json['inspector_id'],
      plantId: json['plant_id'],
      week: json['week'],
      day: json['day'],
      scheduleDate: json['schedule_date'],
      cleaningStartTime: json['cleaning_start_time'],
      inspectionTime: json['inspection_time'],
      duration: json['duration'],
      isActive: json['isActive'],
      cleanerName: json['cleaner_name'],
      inspectorName: json['inspector_name'],
      plantUserId: json['plant_user_id'],
      plantDistId: json['plant_dist_id'],
      plantTalukaId: json['plant_taluka_id'],
      plantAreaId: json['plant_area_id'],
      plantTotalPanels: json['plant_total_panels'],
      plantCapacityW: json['plant_capacity_w'],
      plantLocation: json['plant_location'],
      plantLatlng: json['plant_latlng'],
      plantIsActive: json['plant_isActive'],
      plantIsDeleted: json['plant_isDeleted'],
      plantUnderMaintenance: json['plant_under_maintenance'],
      plantInfo: json['plant_info'],
      distributorName: json['distributor_name'],
      talukaName: json['taluka_name'],
      areaName: json['area_name'],
    );
  }
}
