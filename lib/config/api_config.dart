const String kDbNameGuid = '51ea0438-72af-4846-8022-2698882a6774'; 
const String kBaseUrl = 'https://meal-db-sandy.vercel.app';
const Map<String, String> kHeaders = {
  'X-DB-NAME': kDbNameGuid,
  'Content-Type': 'application/json',
};

class ApiEndpoints {
  static const String meals = '/meals';
  static const String categories = '/categories';
}