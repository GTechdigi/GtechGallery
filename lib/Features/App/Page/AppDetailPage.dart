import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtech_app/Domainless/Views/AppDetailListItem.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Config.dart';
import '../../../Domainless/Model/AppModle.dart';
import '../../../Domainless/Utils/API.dart';
import '../../../Domainless/Utils/AppHelper.dart';
import '../../../Domainless/Utils/CustomColor.dart';
import '../../../Domainless/Views/AppPageTitle.dart';
import '../ViewModel/AppViewModel.dart';
import 'AppBuildListPage.dart';

// App 详情
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/15
class AppDetailPage extends StatefulWidget {
  final AppItem appItem;

  const AppDetailPage({Key? key, required this.appItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppDetailPageState();
}

class AppDetailPageState extends State<AppDetailPage> {
  List<AppDetailItem> _appDetailItems = [];

  final AppViewModel viewModel = AppViewModel();

  @override
  void initState() {
    super.initState();
    _initNetCallback();

    viewModel.getNetAppBuilds(widget.appItem);
    viewModel.getAppDetailBuild(widget.appItem);
  }

  /// 网络访问回调
  void _initNetCallback() {
    viewModel.callback = setState;
    viewModel.responseCallback = (success, date, endpoint) {
      if (success) {
        switch (endpoint) {
          case GTechAPI.getAppBuilds:
            viewModel.getAppDetailBuild(widget.appItem);
            break;

          case GTechAPI.getLocalDBAppDetailBuilds:
            setState(() {
              _appDetailItems = date;
            });
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
          AppPageTitle(
              title: AppHelper.getAppName(widget.appItem.buildName),
              showBackIcon: true,
              backCallback: () => {Navigator.pop(context)}),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                itemCount: _appDetailItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return AppDetailListItem(
                    appDetailItem: _appDetailItems[index],
                    onTapItem: () => {
                      _toAppBuildListPage(index)
                    },
                    onTapInstall: () => {
                      _appInstall(index)
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  _toAppBuildListPage(int index) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (ctx, anim1, anim2) => AppBuildListPage(appDetailItem: _appDetailItems[index])));
  }

  _appInstall(int index) async {
    launchUrl(Uri.parse(Config.baseAppLauncherUrl + _appDetailItems[index].buildKey),
        mode: LaunchMode.externalApplication);
  }
}
