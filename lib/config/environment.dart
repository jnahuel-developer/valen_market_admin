enum Environment { dev, prod }

class AppConfig {
  static late Environment environment;

  static bool get isProd => environment == Environment.prod;
}

const String GOOGLE_SIGN_IN_CLIENT_ID_DEV =
    '1089321285838-jvb3agltggcimsc1hgbiq6lkh11g7kr4.apps.googleusercontent.com';
