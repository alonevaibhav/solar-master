// class Inspection {
//   final int id;
//   final int plantId;
//   final int inspectorId;
//   final String week;
//   final String day;
//   final String time;
//   final int isActive;
//   final int assignedBy;
//   final DateTime scheduleDate;
//   final String status;
//   final String notes;
//
//   Inspection({
//     required this.id,
//     required this.plantId,
//     required this.inspectorId,
//     required this.week,
//     required this.day,
//     required this.time,
//     required this.isActive,
//     required this.assignedBy,
//     required this.scheduleDate,
//     required this.status,
//     required this.notes,
//   });
//
//   factory Inspection.fromJson(Map<String, dynamic> json) {
//     return Inspection(
//       id: json['id'] ?? 0, // Provide a default value if `id` is null
//       plantId: json['plant_id'] ?? 0, // Provide a default value if `plant_id` is null
//       inspectorId: json['inspector_id'] ?? 0, // Provide a default value if `inspector_id` is null
//       week: json['week'] ?? 'Unknown', // Provide a default value if `week` is null
//       day: json['day'] ?? 'Unknown', // Provide a default value if `day` is null
//       time: json['time'] ?? '00:00:00', // Provide a default value if `time` is null
//       isActive: json['isActive'] ?? 0, // Provide a default value if `isActive` is null
//       assignedBy: json['assignedBy'] ?? 0, // Provide a default value if `assignedBy` is null
//       scheduleDate: json['schedule_date'] != null
//           ? DateTime.parse(json['schedule_date'])
//           : DateTime.now(), // Provide a default value if `schedule_date` is null
//       status: json['status'] ?? 'Unknown', // Provide a default value if `status` is null
//       notes: json['notes'] ?? 'No notes', // Provide a default value if `notes` is null
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'plant_id': plantId,
//       'inspector_id': inspectorId,
//       'week': week,
//       'day': day,
//       'time': time,
//       'isActive': isActive,
//       'assignedBy': assignedBy,
//       'schedule_date': scheduleDate.toIso8601String(),
//       'status': status,
//       'notes': notes,
//     };
//   }
// }
//
//
//
// class InspectionResponse {
//   final String message;
//   final bool success;
//   final Map<String, List<Inspection>> data;
//   final List<dynamic> errors;
//
//   InspectionResponse({
//     required this.message,
//     required this.success,
//     required this.data,
//     required this.errors,
//   });
//
//   factory InspectionResponse.fromJson(Map<String, dynamic> json) {
//     Map<String, List<Inspection>> data = {};
//     json['data'].forEach((key, value) {
//       data[key] = (value as List).map((item) => Inspection.fromJson(item)).toList();
//     });
//
//     return InspectionResponse(
//       message: json['message'],
//       success: json['success'],
//       data: data,
//       errors: json['errors'],
//     );
//   }
// }


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
  final String notes;

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
    required this.notes,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'] ?? 0,
      plantId: json['plant_id'] ?? 0,
      inspectorId: json['inspector_id'] ?? 0,
      week: (json['week'] ?? 'Unknown').toString(),
      day: (json['day'] ?? 'Unknown').toString(),
      time: (json['time'] ?? '00:00:00').toString(),
      isActive: json['isActive'] ?? 0,
      assignedBy: json['assignedBy'] ?? 0,
      scheduleDate: json['schedule_date'] != null
          ? DateTime.parse(json['schedule_date'])
          : DateTime.now(),
      status: (json['status'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
    );
  }

  // FIXED: Keep the same field names as the original JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant_id': plantId,  // Keep snake_case to match original JSON
      'inspector_id': inspectorId,  // Keep snake_case to match original JSON
      'week': week,
      'day': day,
      'time': time,
      'isActive': isActive,  // Keep camelCase to match original JSON
      'assignedBy': assignedBy,  // Keep camelCase to match original JSON
      'schedule_date': scheduleDate.toIso8601String(),  // Keep snake_case to match original JSON
      'status': status,
      'notes': notes,
    };
  }
}

class InspectionResponse {
  final String message;
  final bool success;
  final Map<String, List<Inspection>> data;
  final List<dynamic> errors;
  final String? errorMessage;

  InspectionResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
    this.errorMessage,
  });

  factory InspectionResponse.fromJson(Map<String, dynamic> json) {
    Map<String, List<Inspection>> data = {};

    // Add null check for data field
    if (json['data'] != null && json['data'] is Map) {
      (json['data'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null && value is List) {
          try {
            data[key] = value.map((item) {
              if (item != null && item is Map<String, dynamic>) {
                return Inspection.fromJson(item);
              } else {
                // Skip invalid items
                print('Warning: Skipping invalid inspection item: $item');
                return null;
              }
            }).where((inspection) => inspection != null).cast<Inspection>().toList();
          } catch (e) {
            print('Error parsing inspections for $key: $e');
            data[key] = [];
          }
        }
      });
    }

    return InspectionResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: data,
      errors: json['errors'] ?? [],
      errorMessage: json['errorMessage'],
    );
  }
}