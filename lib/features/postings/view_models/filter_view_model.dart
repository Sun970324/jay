import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/repos/filter_repo.dart';

class FilterViewModel extends Notifier<FilterModel> {
  final FilterRepository _repo;

  FilterViewModel(this._repo);

  @override
  FilterModel build() {
    return _initialFilterModel();
  }

  FilterModel _initialFilterModel() {
    return FilterModel(
      disease: _repo.hasDisease(),
      location: LocationModel(
          provinceName: _repo.hasProvinceName(), cityName: _repo.hasCityName()),
      birth:
          _repo.hasBirth().isNotEmpty ? DateTime.parse(_repo.hasBirth()) : null,
      income: _repo.hasIncome(),
      familyCount: _repo.hasFamilyCount(),
      incomeRate: _repo.hasMedianIncomeRate(),
isPersonalInfoConsent: _repo.hasIsPersonalInfoConsent(),
    );
  }

  void setFilterModel(FilterModel filterModel) {
    state = filterModel;
  }

  Future<void> loadSavedLocation() async {
    final provinceName = _repo.hasProvinceName();
    final cityName = _repo.hasCityName();

    if (provinceName.isEmpty || cityName.isEmpty) return;

    state = FilterModel(
      disease: state.disease,
      location: LocationModel(
        provinceName: provinceName,
        cityName: cityName,
      ),
      birth: state.birth,
      income: state.income,
      familyCount: state.familyCount,
      incomeRate: state.incomeRate,
      isPersonalInfoConsent: state.isPersonalInfoConsent,
    );
  }

  Future<void> loadSavedDisease() async {
    final savedDisease = _repo.hasDisease();
    if (savedDisease.isEmpty) return;

    state = FilterModel(
        disease: savedDisease,
        location: state.location,
        birth: state.birth,
        income: state.income,
        familyCount: state.familyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> saveLocation(LocationModel location) async {
    await _repo.setProvinceName(location.provinceName);
    await _repo.setCityName(location.cityName);

    state = FilterModel(
        disease: state.disease,
        location: location,
        birth: state.birth,
        income: state.income,
        familyCount: state.familyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> saveDisease(List<String> diseases) async {
    await _repo.setDisease(diseases);

    state = FilterModel(
        disease: diseases,
        location: state.location,
        birth: state.birth,
        income: state.income,
        familyCount: state.familyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> saveBirth(DateTime birth) async {
    await _repo.setBirth(birth.toIso8601String());

    state = FilterModel(
        disease: state.disease,
        location: state.location,
        birth: birth,
        income: state.income,
        familyCount: state.familyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> loadSavedBirth() async {
    final savedBirth = _repo.hasBirth();
    if (savedBirth.isEmpty) return;

    DateTime? birth;
    try {
      birth = DateTime.parse(savedBirth);
    } catch (_) {
      return;
    }

    state = FilterModel(
        disease: state.disease,
        location: state.location,
        birth: birth,
        income: state.income,
        familyCount: state.familyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> saveIncomeAndFamily({
    required int income,
    required int familyCount,
  }) async {
    await _repo.setIncome(income);
    await _repo.setFamilyCount(familyCount);
    await _repo.calculateAndSaveMedianIncomeRate();
    final newRate = _repo.hasMedianIncomeRate();
    state = FilterModel(
        disease: state.disease,
        location: state.location,
        birth: state.birth,
        income: income,
        familyCount: familyCount,
        incomeRate: newRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> loadSavedIncomeAndFamily() async {
    final savedIncome = _repo.hasIncome();
    final savedFamilyCount = _repo.hasFamilyCount();

    // 둘 다 0이면 저장된 값이 없다고 보고 기본값 유지
    if (savedIncome == 0 && savedFamilyCount == 0) return;

    state = FilterModel(
        disease: state.disease,
        location: state.location,
        birth: state.birth,
        income: savedIncome,
        familyCount: savedFamilyCount,
        incomeRate: state.incomeRate,
        isPersonalInfoConsent: state.isPersonalInfoConsent);
  }

  Future<void> savePersonalInfoConsent(bool consent) async {
    await _repo.setIsPersonalInfoConsent(consent);

    state = FilterModel(
      disease: state.disease,
      location: state.location,
      birth: state.birth,
      income: state.income,
      familyCount: state.familyCount,
      incomeRate: state.incomeRate,
      isPersonalInfoConsent: consent,
    );
  }

  Future<void> loadSavedPersonalInfoConsent() async {
    final consent = _repo.hasIsPersonalInfoConsent();

    state = FilterModel(
      disease: state.disease,
      location: state.location,
      birth: state.birth,
      income: state.income,
      familyCount: state.familyCount,
      incomeRate: state.incomeRate,
      isPersonalInfoConsent: consent,
    );
  }

  Future<void> clearAllFilters() async {
    await _repo.clearAllFilters();
    state = _initialFilterModel();
  }
}

final filterProvider = NotifierProvider<FilterViewModel, FilterModel>(
  () => throw UnimplementedError(),
);
