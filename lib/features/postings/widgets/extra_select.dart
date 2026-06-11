// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:jay/constants/sizes.dart';
// import 'package:jay/features/postings/models/filter_model.dart';
// import 'package:jay/features/postings/view_models/filter_view_model.dart';

// class ExtraSelect extends ConsumerStatefulWidget {
//   const ExtraSelect(
//       {super.key, required this.filterModel, required this.title});
//   final FilterModel filterModel;
//   final String title;

//   @override
//   ConsumerState<ExtraSelect> createState() => _ExtraSelectState();
// }

// class _ExtraSelectState extends ConsumerState<ExtraSelect> {
//   bool _isSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     // FilterModel에서 초기 선택 상태를 가져온다.
//     if (widget.title == '장애') {
//       _isSelected = widget.filterModel.isDisability;
//     } else if (widget.title == '희귀/난치질환') {
//       _isSelected = widget.filterModel.isRareDisease;
//     } else if (widget.title == '생활/예방') {
//       _isSelected = widget.filterModel.isLifePrevention;
//     }
//   }

//   void _selectBtn() {
//     setState(() {
//       _isSelected = !_isSelected;
//     });

//     final notifier = ref.read(filterProvider.notifier);

//     if (widget.title == '장애') {
//       notifier.saveExtraOptions(isDisability: _isSelected);
//     } else if (widget.title == '희귀/난치질환') {
//       notifier.saveExtraOptions(isRareDisease: _isSelected);
//     } else if (widget.title == '생활/예방') {
//       notifier.saveExtraOptions(isLifePrevention: _isSelected);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _selectBtn,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         height: 57,
//         padding: const EdgeInsets.symmetric(
//           horizontal: Sizes.size16,
//           vertical: Sizes.size16,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.all(
//             Radius.circular(Sizes.size14),
//           ),
//           border: _isSelected
//               ? Border.all(
//                   color: Theme.of(context).primaryColor,
//                 )
//               : Border.all(
//                   color: Colors.white,
//                 ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.title,
//                   style: const TextStyle(
//                     fontSize: Sizes.size16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SvgPicture.asset(
//                   'assets/images/detail_check.svg',
//                   width: Sizes.size14,
//                   height: Sizes.size14,
//                   fit: BoxFit.scaleDown,
//                   color: _isSelected
//                       ? Theme.of(context).primaryColor
//                       : const Color(0xffa8a8a8),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
