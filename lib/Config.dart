// 配置
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
class Config {
  // Base URL
  static String baseUrl = "https://www.pgyer.com/apiv2";
  static String baseUrlAppIcons = "https://www.pgyer.com/image/view/app_icons/";
  static String baseAppLauncherUrl = "https://www.pgyer.com/";

  // 输入自己的蒲公英 API Key，
  // 请通过这里查看：https://www.pgyer.com/account/api
  static String pgyerApiKey = "ad85e5****************e1c4";

  // App过滤器
  // 过滤需要显示的APP
  static List<String> appFilter = [
    // "com.gtech.wtbig",
    // "com.gtech.win_tbr.cn",
    // "com.gtech.BlueTab",
    // "com.gtech.bluetab",
    // "com.gtech.speedbiz",
    // "com.gpay.merchantapp.demo",
    // "id.gpay.app.dev",
    // "com.gtech.speedbiz.my",
    // "com.gtech.jiaying",
    // "com.gtech.k1",
    // "com.gtech.speedbizMy"
  ];

  // 区分不同环境的安装包
  // 区分依据：上传到蒲公英的安装包名称是否包含：dev、test、uat
  static String buildEnvDev = "DEV";
  static String buildEnvTest = "TEST";
  static String buildEnvUat = "UAT";

}