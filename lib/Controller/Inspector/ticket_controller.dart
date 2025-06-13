
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/Model/Request/ticket_model.dart';
import '../../API Service/api_service.dart';

class TicketController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  final allTickets = <Map<String, dynamic>>[].obs;
  final myTickets = <Map<String, dynamic>>[].obs;
  final filteredTickets = <Map<String, dynamic>>[].obs;

  final allTicketsStats = Rxn<Map<String, dynamic>>();


  var selectedTicketTab = 'all'.obs;

  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  final showFilters = false.obs;

  final messageController = TextEditingController();
  final remarkController = TextEditingController();

  final currentTicket = Rxn<Map<String, dynamic>>();

  // Dropdown values
  final selectedPriority = Rxn<String>();
  final selectedStatus = Rxn<String>();
  final selectedDepartment = Rxn<String>();

  final List<String> priorities = ['1', '2', '3', '4', '5'];
  final List<String> statusOptions = ['open', 'closed'];
  final List<String> departments = ['services', 'technical', 'account'];

  @override
  void onInit() {
    super.onInit();
    fetchAllTickets();
    fetchMyTickets();

    debounce(searchQuery, (_) => applyFilters(),
        time: const Duration(milliseconds: 500));

    ever(selectedFilter, (_) => applyFilters());
    ever(selectedTicketTab, (_) => applyFilters());
  }

  @override
  void onClose() {
    messageController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  void initializeDropdownValues(Map<String, dynamic> ticketData) {
    selectedPriority.value = ticketData['priority']?.toString();
    selectedStatus.value = ticketData['status']?.toString();
    selectedDepartment.value = ticketData['department']?.toString();
  }

  void setTicketTab(String tab) {
    selectedTicketTab.value = tab;

    if (tab == 'all' && allTickets.isEmpty) {
      fetchAllTickets();
    } else if (tab == 'my' && myTickets.isEmpty) {
      fetchMyTickets();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleFilterVisibility() {
    showFilters.value = !showFilters.value;
  }

  void calculateAllTicketsStats() {
    try {
      // Calculate counts by priority from all tickets
      int criticalCount = allTickets.where((t) => t['priority'] == '1').length;
      int highCount = allTickets.where((t) => t['priority'] == '2').length;
      int mediumCount = allTickets.where((t) => t['priority'] == '3').length;
      int lowCount = allTickets.where((t) => t['priority'] == '4').length;
      int veryLowCount = allTickets.where((t) => t['priority'] == '5').length;

      // Calculate counts by status
      int openCount = allTickets.where((t) => t['status'] == 'open').length;
      int closedCount = allTickets.where((t) => t['status'] == 'closed').length;

      allTicketsStats.value = {
        'count': allTickets.length,
        'priority': {
          'critical': criticalCount,
          'high': highCount,
          'medium': mediumCount,
          'low': lowCount,
          'veryLow': veryLowCount,
        },
        'status': {
          'open': openCount,
          'closed': closedCount,
        }
      };
    } catch (e) {
      print('Error calculating all tickets stats: $e');
      allTicketsStats.value = {
        'count': 0,
        'priority': {
          'critical': 0,
          'high': 0,
          'medium': 0,
          'low': 0,
          'veryLow': 0,
        },
        'status': {
          'open': 0,
          'closed': 0,
        }
      };
    }
  }


  void applyFilters() {
    List<Map<String, dynamic>> currentTickets =
        selectedTicketTab.value == 'all' ? allTickets : myTickets;

    if (currentTickets.isEmpty) {
      filteredTickets.clear();
      return;
    }

    List<Map<String, dynamic>> result = List.from(currentTickets);

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((ticket) {
        return (ticket['title']?.toString().toLowerCase().contains(query) ??
                false) ||
            (ticket['description']?.toString().toLowerCase().contains(query) ??
                false) ||
            (ticket['name']?.toString().toLowerCase().contains(query) ??
                false) ||
            (ticket['location']?.toString().toLowerCase().contains(query) ??
                false);
      }).toList();
    }

    if (selectedFilter.value != 'All') {
      switch (selectedFilter.value) {
        case 'Ticket Open':
          result =
              result.where((ticket) => ticket['status'] == 'open').toList();
          break;
        case 'Ticket Closed':
          result =
              result.where((ticket) => ticket['status'] == 'closed').toList();
          break;
        case 'Priority Critical':
          result = result.where((ticket) => ticket['priority'] == '1').toList();
          break;
        case 'Priority High':
          result = result.where((ticket) => ticket['priority'] == '2').toList();
          break;
        case 'Priority Medium':
          result = result.where((ticket) => ticket['priority'] == '3').toList();
          break;
        case 'Priority Low':
          result = result.where((ticket) => ticket['priority'] == '4').toList();
          break;
        case 'Priority Very Low':
          result = result.where((ticket) => ticket['priority'] == '5').toList();
          break;
      }
    }

    filteredTickets.value = result;
  }

  // Update your existing fetchAllTickets method to call calculateTodaysTickets
  Future<void> fetchAllTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('No UID found');
      }

      final response = await ApiService.get<TicketsResponse>(
        endpoint: "/api/tickets/inspector/$inspectorId",
        fromJson: (json) => TicketsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        allTickets.value = response.data!.tickets.map((ticket) {
          return {
            'id': ticket.id.toString(),
            'title': ticket.title,
            'description': ticket.description,
            'plant_id': ticket.plantId,
            'user_id': ticket.userId,
            'inspector_id': ticket.inspectorId,
            'distributor_admin_id': ticket.distributorAdminId,
            'department': ticket.department,
            'created_by': ticket.createdBy,
            'creator_type': ticket.creatorType,
            'ticket_type': ticket.ticketType,
            'cleaning_id': ticket.cleaningId,
            'status': ticket.status,
            'createdAt': ticket.createdAt.toString(),
            'updatedAt': ticket.updatedAt.toString(),
            'priority': ticket.priority,
            'assigned_to': ticket.assignedTo,
            'ip': ticket.ip,
            'creator_name': ticket.creatorName,
            'inspector_assigned': ticket.inspectorAssigned,
            'chat_count': ticket.chatCount,
            'attachments': ticket.attachments,
          };
        }).toList();

        // Calculate all tickets stats after fetching all tickets
        calculateAllTicketsStats();

        if (selectedTicketTab.value == 'all') {
          applyFilters();
        }
      } else {
        errorMessage.value =
            response.errorMessage ?? 'Failed to load all tickets';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load all tickets: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('No UID found');
      }

      final response = await ApiService.get<TicketsResponse>(
        endpoint: "/api/tickets/created-by-inspector/$inspectorId",
        fromJson: (json) => TicketsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        myTickets.value = response.data!.tickets.map((ticket) {
          return {
            'id': ticket.id.toString(),
            'title': ticket.title,
            'description': ticket.description,
            'plant_id': ticket.plantId,
            'user_id': ticket.userId,
            'inspector_id': ticket.inspectorId,
            'distributor_admin_id': ticket.distributorAdminId,
            'department': ticket.department,
            'created_by': ticket.createdBy,
            'creator_type': ticket.creatorType,
            'ticket_type': ticket.ticketType,
            'cleaning_id': ticket.cleaningId,
            'status': ticket.status,
            'createdAt': ticket.createdAt.toString(),
            'updatedAt': ticket.updatedAt.toString(),
            'priority': ticket.priority,
            'assigned_to': ticket.assignedTo,
            'ip': ticket.ip,
            'creator_name': ticket.creatorName,
            'inspector_assigned': ticket.inspectorAssigned,
            'chat_count': ticket.chatCount,
            'attachments': ticket.attachments,
          };
        }).toList();

        if (selectedTicketTab.value == 'my') {
          applyFilters();
        }
      } else {
        errorMessage.value =
            response.errorMessage ?? 'Failed to load my tickets';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load my tickets: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTicketDetails(Map<String, dynamic> ticketData) async {
    try {
      isLoading.value = true;

      final ticketId = ticketData['id']; // Extract the id from ticketData

      final response = await ApiService.put<Map<String, dynamic>>(
        endpoint: '/api/tickets/update/inspector/$ticketId',
        body: {
          'status': selectedStatus.value,
          'priority': selectedPriority.value,
          'department': selectedDepartment.value,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final updatedTicket = response.data!;
        final allIndex = allTickets.indexWhere((t) => t['id'] == ticketId);
        if (allIndex != -1) {
          allTickets[allIndex] = updatedTicket;
        }

        final myIndex = myTickets.indexWhere((t) => t['id'] == ticketId);
        if (myIndex != -1) {
          myTickets[myIndex] = updatedTicket;
        }

        currentTicket.value = updatedTicket;
        applyFilters();
       await refreshAllTickets();
        Get.back(); // Navigate back after updating

        Get.snackbar(
          'Success',
          'Ticket updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to update ticket';
        Get.snackbar(
          'Error',
          errorMessage.value!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to update ticket: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a message',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Message sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      messageController.clear();
    } catch (e) {
      errorMessage.value = 'Failed to send message: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRemark() async {
    if (remarkController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a remark',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      if (currentTicket.value != null) {
        final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
        updatedTicket['remark'] = remarkController.text;

        final allIndex =
            allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (allIndex != -1) {
          allTickets[allIndex] = updatedTicket;
        }

        final myIndex =
            myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (myIndex != -1) {
          myTickets[myIndex] = updatedTicket;
        }

        currentTicket.value = updatedTicket;
        applyFilters();

        Get.snackbar(
          'Success',
          'Remark added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        remarkController.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to add remark: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to add remark',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reopenTicket() async {
    if (currentTicket.value == null) {
      Get.snackbar(
        'Error',
        'No ticket selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentTicket.value!['status'] == 'open') {
      Get.snackbar(
        'Information',
        'Ticket is already open',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
      updatedTicket['status'] = 'open';
      updatedTicket['closed'] = '';

      final allIndex =
          allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (allIndex != -1) {
        allTickets[allIndex] = updatedTicket;
      }

      final myIndex =
          myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (myIndex != -1) {
        myTickets[myIndex] = updatedTicket;
      }

      currentTicket.value = updatedTicket;
      applyFilters();

      Get.snackbar(
        'Success',
        'Ticket reopened successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to reopen ticket: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to reopen ticket',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void generateTicketImage() {
    Get.snackbar(
      'Feature',
      'Generating ticket image...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case '1':
        return const Color(0xFFDC2626);
      case '2':
        return const Color(0xFFEA580C);
      case '3':
        return const Color(0xFFCA8A04);
      case '4':
        return const Color(0xFF059669);
      case '5':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFFCA8A04);
    }
  }

  String getPriorityLabel(String priority) {
    switch (priority) {
      case '1':
        return 'Critical';
      case '2':
        return 'High';
      case '3':
        return 'Medium';
      case '4':
        return 'Low';
      case '5':
        return 'Very Low';
      default:
        return 'Medium';
    }
  }

  void callContact(String phoneNumber) {
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToLocation(String location) {
    Get.snackbar(
      'Navigation',
      'Navigating to $location',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> refreshTickets() async {
    if (selectedTicketTab.value == 'all') {
      await fetchAllTickets();
    } else {
      await fetchMyTickets();
    }
  }

  Future<void> refreshAllTickets() async {
    await Future.wait([
      fetchAllTickets(),
      fetchMyTickets(),
    ]);
  }
}
