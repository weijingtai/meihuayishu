import 'package:flutter_test/flutter_test.dart';
import 'package:meihuayishu/services/meihua_service.dart';
import 'package:meihuayishu/models/gua.dart';
import 'package:meihuayishu/models/divination_result.dart';
import 'package:meihuayishu/utils/gua_calculator.dart';

void main() {
  group('MeiHuaService Tests', () {
    late MeiHuaService service;

    setUp(() {
      service = MeiHuaService();
    });

    test('xianTianDivination returns valid result', () {
      final result = service.xianTianDivination([1, 2, 3]);

      expect(result.originalGua, isNotNull);
      expect(result.changedGua, isNotNull);
      expect(result.huGua, isNotNull);
      expect(result.originalGua.upperGua, inInclusiveRange(0, 7));
      expect(result.originalGua.lowerGua, inInclusiveRange(0, 7));
      expect(result.originalGua.changingYao, inInclusiveRange(1, 6));
    });

    test('timeDivination returns valid result', () {
      final result = service.timeDivination(
        yearZhiNum: 5, // 辰
        lunarMonth: 1,
        lunarDay: 1,
        hourZhiNum: 1, // 子
      );

      expect(result.originalGua, isNotNull);
      expect(result.changedGua, isNotNull);
      expect(result.huGua, isNotNull);
    });

    test('manualDivination returns valid result', () {
      final result = service.manualDivination(
        upperGuaNum: 1, // 乾
        lowerGuaNum: 6, // 坎
        changingYao: 2,
      );

      expect(result.originalGua.fullName, equals('乾坎'));
      expect(result.originalGua.changingYao, equals(2));
    });

    test('randomDivination returns valid result', () {
      final result = service.randomDivination();

      expect(result.originalGua, isNotNull);
      expect(result.originalGua.upperGua, inInclusiveRange(0, 7));
      expect(result.originalGua.lowerGua, inInclusiveRange(0, 7));
    });

    test('getGuaBinary returns valid binary string', () {
      final binary = service.getGuaBinary(0);
      expect(binary, equals('111'));

      final binary7 = service.getGuaBinary(7);
      expect(binary7, equals('000'));
    });
  });

  group('Gua Model Tests', () {
    test('Gua.fromNumbers works correctly', () {
      final gua = Gua.fromNumbers(1, 2, 3);

      expect(gua.upperGua, equals(0)); // 1-1
      expect(gua.lowerGua, equals(1)); // 2-1
      expect(gua.changingYao, equals(3));
      expect(gua.upperGuaName, equals('乾'));
      expect(gua.lowerGuaName, equals('兑'));
    });

    test('Gua fullName works correctly', () {
      final gua = Gua(
        upperGua: 0,
        lowerGua: 1,
        changingYao: 2,
        upperGuaName: '乾',
        lowerGuaName: '兑',
      );

      expect(gua.fullName, equals('乾兑'));
    });

    test('Gua toBinaryString works correctly', () {
      final gua = Gua(
        upperGua: 0, // 乾 = 111
        lowerGua: 7, // 坤 = 000
        changingYao: 1,
        upperGuaName: '乾',
        lowerGuaName: '坤',
      );

      expect(gua.toBinaryString(), equals('000111'));
    });
  });

  group('GuaCalculator Tests', () {
    test('numberToGuaName works correctly', () {
      expect(GuaCalculator.numberToGuaName(1), equals('乾'));
      expect(GuaCalculator.numberToGuaName(8), equals('坤'));
      expect(GuaCalculator.numberToGuaName(0), equals('坤')); // 余数为0取坤
    });

    test('guaNameToNumber works correctly', () {
      expect(GuaCalculator.guaNameToNumber('乾'), equals(1));
      expect(GuaCalculator.guaNameToNumber('坤'), equals(8));
    });

    test('calculateHuGua works correctly', () {
      final original = Gua.fromNumbers(1, 2, 3);
      final huGua = GuaCalculator.calculateHuGua(original);

      expect(huGua, isNotNull);
      expect(huGua.upperGua, inInclusiveRange(0, 7));
      expect(huGua.lowerGua, inInclusiveRange(0, 7));
    });

    test('getWuXing works correctly', () {
      expect(GuaCalculator.getWuXing('乾'), equals('金'));
      expect(GuaCalculator.getWuXing('离'), equals('火'));
      expect(GuaCalculator.getWuXing('震'), equals('木'));
    });

    test('getDirection works correctly', () {
      expect(GuaCalculator.getDirection('离'), equals('南'));
      expect(GuaCalculator.getDirection('坎'), equals('北'));
    });
  });
}
