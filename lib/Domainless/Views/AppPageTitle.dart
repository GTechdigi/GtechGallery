import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 页面标题
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
class AppPageTitle extends StatelessWidget {
  final bool showBackIcon;
  final String title;
  final GestureTapCallback? backCallback;

  const AppPageTitle(
      {Key? key, this.title = "", this.showBackIcon = false, this.backCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 88, 20, 10),
        child: Row(
          children: [
            if (showBackIcon)
              InkResponse(
                onTap: backCallback,
                child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Image.asset("assets/images/ic_title_back.png", width: 24, height: 24)),
              ),
            Text(title,
                style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 24,
                    fontWeight: FontWeight.w600))
          ],
        ));
  }
}
