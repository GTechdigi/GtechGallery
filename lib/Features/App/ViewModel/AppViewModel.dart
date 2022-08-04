//
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../Domainless/Utils/API.dart';
import '../../../Config.dart';
import '../../../Domainless/Model/AppModle.dart';
import '../../../Domainless/Utils/AppDBManager.dart';

class AppViewModel {
  bool isLoading = false;
  Function(VoidCallback)? callback;
  Function(bool, dynamic, GTechAPI)? responseCallback;

  // 获取最新的App List
  void getNetAppList() {
    isLoading = true;
    if (callback != null) callback!(() {});
    _getNetAppList();
  }

  Future _getNetAppList() async {
    API api = API(api: GTechAPI.getAppList, parameters: {});
    final response = await api.request();

    if (response is Map<String, dynamic>) {
      isLoading = false;
      if (callback != null) callback!(() {});

      List<AppItem> appList = AppDBManager.getMapAppList(response['list']);

      if (responseCallback != null)
        responseCallback!(true, _getAppFilterList(appList), api.api);

      // 更新数据库
      AppDBManager.insertOrUpdateDBAppList(appList);
    } else {
      isLoading = false;
      if (callback != null) callback!(() {});
      if (responseCallback != null && response is AssertionError) {
        responseCallback!(false, (response).message, api.api);
      }
    }
  }

  // 获取本地App List
  void getLocalDBAppList() {
    isLoading = false;
    if (callback != null) callback!(() {});

    _getLocalDBAppList();
  }

  // 获取本地App List
  Future _getLocalDBAppList() async {
    List<AppItem> appList = await AppDBManager.getDBAppList();
    if (responseCallback != null) {
      responseCallback!(
          true, _getAppFilterList(appList), GTechAPI.getLocalDBAppList);
    }
  }

  List<AppItem> _getAppFilterList(List<AppItem> appList) {
    List<AppItem> appFilterList = [];
    var buildType = Platform.isAndroid ? "2" : "1";

    for (var appItem in appList) {
      for (var appFilterItem in Config.appFilter) {
        if (appItem.buildIdentifier == appFilterItem &&
            appItem.buildType == buildType) {
          appFilterList.add(appItem);
        }
      }
    }
    return appFilterList;
  }

  // 获取App Build List
  void getNetAppBuilds(AppItem appItem) {
    isLoading = true;
    if (callback != null) callback!(() {});
    _getNetAppBuilds(appItem);
  }

  void _getNetAppBuilds(AppItem appItem) async {
    // 本地存储为空或者
    // 判断App最新Builds版本与本地存储版本不一致
    List<AppItem> appBuildList = await AppDBManager.getDBAppBuildList(appItem);
    if (appBuildList.isEmpty ||
        (appBuildList.isNotEmpty &&
            appBuildList[0].buildBuildVersion != appItem.buildBuildVersion)) {
      API api = API(
          api: GTechAPI.getAppBuilds, parameters: {"appKey": appItem.appKey});
      final response = await api.request();
      if (response is Map<String, dynamic>) {
        isLoading = false;
        if (callback != null) callback!(() {});

        List<AppItem> appList = AppDBManager.getMapAppList(response['list']);

        // 更新数据库
        await AppDBManager.insertOrUpdateDBAppBuildList(appList);

        if (responseCallback != null) responseCallback!(true, "", api.api);
      } else {
        isLoading = false;
        if (callback != null) callback!(() {});
        if (responseCallback != null && response is AssertionError) {
          responseCallback!(false, (response).message, api.api);
        }
      }
    }
  }

  // 获取本地App 最新 dev、test、UAT Build
  void getAppDetailBuild(AppItem appItem) {
    isLoading = false;
    if (callback != null) callback!(() {});

    _getAppDetailBuild(appItem);
  }

  // 获取App build版本短连接
  void _getAppDetailBuild(AppItem appItem) async {
    List<AppDetailItem> appDetailList = [];

    // DEV
    AppDetailItem? appDetailDevItem = await AppDBManager.getAppDetailBuildByEnv(
        appItem.buildIdentifier, Config.buildEnvDev);
    if (appDetailDevItem != null) {
      appDetailList.add(appDetailDevItem);
    }

    // TEST
    AppDetailItem? appDetailTestItem =
        await AppDBManager.getAppDetailBuildByEnv(
            appItem.buildIdentifier, Config.buildEnvTest);
    if (appDetailTestItem != null) {
      appDetailList.add(appDetailTestItem);
    }

    // UAT
    AppDetailItem? appDetailUatItem = await AppDBManager.getAppDetailBuildByEnv(
        appItem.buildIdentifier, Config.buildEnvUat);
    if (appDetailUatItem != null) {
      appDetailList.add(appDetailUatItem);
    }

    if (responseCallback != null) {
      responseCallback!(
          true, appDetailList, GTechAPI.getLocalDBAppDetailBuilds);
    }
  }

  // getBuildShortcutUrl(String appKey, String buildKey) {
  //   isLoading = true;
  //   if (callback != null) callback!(() {});
  //   _getBuildShortcutUrl(appKey, buildKey);
  // }
  //
  // Future _getBuildShortcutUrl(String appKey, String buildKey) async {
  //   API api = API(api: GTechAPI.getAppDetail,
  //       parameters: {"appKey": appKey, "buildKey": buildKey});
  //   final response = await api.request();
  //
  //   if (response is Map<String, dynamic>) {
  //     isLoading = false;
  //     if (callback != null) callback!(() {});
  //
  //     // TODO
  //
  //   } else {
  //     isLoading = false;
  //     if (callback != null) callback!(() {});
  //     if (responseCallback != null && response is AssertionError) {
  //       responseCallback!(false, (response).message, api.api);
  //     }
  //   }
  // }

  // 获取本地App Build List
  void getLocalDBAppBuildList(AppDetailItem appDetailItem) {
    isLoading = false;
    if (callback != null) callback!(() {});

    _getLocalDBAppBuildList(appDetailItem);
  }

  // 获取本地App List
  // TODO 优化，分页加载
  Future _getLocalDBAppBuildList(AppDetailItem appDetailItem) async {
    List<AppItem> appBuildList =
        await AppDBManager.getDBAppBuildListWhere(appDetailItem, {
      "buildIdentifier": appDetailItem.buildIdentifier,
      "buildEnv": appDetailItem.buildEnv
    });

    List<AppDetailItem> appDetailItems = [];
    for (var element in appBuildList) {
      if (element is AppDetailItem) {
        appDetailItems.add(element);
      } else {
        AppDetailItem(
            element.appKey,
            element.buildKey,
            element.buildName,
            element.buildIcon,
            element.buildVersion,
            element.buildVersionNo,
            element.buildBuildVersion,
            element.buildCreated,
            element.buildType,
            element.buildIdentifier,
            element.buildFileSize,
            element.buildFileName,
            appDetailItem.buildEnv);
      }
    }

    if (responseCallback != null) {
      responseCallback!(true, appDetailItems, GTechAPI.getLocalDBAppBuildsList);
    }
  }
}
