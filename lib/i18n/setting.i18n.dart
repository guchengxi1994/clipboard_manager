import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("zh_cn") +
      {"zh_cn": "水印文字", "en_us": "Watermark"} +
      {"zh_cn": "输入水印文字", "en_us": "Input watermark"} +
      {"zh_cn": "成功", "en_us": "OK"} +
      {"zh_cn": "(仅支持英文和数字)", "en_us": "(English and numbers only)"} +
      {"zh_cn": "中文", "en_us": "Chinese"} +
      {"zh_cn": "英文", "en_us": "English"} +
      {"zh_cn": "切换语言", "en_us": "Switch language"} +
      {"zh_cn": "收起", "en_us": "Hide"} +
      {"zh_cn": "选择语言", "en_us": "Select"};

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
