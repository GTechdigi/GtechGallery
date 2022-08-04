import '../../Config.dart';

// App Helper
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/21
class AppHelper {

  static String getAppName(String buildName) {
    String appName = buildName;
    appName = _replaceAppNameKeywords(appName, "dev");
    appName = _replaceAppNameKeywords(appName, "Dev");
    appName = _replaceAppNameKeywords(appName, "DEV");
    appName = _replaceAppNameKeywords(appName, "test");
    appName = _replaceAppNameKeywords(appName, "Test");
    appName = _replaceAppNameKeywords(appName, "TEST");
    return appName;
  }

  static String _replaceAppNameKeywords(String buildName, String keywords) {
    String appName = buildName;
    if(buildName.lastIndexOf(keywords) > 0) {
      appName = buildName.substring(0, buildName.lastIndexOf(keywords));
    }
    appName = appName.trimRight();

    if(appName.endsWith("-")) {
      appName = appName.substring(0, appName.length - 1);
    }

    if(appName.endsWith("_")) {
      appName = appName.substring(0, appName.length - 1);
    }

    return appName;
  }
  
  static String getAppIcon(String buildIcon) {
    return "${Config.baseUrlAppIcons}$buildIcon";
  }
}