import 'package:flutter/material.dart';
import '../../Config.dart';

import '../../generated/l10n.dart';
import '../Model/AppModle.dart';
import '../Utils/AppHelper.dart';
import '../Utils/CustomColor.dart';

// App GridView Item
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
class AppGridViewItem extends StatelessWidget {
  final AppItem appItem;
  final GestureTapCallback? onTapItem;

  const AppGridViewItem({Key? key, required this.appItem, this.onTapItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTapItem,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 2),
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                  ),
                ]),
                child: Image.network(width: 30, height: 30, AppHelper.getAppIcon(appItem.buildIcon),
                    errorBuilder: (ctx, o, n) {
                  return Image.asset("assets/images/ic_app_detail_logo.png");
                })),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(AppHelper.getAppName(appItem.buildName),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: CustomColor.c33(),
                        fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("${S.current.appLatest} ${appItem.buildCreated.replaceAll("-", ".")}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: CustomColor.cool153(),
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
    );
  }
}
