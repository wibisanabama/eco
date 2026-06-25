class ApiConstants {
  ApiConstants._();

  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey =
      'YOUR_SUPABASE_ANON_KEY';

  // Gemini AI (image analysis, daily tip, news)
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String geminiModel = 'gemini-3.5-flash';

  // Groq AI (Eco Assistant chatbot) — OpenAI-compatible chat completions
  static const String groqApiKey =
      'YOUR_GROQ_API_KEY';
  static const String groqModel = 'openai/gpt-oss-120b';
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqChatEndpoint = '/chat/completions';

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
  static const String googleWebClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID';
}
