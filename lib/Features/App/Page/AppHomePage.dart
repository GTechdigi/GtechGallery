import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtech_app/Domainless/Views/AppPageTitle.dart';
import 'package:gtech_app/generated/l10n.dart';

import '../../../Domainless/Model/AppModle.dart';
import '../../../Domainless/Utils/API.dart';
import '../../../Domainless/Utils/CustomColor.dart';
import '../../../Domainless/Views/AppGridViewItem.dart';
import '../ViewModel/AppViewModel.dart';
import 'AppDetailPage.dart';

// 首页 - App
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/12
class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppHomePageState();
}

class AppHomePageState extends State<AppHomePage> {
  List<AppItem> _appList = [];

  final AppViewModel viewModel = AppViewModel();

  @override
  void initState() {
    super.initState();

    _initNetCallback();
    viewModel.getLocalDBAppList();
    viewModel.getNetAppList();
  }

  /// 网络访问回调
  void _initNetCallback() {
    viewModel.callback = setState;
    viewModel.responseCallback = (success, date, endpoint) {
      if (success) {
        switch (endpoint) {
          case GTechAPI.getAppList:
            // 更新App List
            updateAppList(date);
            break;

          case GTechAPI.getLocalDBAppList:
            // 更新App List
            updateAppList(date);
            break;
        }
      } else {
        Fluttertoast.showToast(msg: date.toString());
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.cF8FAFB(),
      body: Column(
        children: [
          AppPageTitle(title: S.current.appPageTitle),
          Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.25,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 13
                  ),
                  itemCount: _appList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AppGridViewItem(
                        appItem: _appList[index],
                        onTapItem: () => {_toAppDetailPage(index)});
                  }))
        ],
      ),
    );
  }

  /// 更新App List
  void updateAppList(dynamic netAppList) {
    setState(() {
      _appList = netAppList;
    });
  }

  void _toAppDetailPage(int index) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (ctx, anim1, anim2) => AppDetailPage(appItem: _appList[index])));
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.callback = null;
    viewModel.responseCallback = null;
  }
}
