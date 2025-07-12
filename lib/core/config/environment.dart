enum Environment {
  development,
  production,
}

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  static final Map<Environment, String> _baseUrls = {
    Environment.development: 'http://192.168.137.1:8000',
    Environment.production: 'https://wejha-production-485b.up.railway.app',
  };

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;

  static String get baseUrl => _baseUrls[_environment]!;
} 