// App DB Manager
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/1import 'dart:io';

import 'dart:developer';

import '../../Config.dart';
import '../Model/AppModle.dart';
import 'DatabaseHelper.dart';

class AppDBManager {
  static List<AppItem> getMapAppList(List<dynamic>? contactList) {
    List<AppItem> appList = [];
    if(contactList != null) {
      for (var element in contactList) {
        if (element is Map) {
          var appItem = _getAppFromDBRow(element);
          appList.add(appItem);
        }
      }
    }

    return appList;
  }

  static Future<List<AppItem>> getDBAppList() async {
    var contactList = await DatabaseHelper.instance
        .queryAllRows(DatabaseHelper.gtAppListTable);
    return getMapAppList(contactList);
  }

  static Future insertOrUpdateDBAppList(List<AppItem> appItem) async {
    for (var element in appItem) {
      Map<String, dynamic> row = _getDBRowFromApp(element);

      Map<String, dynamic> where = {
        'appKey': element.appKey,
      };

      DatabaseHelper.instance
          .insertOrUpdate(row, DatabaseHelper.gtAppListTable, where);
    }
  }

  static Future<List<AppItem>> getDBAppBuildListWhere(AppItem appItem, Map<String, dynamic> where) async {
    var contactList = await DatabaseHelper.instance
        .queryRowsWhereOrderBy(DatabaseHelper.gtAppBuildListTable, where, "buildBuildVersion DESC");
    return getMapAppList(contactList);
  }

  static Future<List<AppItem>> getDBAppBuildList(AppItem appItem) async {
    return getDBAppBuildListWhere(appItem, {"buildIdentifier": appItem.buildIdentifier});
  }

  static Future insertOrUpdateDBAppBuildList(List<AppItem> appItem) async {
    for (var element in appItem) {
      Map<String, dynamic> row = _getDBRowFromApp(element);

      String buildFileName = element.buildFileName.toString().toUpperCase();
      if(buildFileName.contains(Config.buildEnvTest)) {
        row["buildEnv"] = Config.buildEnvTest;
      } else if(buildFileName.contains(Config.buildEnvUat)) {
        row["buildEnv"] = Config.buildEnvUat;
      } else {
        row["buildEnv"] = Config.buildEnvDev;
      }

      Map<String, dynamic> where = {
        'buildKey': element.buildKey
      };

      var index = await DatabaseHelper.instance.insertOrUpdate(row, DatabaseHelper.gtAppBuildListTable, where);
      log("insertOrUpdateDBAppBuildList $index\n\n");
    }
  }

  static Future<AppDetailItem?> getAppDetailBuildByEnv(String buildIdentifier, String env) async {

    Map<String, dynamic> where = {
      "buildIdentifier": buildIdentifier,
      'buildEnv': env
    };

    var contactList = await DatabaseHelper.instance
        .queryRowsWhere(DatabaseHelper.gtAppBuildListTable, where, limit: 1);
    if(contactList != null && contactList.isNotEmpty) {
      return _getAppFromDBRow(contactList[0]);
    } else {
      return null;
    }
  }

  static AppDetailItem _getAppFromDBRow(Map element) {
    return AppDetailItem(
        element['appKey'],
        element['buildKey'],
        element['buildName'],
        element['buildIcon'],
        element['buildVersion'],
        element['buildVersionNo'],
        element['buildBuildVersion'],
        element['buildCreated'],
        element['buildType'],
        element['buildIdentifier'],
        element['buildFileSize'],
        element['buildFileName'],
        element['buildEnv']);
  }

  static Map<String, dynamic> _getDBRowFromApp(AppItem element) {
    var row = {
      'appKey': element.appKey?? "",
      'buildKey': element.buildKey,
      'buildName': element.buildName,
      'buildIcon': element.buildIcon,
      'buildVersion': element.buildVersion,
      'buildVersionNo': element.buildVersionNo,
      'buildBuildVersion': element.buildBuildVersion,
      'buildCreated': element.buildCreated,
      'buildType': element.buildType,
      'buildIdentifier': element.buildIdentifier,
      'buildFileSize': element.buildFileSize,
      'buildFileName': element.buildFileName?? ""
    };

    return row;
  }
}
