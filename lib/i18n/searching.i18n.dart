import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("zh_cn") +
      {"zh_cn": "日期选择", "en_us": "Select Date"} +
      {"zh_cn": "类型选择", "en_us": "Select Type"} +
      {"zh_cn": "重置", "en_us": "Reset"} +
      {"zh_cn": "收起", "en_us": "Hide"};

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
