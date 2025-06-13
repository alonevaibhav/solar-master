class Attachment {
  final int id;
  final int ticketId;
  final String path;

  Attachment({
    required this.id,
    required this.ticketId,
    required this.path,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      ticketId: json['ticket_id'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'path': path,
    };
  }
}

class Ticket {
  final int id;
  final String title;
  final String description;
  final int? plantId;
  final int? userId;
  final int? inspectorId;
  final int? distributorAdminId;
  final String department;
  final int? createdBy;
  final String creatorType;
  final String ticketType;
  final int? cleaningId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String priority;
  final int? assignedTo;
  final String ip;
  final String creatorName;
  final String inspectorAssigned;
  final int? chatCount;
  final List<Attachment> attachments;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.plantId,
    this.userId,
    this.inspectorId,
    this.distributorAdminId,
    required this.department,
    this.createdBy,
    required this.creatorType,
    required this.ticketType,
    this.cleaningId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.assignedTo,
    required this.ip,
    required this.creatorName,
    required this.inspectorAssigned,
    this.chatCount,
    required this.attachments,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    var attachmentsList = json['attachments'] as List? ?? [];
    List<Attachment> attachments = attachmentsList.map((i) => Attachment.fromJson(i)).toList();

    return Ticket(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      plantId: json['plant_id'],
      userId: json['user_id'],
      inspectorId: json['inspector_id'],
      distributorAdminId: json['distributor_admin_id'],
      department: json['department'] ?? '',
      createdBy: json['created_by'],
      creatorType: json['creator_type'] ?? '',
      ticketType: json['ticket_type'] ?? '',
      cleaningId: json['cleaning_id'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      priority: json['priority'] ?? '',
      assignedTo: json['assigned_to'],
      ip: json['ip'] ?? '',
      creatorName: json['creator_name'] ?? '',
      inspectorAssigned: json['inspector_assigned'] ?? '',
      chatCount: json['chat_count'],
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'plant_id': plantId,
      'user_id': userId,
      'inspector_id': inspectorId,
      'distributor_admin_id': distributorAdminId,
      'department': department,
      'created_by': createdBy,
      'creator_type': creatorType,
      'ticket_type': ticketType,
      'cleaning_id': cleaningId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'priority': priority,
      'assigned_to': assignedTo,
      'ip': ip,
      'creator_name': creatorName,
      'inspector_assigned': inspectorAssigned,
      'chat_count': chatCount,
      'attachments': attachments.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketsResponse {
  final String message;
  final bool success;
  final List<Ticket> tickets;
  final int total;

  TicketsResponse({
    required this.message,
    required this.success,
    required this.tickets,
    required this.total,
  });

  factory TicketsResponse.fromJson(Map<String, dynamic> json) {
    var ticketsList = json['data']['tickets'] as List;
    List<Ticket> tickets = ticketsList.map((i) => Ticket.fromJson(i)).toList();

    return TicketsResponse(
      message: json['message'],
      success: json['success'],
      tickets: tickets,
      total: json['data']['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': {
        'tickets': tickets.map((e) => e.toJson()).toList(),
        'total': total,
      },
    };
  }
}