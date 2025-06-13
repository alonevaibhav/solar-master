class CleanerReport {
  final int id;
  final int scheduleId;
  final int plantId;
  final DateTime date;
  final String time;
  final DateTime cleaningDate;
  final String cleaningTime;
  final String status;
  final int inspectedBy;
  final dynamic inspectorSchedule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic inspectorReview;
  final dynamic clientReview;

  CleanerReport({
    required this.id,
    required this.scheduleId,
    required this.plantId,
    required this.date,
    required this.time,
    required this.cleaningDate,
    required this.cleaningTime,
    required this.status,
    required this.inspectedBy,
    required this.inspectorSchedule,
    required this.createdAt,
    required this.updatedAt,
    required this.inspectorReview,
    required this.clientReview,
  });

  factory CleanerReport.fromJson(Map<String, dynamic> json) {
    return CleanerReport(
      id: json['id'],
      scheduleId: json['schedule_id'],
      plantId: json['plant_id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      cleaningDate: DateTime.parse(json['cleaning_date']),
      cleaningTime: json['cleaning_time'],
      status: json['status'],
      inspectedBy: json['inspected_by'],
      inspectorSchedule: json['inspector_schedule'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      inspectorReview: json['inspector_review'],
      clientReview: json['client_review'],
    );
  }
}

class ApiResponseModel {
  final String message;
  final bool success;
  final CleanerReport data;
  final List<dynamic> errors;

  ApiResponseModel({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      message: json['message'],
      success: json['success'],
      data: CleanerReport.fromJson(json['data']),
      errors: json['errors'],
    );
  }
}
