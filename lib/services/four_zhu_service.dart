import 'package:common/helpers/solar_lunar_datetime_helper.dart';
import 'package:common/models/eight_chars.dart';
import 'package:logger/logger.dart';

/// 四柱计算结果
class FourZhuResult {
  final EightChars eightChars;      // 四柱八字

  FourZhuResult({
    required this.eightChars,
  });
}

/// 四柱计算服务
class FourZhuService {
  final Logger _logger = Logger();

  /// 从 DateTime 计算四柱
  /// 
  /// [dateTime] 起卦时间
  /// 返回四柱计算结果
  Future<FourZhuResult?> calculateFourZhu(DateTime dateTime) async {
    try {
      // 使用 SolarLunarDateTimeHelper 计算四柱
      final result = SolarLunarDateTimeHelper.getEighthChars(dateTime);
      
      final eightChars = result.item1;  // 四柱八字

      _logger.i('四柱计算成功: ${eightChars.year.name} ${eightChars.month.name} ${eightChars.day.name} ${eightChars.time.name}');

      return FourZhuResult(
        eightChars: eightChars,
      );
    } catch (e) {
      _logger.e('四柱计算失败: $e');
      return null;
    }
  }

  /// 获取四柱的字符串表示
  /// 
  /// [eightChars] 四柱八字
  /// 返回四柱字符串，如 "甲子 乙丑 丙寅 丁卯"
  String getFourZhuString(EightChars eightChars) {
    return '${eightChars.year.name} ${eightChars.month.name} ${eightChars.day.name} ${eightChars.time.name}';
  }

  /// 获取天干字符串
  /// 
  /// [eightChars] 四柱八字
  /// 返回天干字符串，如 "甲乙丙丁"
  String getTianGanString(EightChars eightChars) {
    return '${eightChars.yearTianGan.name}${eightChars.monthTianGan.name}${eightChars.dayTianGan.name}${eightChars.hourTianGan.name}';
  }

  /// 获取地支字符串
  /// 
  /// [eightChars] 四柱八字
  /// 返回地支字符串，如 "子丑寅卯"
  String getDiZhiString(EightChars eightChars) {
    return '${eightChars.yearDiZhi.name}${eightChars.monthDiZhi.name}${eightChars.dayDiZhi.name}${eightChars.hourDiZhi.name}';
  }
}
