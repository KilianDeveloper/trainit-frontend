enum AppModule {
  statistics,
  home,
  account,
  social;

  static AppModule byIndex(int index) {
    switch (index) {
      case 0:
        return AppModule.statistics;
      case 1:
        return AppModule.home;
      case 2:
        return AppModule.account;
      case 3:
        return AppModule.social;
      default:
        throw "Not Compatible";
    }
  }
}

extension AppModuleValidation on AppModule {
  int get navigationBarIndex {
    switch (this) {
      case AppModule.statistics:
        return 0;
      case AppModule.home:
        return 1;
      case AppModule.account:
        return 2;
      default:
        return 1;
    }
  }

  int get moduleIndex {
    switch (this) {
      case AppModule.statistics:
        return 0;
      case AppModule.home:
        return 1;
      case AppModule.account:
        return 2;
      case AppModule.social:
        return 3;
      default:
        return -1;
    }
  }
}
