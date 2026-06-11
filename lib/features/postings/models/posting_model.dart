// 필요 데이터: 공고 ID, 공고명, 지원타입, 지원내용, 대상 - 필터링(나이, 주소, 대상 질병, 소득수준, 장애등록여부), 신청 기간, 기관유형, 기관명, 사이트링크, 설명
import 'package:jay/features/postings/models/filter_model.dart';

// 선택 가능한 질병 목록
const List<String> diseaseList = [
  '전체 선택',
  '감염성/기생충',
  '암 및 종양',
  '혈액 및 면역',
  '당뇨/대사/영양',
  '정신건강/우울',
  '뇌/신경',
  '안과',
  '이비인후과',
  '심혈관/고혈압',
  '호흡기/폐',
  '위/장/간',
  '피부',
  '뼈/관절/척추',
  '신장/비뇨기',
  '임신/출산',
  '선천성/기형',
  '원인불명 통증/증상',
  '외상/사고',
  '치아/구강',
];

class PostingModel {
  final int id;
  final String title;
  final bool isDisability;
  final List<int> targetDisease;
  final LocationModel location;
  final List<String> content;
  final List<int> age;
  final int minIncomeRate;
  final int maxIncomeRate;
  final DateTime endDate;
  final List<String> institution;
  final List<String> supportTarget;
  final List<String> receiptMethod;
  final String siteLink;
  final List<String> description;
  final String contentSummary;
  final bool isRareDisease;
  final bool isLifePrevention;

  const PostingModel({
    required this.id,
    required this.title,
    required this.isDisability,
    required this.content,
    required this.location,
    required this.age,
    required this.minIncomeRate,
    required this.maxIncomeRate,
    required this.targetDisease,
    required this.endDate,
    required this.institution,
    required this.supportTarget,
    required this.receiptMethod,
    required this.siteLink,
    required this.description,
    required this.contentSummary,
    required this.isRareDisease,
    required this.isLifePrevention,
  });

  factory PostingModel.fromMap(Map<String, dynamic> posting) {
    return PostingModel(
      id: posting['id'],
      title: posting['title'],
      isDisability: posting['is_disability'],
      content: List<String>.from(posting['content'] ?? []),
      location: LocationModel(
          provinceName: posting['province'], cityName: posting['city']),
      age: List<int>.from(posting['age'] ?? []),
      minIncomeRate: posting['min_income_rate'],
      maxIncomeRate: posting['max_income_rate'],
      targetDisease: List<int>.from(posting['disease'] ?? []),
      endDate: DateTime.parse(posting['end_date']),
      institution: List<String>.from(posting['institution'] ?? []),
      siteLink: posting['link'],
      description: List<String>.from(posting['description'] ?? []),
      supportTarget: List<String>.from(posting['support_target'] ?? []),
      receiptMethod: List<String>.from(posting['receipt_method'] ?? []),
      contentSummary: posting['content_summary'] ?? '',
      isRareDisease: posting['is_rare_disease'] ?? false,
      isLifePrevention: posting['is_life_prevention'] ?? false,
    );
  }
}

// 서비스명, 시행시작일