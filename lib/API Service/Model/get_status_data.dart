class InspectorDataResponse {
  final String message;
  final bool success;
  final InspectorData data;
  final List<dynamic> errors;

  InspectorDataResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory InspectorDataResponse.fromJson(Map<String, dynamic> json) {
    return InspectorDataResponse(
      message: json['message'],
      success: json['success'],
      data: InspectorData.fromJson(json['data']),
      errors: json['errors'],
    );
  }
}

class InspectorData {
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
  final String? inspectorReview;
  final String? clientReview;

  InspectorData({
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
    this.inspectorReview,
    this.clientReview,
  });

  factory InspectorData.fromJson(Map<String, dynamic> json) {
    return InspectorData(
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
