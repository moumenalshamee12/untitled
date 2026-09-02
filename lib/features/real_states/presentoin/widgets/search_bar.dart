import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, this.onChanged});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;
    final secondary = AppColor().secondaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (_isFocused ? secondary : primary).withValues(alpha: 0.12),
            blurRadius: _isFocused ? 18 : 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isFocused
              ? secondary.withValues(alpha: 0.6)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            widget.onChanged?.call(value);
            setState(() {});
          },
          textAlign: TextAlign.right,
          cursorColor: primary,
          style: TextStyle(color: primary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'ابحث بالاسم، العنوان، أو الهاتف...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: secondary, size: 22),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    onPressed: _clearSearch,
                    icon: Icon(Icons.close_rounded, color: Colors.grey.shade500),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
