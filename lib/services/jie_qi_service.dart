import 'package:common/helpers/solar_lunar_datetime_helper.dart';
import 'package:common/utils/celestial_rise_set_calculator.dart';
import 'package:common/models/jie_qi_info.dart';
import 'package:common/models/seventy_two_phenology.dart';
import 'package:logger/logger.dart';

/// 物候计算结果
class JieQiResult {
  final JieQiInfo jieQiInfo;              // 节气信息
  final Phenology? phenology;             // 物候信息
  final DailyRiseSetInfo? riseSetInfo;    // 日月升落信息

  JieQiResult({
    required this.jieQiInfo,
    this.phenology,
    this.riseSetInfo,
  });
}

/// 物候计算服务
class JieQiService {
  final Logger _logger = Logger();

  /// 默认位置（上海）
  static const double defaultLongitude = 121.47;
  static const double defaultLatitude = 31.23;

  /// 计算物候信息
  /// 
  /// [dateTime] 起卦时间
  /// [longitude] 经度（可选，默认上海）
  /// [latitude] 纬度（可选，默认上海）
  /// 返回物候计算结果
  Future<JieQiResult?> calculateJieQi(
    DateTime dateTime, {
    double longitude = defaultLongitude,
    double latitude = defaultLatitude,
  }) async {
    try {
      // 使用 SolarLunarDateTimeHelper 获取节气和物候信息
      final result = SolarLunarDateTimeHelper.getEighthChars(dateTime);
      
      final jieQiInfo = result.item4;   // 节气信息
      final phenology = result.item3;   // 物候信息

      _logger.i('节气计算成功: ${jieQiInfo.jieQi.name}');

      // 计算日月升落信息
      DailyRiseSetInfo? riseSetInfo;
      try {
        riseSetInfo = CelestialRiseSetCalculator.calculateDaily(
          utcDateTime: dateTime.toUtc(),
          longitude: longitude,
          latitude: latitude,
          altitude: 0,
          includeTwilight: false,
        );
        _logger.i('日月升落计算成功');
      } catch (e) {
        _logger.w('日月升落计算失败: $e');
      }

      return JieQiResult(
        jieQiInfo: jieQiInfo,
        phenology: phenology,
        riseSetInfo: riseSetInfo,
      );
    } catch (e) {
      _logger.e('物候计算失败: $e');
      return null;
    }
  }

  /// 获取节气名称
  /// 
  /// [jieQiInfo] 节气信息
  /// 返回节气名称
  String getJieQiName(JieQiInfo jieQiInfo) {
    return jieQiInfo.jieQi.name;
  }

  /// 获取物候名称
  /// 
  /// [phenology] 物候信息
  /// 返回物候名称
  String getPhenologyName(Phenology phenology) {
    return phenology.name;
  }

  /// 获取物候描述
  /// 
  /// [phenology] 物候信息
  /// 返回物候描述
  String getPhenologyDescription(Phenology phenology) {
    return phenology.description;
  }

  /// 格式化日出时间
  /// 
  /// [riseSetInfo] 日月升落信息
  /// 返回日出时间字符串
  String? formatSunRise(DailyRiseSetInfo? riseSetInfo) {
    if (riseSetInfo?.sun.rise == null) return null;
    final time = riseSetInfo!.sun.rise!.toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化日落时间
  /// 
  /// [riseSetInfo] 日月升落信息
  /// 返回日落时间字符串
  String? formatSunSet(DailyRiseSetInfo? riseSetInfo) {
    if (riseSetInfo?.sun.set_ == null) return null;
    final time = riseSetInfo!.sun.set_!.toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化月出时间
  /// 
  /// [riseSetInfo] 日月升落信息
  /// 返回月出时间字符串
  String? formatMoonRise(DailyRiseSetInfo? riseSetInfo) {
    if (riseSetInfo?.moon.rise == null) return null;
    final time = riseSetInfo!.moon.rise!.toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化月落时间
  /// 
  /// [riseSetInfo] 日月升落信息
  /// 返回月落时间字符串
  String? formatMoonSet(DailyRiseSetInfo? riseSetInfo) {
    if (riseSetInfo?.moon.set_ == null) return null;
    final time = riseSetInfo!.moon.set_!.toLocal();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
