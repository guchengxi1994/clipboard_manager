import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("zh_cn") +
      {"zh_cn": "设置", "en_us": "Settings"} +
      {"zh_cn": "搜索", "en_us": "Search"};

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
