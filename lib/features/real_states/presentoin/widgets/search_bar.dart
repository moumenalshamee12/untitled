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
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_isFocused ? secondary : primary).withValues(alpha: 0.12),
            blurRadius: _isFocused ? 20 : 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: _isFocused
              ? secondary.withValues(alpha: 0.6)
              : const Color(0xffe3e9f0),
          width: _isFocused ? 1.5 : 1,
        ),
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() {});
            },
            textAlign: TextAlign.right,
            cursorColor: primary,
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم، العنوان، أو الهاتف...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.search_rounded, color: secondary, size: 20),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      tooltip: 'مسح البحث',
                      onPressed: _clearSearch,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade500,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
