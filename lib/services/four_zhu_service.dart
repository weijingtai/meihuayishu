import 'package:common/helpers/solar_lunar_datetime_helper.dart';
import 'package:common/features/four_zhu/four_zhu_engine.dart';
import 'package:common/models/eight_chars.dart';
import 'package:common/models/chinese_date_info.dart';
import 'package:common/features/tai_yuan/tai_yuan_model.dart';
import 'package:logger/logger.dart';

/// 四柱计算结果
class FourZhuResult {
  final EightChars eightChars;      // 四柱八字
  final TaiYuanModel? taiYuan;      // 胎元
  final ChineseDateInfo? dateInfo;  // 日期信息

  FourZhuResult({
    required this.eightChars,
    this.taiYuan,
    this.dateInfo,
  });
}

/// 四柱计算服务
class FourZhuService {
  final Logger _logger = Logger();
  late final FourZhuEngine _engine;

  FourZhuService() {
    _engine = FourZhuEngine.create();
  }

  /// 从 DateTime 计算四柱
  /// 
  /// [dateTime] 起卦时间
  /// 返回四柱计算结果
  Future<FourZhuResult?> calculateFourZhu(DateTime dateTime) async {
    try {
      // 使用 SolarLunarDateTimeHelper 计算四柱
      final result = SolarLunarDateTimeHelper.getEighthChars(dateTime);
      
      final eightChars = result.item1;  // 四柱八字
      final lunarDay = result.item2;    // 农历日
      final phenology = result.item3;   // 物候
      final jieQiInfo = result.item4;   // 节气信息

      _logger.i('四柱计算成功: ${eightChars.year.name} ${eightChars.month.name} ${eightChars.day.name} ${eightChars.time.name}');

      return FourZhuResult(
        eightChars: eightChars,
      );
    } catch (e) {
      _logger.e('四柱计算失败: $e');
      return null;
    }
  }

  /// 使用 FourZhuEngine 计算四柱
  /// 
  /// [dateTime] 起卦时间
  /// 返回四柱八字
  EightChars? calculateWithEngine(DateTime dateTime) {
    try {
      final result = _engine.calculate(dateTime);
      return result.eightChars;
    } catch (e) {
      _logger.e('四柱引擎计算失败: $e');
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
