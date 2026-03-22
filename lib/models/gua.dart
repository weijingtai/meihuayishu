/// 八卦模型
class Gua {
  /// 上卦编号 (0-7, 对应先天八卦数-1)
  final int upperGua;

  /// 下卦编号 (0-7)
  final int lowerGua;

  /// 动爻位置 (1-6)
  final int changingYao;

  /// 上卦名称
  final String upperGuaName;

  /// 下卦名称
  final String lowerGuaName;

  const Gua({
    required this.upperGua,
    required this.lowerGua,
    required this.changingYao,
    required this.upperGuaName,
    required this.lowerGuaName,
  });

  /// 从先天八卦数创建 (1-8)
  factory Gua.fromNumbers(int upperNum, int lowerNum, int changingYao) {
    // 处理余数为0的情况，取坤卦(8)
    int upper = upperNum % 8;
    int lower = lowerNum % 8;
    if (upper == 0) upper = 8;
    if (lower == 0) lower = 8;

    // 处理动爻为0的情况，取上爻(6)
    int yao = changingYao % 6;
    if (yao == 0) yao = 6;

    return Gua(
      upperGua: upper - 1,
      lowerGua: lower - 1,
      changingYao: yao,
      upperGuaName: _getGuaName(upper),
      lowerGuaName: _getGuaName(lower),
    );
  }

  /// 从二进制字符串创建 (如 "111" 表示乾)
  factory Gua.fromBinary(
      String upperBinary, String lowerBinary, int changingYao) {
    int upper = _binaryToNumber(upperBinary);
    int lower = _binaryToNumber(lowerBinary);

    return Gua(
      upperGua: upper,
      lowerGua: lower,
      changingYao: changingYao,
      upperGuaName: _getGuaName(upper + 1),
      lowerGuaName: _getGuaName(lower + 1),
    );
  }

  /// 从 Map 创建
  factory Gua.fromMap(Map<String, dynamic> map) {
    return Gua(
      upperGua: map['upperGua'],
      lowerGua: map['lowerGua'],
      changingYao: map['changingYao'],
      upperGuaName: map['upperGuaName'],
      lowerGuaName: map['lowerGuaName'],
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'upperGua': upperGua,
      'lowerGua': lowerGua,
      'changingYao': changingYao,
      'upperGuaName': upperGuaName,
      'lowerGuaName': lowerGuaName,
    };
  }

  /// 获取完整卦名
  String get fullName => '$upperGuaName$lowerGuaName';

  /// 获取上卦的先天数 (1-8)
  int get upperNumber => upperGua + 1;

  /// 获取下卦的先天数 (1-8)
  int get lowerNumber => lowerGua + 1;

  /// 获取上卦二进制字符串
  String get upperBinary => _numberToBinary(upperGua);

  /// 获取下卦二进制字符串
  String get lowerBinary => _numberToBinary(lowerGua);

  /// 获取完整的六爻二进制字符串 (从下往上)
  String toBinaryString() => lowerBinary + upperBinary;

  /// 获取六爻列表 (从下往上, true为阳爻, false为阴爻)
  List<bool> get yaoList {
    String binary = toBinaryString();
    return binary.split('').map((c) => c == '1').toList();
  }

  /// 检查指定位置是否为动爻
  bool isChangingYao(int position) => position == changingYao;

  /// 获取变爻的二进制值
  String get changedYaoBinary {
    List<String> binaryList = toBinaryString().split('');
    int index = changingYao - 1;
    binaryList[index] = binaryList[index] == '1' ? '0' : '1';
    return binaryList.join();
  }

  /// 获取卦名 (静态方法)
  static String _getGuaName(int number) {
    const names = ['', '乾', '兑', '离', '震', '巽', '坎', '艮', '坤'];
    if (number < 1 || number > 8) return '坤';
    return names[number];
  }

  /// 二进制转编号 (0-7)
  static int _binaryToNumber(String binary) {
    const mapping = {
      '111': 0, // 乾
      '110': 1, // 兑
      '101': 2, // 离
      '100': 3, // 震
      '011': 4, // 巽
      '010': 5, // 坎
      '001': 6, // 艮
      '000': 7, // 坤
    };
    return mapping[binary] ?? 7;
  }

  /// 编号转二进制
  static String _numberToBinary(int number) {
    const mapping = [
      '111', // 0: 乾
      '110', // 1: 兑
      '101', // 2: 离
      '100', // 3: 震
      '011', // 4: 巽
      '010', // 5: 坎
      '001', // 6: 艮
      '000', // 7: 坤
    ];
    if (number < 0 || number > 7) return '000';
    return mapping[number];
  }

  @override
  String toString() => 'Gua($fullName, 动爻:$changingYao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Gua &&
        other.upperGua == upperGua &&
        other.lowerGua == lowerGua &&
        other.changingYao == changingYao;
  }

  @override
  int get hashCode =>
      upperGua.hashCode ^ lowerGua.hashCode ^ changingYao.hashCode;
}
