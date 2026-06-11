import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FilterRepository {
  static const String _disease = "disease";
  static const String _provinceName = "provinceName";
  static const String _cityName = "cityName";
  static const String _birth = "birth";
  static const String _isDisability = "isDisability";
  static const String _isRareDisease = "isRareDisease";
  static const String _isLifePrevention = "isLifePrevention";
  static const String _isPersonalInfoConsent = "isPersonalInfoConsent";
  static const String _income = "income";
  static const String _familyCount = "familyCount";
  static const String _medianIncome = "medianIncome";
  static const String _medianIncomeRate = "medianIncomeRate";

  final SupabaseClient _client = Supabase.instance.client;

  final SharedPreferences _preferences;
  FilterRepository(this._preferences);

  Future<void> getMedianIncome() async {
    var resp = await _client.from('median_income').select('amount');
    final List<String> amounts =
        (resp as List).map((e) => e['amount'].toString()).toList();
    _preferences.setStringList(_medianIncome, amounts);
  }

  Future<void> setDisease(List<String> value) async {
    _preferences.setStringList(_disease, value);
  }

  Future<void> setProvinceName(String value) async {
    _preferences.setString(_provinceName, value);
  }

  Future<void> setCityName(String value) async {
    _preferences.setString(_cityName, value);
  }

  Future<void> setBirth(String value) async {
    _preferences.setString(_birth, value);
  }

  Future<void> setIncome(int value) async {
    _preferences.setInt(_income, value);
  }

  Future<void> setFamilyCount(int value) async {
    _preferences.setInt(_familyCount, value);
  }

  Future<void> setIsDisability(bool value) async {
    _preferences.setBool(_isDisability, value);
  }

  Future<void> setIsRareDisease(bool value) async {
    _preferences.setBool(_isRareDisease, value);
  }

  Future<void> setIsLifePrevention(bool value) async {
    _preferences.setBool(_isLifePrevention, value);
  }

  Future<void> setIsPersonalInfoConsent(bool value) async {
    _preferences.setBool(_isPersonalInfoConsent, value);
  }

  List<String> hasDisease() {
    return _preferences.getStringList(_disease) ?? [];
  }

  String hasProvinceName() {
    return _preferences.getString(_provinceName) ?? "";
  }

  String hasCityName() {
    return _preferences.getString(_cityName) ?? "";
  }

  String hasBirth() {
    return _preferences.getString(_birth) ?? "";
  }

  List<String> hasMedianIncome() {
    return _preferences.getStringList(_medianIncome) ?? [];
  }

  int hasIncome() {
    return _preferences.getInt(_income) ?? 0;
  }

  int hasFamilyCount() {
    return _preferences.getInt(_familyCount) ?? 0;
  }

  bool hasIsDisability() {
    return _preferences.getBool(_isDisability) ?? false;
  }

  bool hasIsRareDisease() {
    return _preferences.getBool(_isRareDisease) ?? false;
  }

  bool hasIsLifePrevention() {
    return _preferences.getBool(_isLifePrevention) ?? false;
  }

  bool hasIsPersonalInfoConsent() {
    return _preferences.getBool(_isPersonalInfoConsent) ?? false;
  }

  /// 중위소득 비율(%)을 계산해서 preference에 저장
  /// income / medianIncomeForFamilyCount * 100
  Future<void> calculateAndSaveMedianIncomeRate() async {
    final income = hasIncome();
    final familyCount = hasFamilyCount();
    final medianIncomeList = hasMedianIncome();
    if (medianIncomeList.isEmpty) {
      await getMedianIncome();
    }
    // 필수 값이 없으면 계산하지 않음
    if (income <= 0 || familyCount <= 0 || medianIncomeList.isEmpty) {
      return;
    }

    // familyCount는 1~7까지만 대응 (1→index0, 2→index1, ..., 7→index6)
    final clampedFamilyCount = familyCount.clamp(1, 7);
    final index = clampedFamilyCount - 1;

    if (index >= medianIncomeList.length) {
      // medianIncome 데이터가 부족한 경우도 방어
      return;
    }

    final medianStr = medianIncomeList[index];
    final median = int.tryParse(medianStr) ?? 0;
    if (median <= 0) return;

    final rate = (income * 10000 / median * 100).round();
    await _preferences.setInt(_medianIncomeRate, rate);
  }

  int hasMedianIncomeRate() {
    return _preferences.getInt(_medianIncomeRate) ?? 0;
  }

  Future<void> clearAllFilters() async {
    await _preferences.remove(_disease);
    await _preferences.remove(_provinceName);
    await _preferences.remove(_cityName);
    await _preferences.remove(_birth);
    await _preferences.remove(_isDisability);
    await _preferences.remove(_isRareDisease);
    await _preferences.remove(_isLifePrevention);
    await _preferences.remove(_isPersonalInfoConsent);
    await _preferences.remove(_income);
    await _preferences.remove(_familyCount);
    await _preferences.remove(_medianIncome);
    await _preferences.remove(_medianIncomeRate);
  }
}
