// 应用对象
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
class AppItem {
  String? appKey;
  String buildKey;
  String buildName;
  String buildIcon;
  String buildVersion;
  String buildVersionNo;
  String buildBuildVersion;
  String buildCreated;
  String buildType;
  String buildIdentifier;
  String buildFileSize;
  String? buildFileName;

  AppItem(
      this.appKey,
      this.buildKey,
      this.buildName,
      this.buildIcon,
      this.buildVersion,
      this.buildVersionNo,
      this.buildBuildVersion,
      this.buildCreated,
      this.buildType,
      this.buildIdentifier,
      this.buildFileSize,
      this.buildFileName);
}

class AppDetailItem extends AppItem {
  String? buildEnv;
  AppDetailItem(
      super.appKey,
      super.buildKey,
      super.buildName,
      super.buildIcon,
      super.buildVersion,
      super.buildVersionNo,
      super.buildBuildVersion,
      super.buildCreated,
      super.buildType,
      super.buildIdentifier,
      super.buildFileSize,
      super.buildFileName,
      this.buildEnv);
}


