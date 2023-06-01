import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("zh_cn") +
      {"zh_cn": "未知类型", "en_us": "Unknow type"} +
      {"zh_cn": "输入备注", "en_us": "Remark"} +
      {"zh_cn": "已复制", "en_us": "Copied"};

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
