// final String baseUrl = "http://localhost:8000/";
String baseUrl = "https://7hmgmjzr-3000.inc1.devtunnels.ms";



/// ** AUTH URLs  ***

String loginUrl = "/worker/login";

/// ** CLEANER URLs ***

String getCleanerPlantsInfoUrl(int inspectorId) => "/api/plant/cleaner/$inspectorId";

String getTodayScheduleCleaner(int inspectorId) => "/schedules/cleaner-schedules/today/$inspectorId";



/// ** INSPECTOR URLs ***

String getInspectorPlantsUrl(int inspectorId) => "/api/plant/inspector/$inspectorId";

String getAllPlant(int inspectorId) => "/schedules/inspector-schedules/inspector/$inspectorId/weekly";

String getTodayScheduleInspector(int inspectorId) => "/schedules/inspector-schedules/today/$inspectorId";

String getCleanerReport(int inspectorId) => "/api/report/cleaner-reports/inspector/$inspectorId";

String getInspectorDataByID(int inspectionCardId) => "/api/report/cleaner-reports/inspector/schedule/$inspectionCardId";


String getUpdateInspectorDataEndpoint(int inspectionCardId) => "/api/report/cleaner-reports/inspector/$inspectionCardId";

String getAllTicket(int inspectorId) => "/api/tickets/inspector/$inspectorId";

//chat

String getChatByID(int ticketId) => "/ticketChat/chat/ticket/inspector/$ticketId";

String postChatByIDInspector(int ticketId) => "/ticketChat/chat/inspector";






String getMyTicket(int inspectorId) => "/api/tickets/created-by-inspector/$inspectorId";

String raiseTicket = "/api/tickets/create/inspector";










