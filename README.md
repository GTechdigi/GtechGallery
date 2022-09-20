### Gtech Gallery
佳应公司App List

技术细节请参考：[Flutter项目架构实践：基于蒲公英API的团队App下载安装器](https://juejin.cn/post/7127915317946712072)

### 背景
公司旗下有很多产品线，各种的APP，在给客户演示的时候不是很方便。还有一个问题就是团队Flutter转型，以后新的项目，技术储备成熟之后考虑使用Flutter开发

### 使用前配置修改
参考[./lib/Config.dart](https://github.com/GTechdigi/GtechGallery/blob/main/lib/Config.dart)修改相应配置

### 遗留问题
1. 出包历史记录未分页
2. JSON 2 Modle 考虑使用json_serializable实现
