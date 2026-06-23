class ApiConstants {
  ApiConstants._();

  // Supabase
  static const String supabaseUrl = 'https://iuphhdjszrmragaxltxr.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1cGhoZGpzenJtcmFnYXhsdHhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIxOTM2NzQsImV4cCI6MjA5Nzc2OTY3NH0.x3dS5tNomEfJF1x0ul9kpugf5bENzf2NSksE-CeVZRQ';

  // Gemini AI
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String geminiModel = 'gemini-3.5-flash';

  // OpenWeatherMap
  static const String owmApiKey = 'YOUR_OWM_API_KEY';
  static const String owmBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String owmWeatherEndpoint = '/weather';
  static const String owmAqiEndpoint = '/air_pollution';

  // Google Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Supabase Storage
  static const String scanImagesBucket = 'scan-images';

  // Google Sign-In
  static const String googleWebClientId = '745237385380-a7dfl0qeq14rimu9ept8eua0kfbtjj9d.apps.googleusercontent.com';
}
