import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Config.dart';
import '../../../Domainless/Model/AppModle.dart';
import '../../../Domainless/Utils/API.dart';
import '../../../Domainless/Utils/AppHelper.dart';
import '../../../Domainless/Utils/CustomColor.dart';
import '../../../Domainless/Views/AppBuildListItem.dart';
import '../../../Domainless/Views/AppPageTitle.dart';
import '../ViewModel/AppViewModel.dart';

// App Build List
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/21
// TODO 优化，分页加载
class AppBuildListPage extends StatefulWidget {
  final AppDetailItem appDetailItem;

  const AppBuildListPage({Key? key, required this.appDetailItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AppBuildListPageState();
}

class AppBuildListPageState extends State<AppBuildListPage> {
  Color _startBgColor = CustomColor.cEFF5FF();
  Color _installTextColor = CustomColor.c2F85F3();
  String _installIcon = "assets/images/ic_arrow_blue.png";

  List<AppDetailItem> _appDetailItems = [];
  final AppViewModel viewModel = AppViewModel();

  @override
  void initState() {
    super.initState();

    // 设置主题颜色
    _setColorTheme();

    _initCallback();

    viewModel.getLocalDBAppBuildList(widget.appDetailItem);
  }

  // 设置主题颜色
  _setColorTheme() {
    if (widget.appDetailItem.buildEnv == Config.buildEnvTest) {
      _startBgColor = CustomColor.cFFF5E1();
      _installTextColor = CustomColor.cFEB500();
      _installIcon = "assets/images/ic_arrow_yellow.png";
    } else if (widget.appDetailItem.buildEnv == Config.buildEnvUat) {
      _startBgColor = CustomColor.cFFF3F0();
      _installTextColor = CustomColor.cFD6A40();
      _installIcon = "assets/images/ic_arrow_red.png";
    }
  }

  void _initCallback() {
    viewModel.callback = setState;
    viewModel.responseCallback = (success, date, endpoint) {
      if (success) {
        switch (endpoint) {
          case GTechAPI.getLocalDBAppBuildsList:
            setState(() {
              _appDetailItems = date;
            });
            break;
        }
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
              title: "${AppHelper.getAppName(widget.appDetailItem.buildName)} ${widget.appDetailItem.buildEnv}",
              showBackIcon: true,
              backCallback: () => {Navigator.pop(context)}),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                itemCount: _appDetailItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return AppBuildListItem(
                      appDetailItem: _appDetailItems[index],
                      installBgColor: _startBgColor,
                      installTextColor: _installTextColor,
                      installIcon: _installIcon,
                      onTapInstall: () => {_appInstall(index)});
                }),
          )
        ],
      ),
    );
  }

  _appInstall(int index) async {
    launchUrl(
        Uri.parse(Config.baseAppLauncherUrl + _appDetailItems[index].buildKey),
        mode: LaunchMode.externalApplication);
  }
}
