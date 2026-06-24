import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clickOpen,
      child: Container(
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
              SizedBox(
                height: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: locationList.length,
                        itemBuilder: (context, i) {
                          final selected = _selectedProvince == i;
                          return GestureDetector(
                            onTap: () {
                              if (_selectedProvince == i) {
                                setState(() {
                                  _selectedProvince = -1;
                                  _selectedCity = -1;
                                });
                                ref.read(filterProvider.notifier).saveLocation(
                                      const LocationModel(
                                          provinceName: '', cityName: ''),
                                    );
                              } else {
                                setState(() {
                                  _selectedProvince = i;
                                  _selectedCity = -1;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    locationList[i].provinceName,
                                    style: TextStyle(
                                      fontSize: Sizes.size14,
                                      fontFamily: selected
                                          ? 'PretendardSemiBold'
                                          : 'PretendardMedium',
                                      color: selected
                                          ? const Color(0xff1154ED)
                                          : const Color(0xff747474),
                                    ),
                                  ),
                                  if (selected)
                                    SvgPicture.asset(
                                      'assets/images/detail_check.svg',
                                      width: 14,
                                      height: 14,
                                      colorFilter: const ColorFilter.mode(
                                          Color(0xff1154ED), BlendMode.srcIn),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(color: Color(0xffDFE4EB), width: 1),
                    Expanded(
                      child: _selectedProvince == -1
                          ? const Center(
                              child: Text(
                                '시/도를\n선택하세요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff9EA7B2),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: locationList[_selectedProvince]
                                  .cityName
                                  .length,
                              itemBuilder: (context, i) {
                                final selected = _selectedCity == i;
                                return GestureDetector(
                                  onTap: () {
                                    if (_selectedCity == i) {
                                      setState(() => _selectedCity = -1);
                                      ref
                                          .read(filterProvider.notifier)
                                          .saveLocation(LocationModel(
                                            provinceName:
                                                locationList[_selectedProvince]
                                                    .provinceName,
                                            cityName: '',
                                          ));
                                    } else {
                                      setState(() => _selectedCity = i);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locationList[_selectedProvince]
                                              .cityName[i],
                                          style: TextStyle(
                                            fontSize: Sizes.size14,
                                            fontFamily: selected
                                                ? 'PretendardSemiBold'
                                                : 'PretendardMedium',
                                            color: selected
                                                ? const Color(0xff1154ED)
                                                : const Color(0xff747474),
                                          ),
                                        ),
                                        if (selected)
                                          SvgPicture.asset(
                                            'assets/images/detail_check.svg',
                                            width: 14,
                                            height: 14,
                                            colorFilter: const ColorFilter.mode(
                                                Color(0xff1154ED),
                                                BlendMode.srcIn),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Gaps.v16,
              FilterButton(callbackFn: _closeButton),
            ],
          ],
        ),
      ),
    );
  }
}
