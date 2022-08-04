import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

import '../../Config.dart';
import '../../generated/l10n.dart';
import '../Model/AppModle.dart';
import '../Utils/AppHelper.dart';
import '../Utils/CustomColor.dart';

// App 详情 列表Item Center View
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/21
class AppBuildListItem extends StatelessWidget {
  final AppDetailItem appDetailItem;
  final Color installBgColor;
  final Color installTextColor;
  final String installIcon;

  final GestureTapCallback? onTapInstall;

  const AppBuildListItem(
      {Key? key,
      required this.appDetailItem,
      required this.installBgColor,
      required this.installTextColor,
      required this.installIcon,
      this.onTapInstall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: CustomColor.cFE()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                  width: 20,
                  height: 20,
                  AppHelper.getAppIcon(appDetailItem.buildIcon),
                  errorBuilder: (ctx, o, n) {
                return Image.asset("assets/images/ic_app_detail_logo.png");
              }),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "${AppHelper.getAppName(appDetailItem.buildName)} ${appDetailItem.buildVersion}",
                    style: TextStyle(
                        fontSize: 14,
                        color: CustomColor.c21(),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: installBgColor),
                child: InkResponse(
                    onTap: onTapInstall,
                    child: Row(
                      children: [
                        Text(
                          "Install",
                          style: TextStyle(
                              fontSize: 12,
                              color: installTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(installIcon, width: 10)
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${S.current.appSize} ${filesize(appDetailItem.buildFileSize)}",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: CustomColor.cool153()),
              ),
              Text(
                "${S.current.appLatestUpdate} ${appDetailItem.buildCreated}",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: CustomColor.cool153()),
              ),
            ],
          )
        ],
      ),
    );
  }
}
