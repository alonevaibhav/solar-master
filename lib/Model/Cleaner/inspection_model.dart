class InspectionModel {
  final String id;
  final String plantName;
  final String location;
  final bool isCompleted;
  final String? additionalDetails;

  // Additional fields for task detail view
  final String ownerPhone;
  final String autoCleanTime;
  final int completedPoints;
  final int pendingPoints;
  final int totalPoints;
  final List<String> valves;

  InspectionModel({
    required this.id,
    required this.plantName,
    required this.location,
    required this.isCompleted,
    this.additionalDetails,
    this.ownerPhone = '',
    this.autoCleanTime = '',
    this.completedPoints = 0,
    this.pendingPoints = 0,
    this.totalPoints = 0,
    this.valves = const [],
  });

  // JSON serialization
  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'] ?? '',
      plantName: json['plantName'] ?? '',
      location: json['location'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      additionalDetails: json['additionalDetails'],
      ownerPhone: json['ownerPhone'] ?? '',
      autoCleanTime: json['autoCleanTime'] ?? '',
      completedPoints: json['completedPoints'] ?? 0,
      pendingPoints: json['pendingPoints'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      valves: json['valves'] != null
          ? List<String>.from(json['valves'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantName': plantName,
      'location': location,
      'isCompleted': isCompleted,
      'additionalDetails': additionalDetails,
      'ownerPhone': ownerPhone,
      'autoCleanTime': autoCleanTime,
      'completedPoints': completedPoints,
      'pendingPoints': pendingPoints,
      'totalPoints': totalPoints,
      'valves': valves,
    };
  }

  // Method to copy with modifications
  InspectionModel copyWith({
    String? id,
    String? plantName,
    String? location,
    bool? isCompleted,
    String? additionalDetails,
    String? ownerPhone,
    String? autoCleanTime,
    int? completedPoints,
    int? pendingPoints,
    int? totalPoints,
    List<String>? valves,
  }) {
    return InspectionModel(
      id: id ?? this.id,
      plantName: plantName ?? this.plantName,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      autoCleanTime: autoCleanTime ?? this.autoCleanTime,
      completedPoints: completedPoints ?? this.completedPoints,
      pendingPoints: pendingPoints ?? this.pendingPoints,
      totalPoints: totalPoints ?? this.totalPoints,
      valves: valves ?? this.valves,
    );
  }
}