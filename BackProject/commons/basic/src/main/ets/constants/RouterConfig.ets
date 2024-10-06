export class RouterConfig {
  static PACKAGE_NAME: string = 'com.example.backproject';

  static readonly SPLASH_PAGE: string = `@bundle:${RouterConfig.PACKAGE_NAME}/home/ets/pages/SplashPage`;
  static readonly LOGIN_PAGE: string = `@bundle:${RouterConfig.PACKAGE_NAME}/mine/ets/pages/LoginPage`;
}