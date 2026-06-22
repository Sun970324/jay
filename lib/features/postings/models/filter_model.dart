class LocationModel {
  const LocationModel({
    required this.provinceName,
    required this.cityName,
  });
  final String provinceName;
  final String cityName;
}

class FilterModel {
  const FilterModel({
    required this.disease,
    required this.location,
    required this.birth,
    required this.income,
    required this.familyCount,
    required this.incomeRate,
    required this.isPersonalInfoConsent,
  });
  final List<String> disease;
  final LocationModel location;
  final DateTime? birth;
  final int income;
  final int familyCount;
  final int incomeRate;
  /// 개인정보 동의 여부
  final bool isPersonalInfoConsent;
}

/**
 * Todo: incomeLevel
 * income, familyCount로 중위소득 계산하기.
 */
