import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jay/constants/sizes.dart';
import 'package:jay/features/postings/view_models/posting_view_model.dart';

class SearchTextField extends ConsumerStatefulWidget {
  const SearchTextField({super.key});

  @override
  ConsumerState<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    ref.read(postingProvider.notifier).searchByTitle('');
  }

  void _onSubmit(String value) {
    ref.read(postingProvider.notifier).searchByTitle(value);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchQueryProvider, (prev, next) {
      if (next.isEmpty && _controller.text.isNotEmpty) {
        _controller.clear();
      }
    });

    return TextField(
      enableInteractiveSelection: true,
      controller: _controller,
      style: const TextStyle(
        fontSize: Sizes.size14,
      ),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintText: '맞춤형 지원 정보를 찾아보세요 :)',
        hintStyle: const TextStyle(
          color: Color(0xffDAE1E9),
          fontFamily: 'PretendardMedium',
          fontSize: 13,
        ),
        suffixIcon: _hasText
            ? GestureDetector(
                onTap: _onClear,
                child: const Icon(
                  Icons.close,
                  size: Sizes.size18,
                  color: Color(0xffA0A0A0),
                ),
              )
            : const Icon(
                size: Sizes.size24,
                Icons.search,
                color: Color(0xffDAE1E9),
              ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: Sizes.size24,
          minHeight: Sizes.size24,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => _onSubmit(value),
    );
  }
}
