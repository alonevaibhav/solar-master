// models/schedule_model.dart
class Schedule {
  final int id;
  final int plantId;
  final int inspectorId;
  final String week;
  final String day;
  final String time;
  final int isActive;
  final int assignedBy;
  final String scheduleDate;
  final String status;
  final String? notes;

  Schedule({
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
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? 0,
      plantId: json['plant_id'] ?? 0,
      inspectorId: json['inspector_id'] ?? 0,
      week: json['week']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      time: json['time']?.toString() ?? '00:00:00',
      isActive: json['isActive'] ?? 0,
      assignedBy: json['assignedBy'] ?? 0,
      scheduleDate: json['schedule_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant_id': plantId,
      'inspector_id': inspectorId,
      'week': week,
      'day': day,
      'time': time,
      'isActive': isActive,
      'assignedBy': assignedBy,
      'schedule_date': scheduleDate,
      'status': status,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'Schedule(id: $id, plantId: $plantId, week: $week, day: $day, status: $status)';
  }
}

class ScheduleResponse {
  final String message;
  final bool success;
  final Map<String, List<Schedule>> data;
  final List<String> errors;

  ScheduleResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    Map<String, List<Schedule>> scheduleData = {};

    if (json['data'] != null && json['data'] is Map) {
      Map<String, dynamic> dataMap = json['data'];
      dataMap.forEach((key, value) {
        if (value is List) {
          scheduleData[key] = value
              .map((item) => Schedule.fromJson(item))
              .toList();
        }
      });
    }

    return ScheduleResponse(
      message: json['message']?.toString() ?? '',
      success: json['success'] ?? false,
      data: scheduleData,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }

  // Get all schedules in a flat list
  List<Schedule> getAllSchedules() {
    List<Schedule> allSchedules = [];
    data.values.forEach((scheduleList) {
      allSchedules.addAll(scheduleList);
    });
    return allSchedules;
  }

  // Get schedules by week
  List<Schedule> getSchedulesByWeek(String week) {
    return data[week] ?? [];
  }

  // Get all week names
  List<String> getWeekNames() {
    return data.keys.toList()..sort();
  }
}