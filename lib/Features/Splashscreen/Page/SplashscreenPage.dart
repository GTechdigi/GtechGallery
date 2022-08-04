import 'package:flutter/material.dart';
import 'package:gtech_app/generated/l10n.dart';
import '../../../Domainless/Utils/CustomColor.dart';
import '../../App/Page/AppHomePage.dart';

// 启动页面
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/12
class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashscreenPageState();
}

class SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();

    toHomePage();
  }

  void toHomePage() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (ctx, anim1, anim2) => const AppHomePage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.cF8FAFB(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Column(children: [
              Image.asset("assets/images/ic_launcher.png",
                  width: 75, height: 75),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(S.current.appName,
                      style: const TextStyle(fontSize: 18)))
            ]))
          ],
        ));
  }
}
