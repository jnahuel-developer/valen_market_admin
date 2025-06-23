enum Environment { dev, prod }

class AppConfig {
  static late Environment environment;

  static bool get isProd => environment == Environment.prod;
}
