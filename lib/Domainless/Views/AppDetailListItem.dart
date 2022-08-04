import 'package:flutter/material.dart';

import '../../Config.dart';
import '../Model/AppModle.dart';
import '../Utils/CustomColor.dart';
import 'AppBuildListItem.dart';

// App 详情 列表Item
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/19
class AppDetailListItem extends StatelessWidget {
  final AppDetailItem appDetailItem;
  final GestureTapCallback? onTapItem;
  final GestureTapCallback? onTapInstall;

  const AppDetailListItem(
      {Key? key,
      required this.appDetailItem,
      this.onTapItem,
      this.onTapInstall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dev
    var startBgColor = CustomColor.cEFF5FF();
    var endBgColor = CustomColor.cF8FBFF();
    var installTextColor = CustomColor.c2F85F3();
    var installIcon = "assets/images/ic_arrow_blue.png";

    if (appDetailItem.buildEnv == Config.buildEnvTest) {
      startBgColor = CustomColor.cFFF5E1();
      endBgColor = CustomColor.cFFFBF2();
      installTextColor = CustomColor.cFEB500();
      installIcon = "assets/images/ic_arrow_yellow.png";
    } else if (appDetailItem.buildEnv == Config.buildEnvUat) {
      startBgColor = CustomColor.cFFF3F0();
      endBgColor = CustomColor.cFFFAF9();
      installTextColor = CustomColor.cFD6A40();
      installIcon = "assets/images/ic_arrow_red.png";
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 12),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              startBgColor,
              endBgColor,
            ]),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    appDetailItem.buildEnv ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: CustomColor.c21()),
                  )),
              InkResponse(
                  onTap: onTapItem,
                  child: Text(
                    "MORE",
                    style:
                        TextStyle(fontSize: 14, color: CustomColor.c8C8C8C()),
                  )),
            ],
          ),
          AppBuildListItem(
              appDetailItem: appDetailItem,
              installBgColor: startBgColor,
              installTextColor: installTextColor,
              installIcon: installIcon,
              onTapInstall: onTapInstall)
        ],
      ),
    );
  }
}
