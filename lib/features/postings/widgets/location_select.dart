import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/gaps.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/models/filter_model.dart';
import 'package:jay/features/postings/repos/location_data.dart';
import 'package:jay/features/postings/view_models/filter_view_model.dart';
import 'package:jay/features/postings/widgets/filter_button.dart';

class LocationSelect extends ConsumerStatefulWidget {
  const LocationSelect({super.key, required this.filterModel});
  final FilterModel filterModel;

  @override
  ConsumerState<LocationSelect> createState() => _LocationSelectState();
}

class _LocationSelectState extends ConsumerState<LocationSelect> {
  bool _isExpanded = false;
  int _selectedProvince = -1;
  int _selectedCity = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  Future<void> _initLocation() async {
    await ref.read(filterProvider.notifier).loadSavedLocation();

    final filter = ref.read(filterProvider);
    final provinceName = filter.location.provinceName;
    final cityName = filter.location.cityName;

    if (provinceName.isEmpty || cityName.isEmpty) return;

    final provinceIndex =
        locationList.indexWhere((loc) => loc.provinceName == provinceName);
    if (provinceIndex == -1) return;

    final cityIndex = locationList[provinceIndex]
        .cityName
        .indexWhere((city) => city == cityName);
    if (cityIndex == -1) return;

    setState(() {
      _selectedProvince = provinceIndex;
      _selectedCity = cityIndex;
    });
  }

  Future<void> _saveCurrentLocationIfValid() async {
    if (_selectedProvince == -1 || _selectedCity == -1) return;
    final location = LocationModel(
      provinceName: locationList[_selectedProvince].provinceName,
      cityName: locationList[_selectedProvince].cityName[_selectedCity],
    );
    await ref.read(filterProvider.notifier).saveLocation(location);
  }

  void _clickOpen() {
    if (_isExpanded) _saveCurrentLocationIfValid();
    setState(() => _isExpanded = !_isExpanded);
  }

  void _closeButton() async {
    await _saveCurrentLocationIfValid();
    setState(() => _isExpanded = false);
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: Sizes.size6, bottom: Sizes.size6),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size12,
          vertical: Sizes.size6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).primaryColor
              : const Color(0xffF3F4F8),
          borderRadius: BorderRadius.circular(Sizes.size20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Sizes.size12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0xff747474),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clickOpen,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 410 : Sizes.size56,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Sizes.size14),
            bottomRight: Radius.circular(Sizes.size14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '관심 지역',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    if (_selectedProvince != -1)
                      Text(
                        _selectedCity != -1
                            ? '${locationList[_selectedProvince].provinceName} ${locationList[_selectedProvince].cityName[_selectedCity]}'
                            : locationList[_selectedProvince].provinceName,
                        style: const TextStyle(
                          fontSize: 15.5,
                          color: Color(0xff747474),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    Gaps.h10,
                    Icon(_isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ],
                ),
              ],
            ),
            if (_isExpanded) ...[
              Gaps.v16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 시/도
                            Wrap(
                              children: List.generate(
                                locationList.length,
                                (i) => _buildChip(
                                  label: locationList[i].provinceName,
                                  selected: _selectedProvince == i,
                                  onTap: () => setState(() {
                                    _selectedProvince = i;
                                    _selectedCity = -1;
                                  }),
                                ),
                              ),
                            ),
                            if (_selectedProvince != -1) ...[
                              const Divider(color: Color(0xffDFE4EB)),
                              Gaps.v4,
                              // 시/군/구
                              Wrap(
                                children: List.generate(
                                  locationList[_selectedProvince]
                                      .cityName
                                      .length,
                                  (i) => _buildChip(
                                    label: locationList[_selectedProvince]
                                        .cityName[i],
                                    selected: _selectedCity == i,
                                    onTap: () =>
                                        setState(() => _selectedCity = i),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Gaps.v16,
                    FilterButton(callbackFn: _closeButton),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
