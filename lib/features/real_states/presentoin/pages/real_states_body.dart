import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_state_details_page.dart';
import 'package:untitled/features/real_states/presentoin/widgets/real_state_card.dart';
import 'package:untitled/features/real_states/presentoin/widgets/real_state_shimmer_card.dart';
import 'package:untitled/features/real_states/presentoin/widgets/search_bar.dart';

class RealStatesBody extends StatefulWidget {
  final bool isLoading;
  final List<RealStateEntity> realStates;
  final Future<void> Function()? onRefresh;
  final VoidCallback onRetry;
  final bool showError;

  const RealStatesBody({
    super.key,
    this.isLoading = false,
    this.realStates = const [],
    this.onRefresh,
    required this.onRetry,
    this.showError = false,
  });

  @override
  State<RealStatesBody> createState() => _RealStatesBodyState();
}

class _RealStatesBodyState extends State<RealStatesBody> {
  String _searchQuery = '';

  List<RealStateEntity> get _filteredRealStates {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.realStates;

    return widget.realStates.where((office) {
      return office.commercialName.toLowerCase().startsWith(query);
    }).toList();
  }

  int get _activeCount =>
      widget.realStates.where((office) => office.isActive).length;

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;
    final secondary = AppColor().secondaryColor;
    final filtered = _filteredRealStates;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: RefreshIndicator(
        color: secondary,
        backgroundColor: Colors.white,
        onRefresh: widget.onRefresh ?? () async {},
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    primary,
                    primary.withValues(alpha: 0.92),
                    const Color(0xFF1E2F4A),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                            ),
                            color: Colors.white,
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const Spacer(),
                          Text(
                            'المكاتب العقارية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اكتشف أفضل المكاتب العقارية الموثوقة',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBarWidget(
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _StatsRow(
                total: filtered.length,
                active: _activeCount,
                isSearching: _searchQuery.trim().isNotEmpty,
              ),
            ),
            Expanded(child: _buildListContent(filtered, primary, secondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(
    List<RealStateEntity> filtered,
    Color primary,
    Color secondary,
  ) {
    if (widget.isLoading && widget.realStates.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, __) => const RealStateShimmerCard(),
      );
    }

    if (widget.showError && widget.realStates.isEmpty) {
      return _EmptyState(
        icon: Icons.cloud_off_rounded,
        title: 'تعذر تحميل المكاتب',
        subtitle: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
        actionLabel: 'إعادة المحاولة',
        onAction: widget.onRetry,
        accent: secondary,
      );
    }

    if (filtered.isEmpty) {
      return _EmptyState(
        icon: _searchQuery.trim().isEmpty
            ? Icons.apartment_outlined
            : Icons.search_off_rounded,
        title: _searchQuery.trim().isEmpty
            ? 'لا توجد مكاتب متاحة'
            : 'لا توجد نتائج',
        subtitle: _searchQuery.trim().isEmpty
            ? 'سيتم عرض المكاتب هنا عند توفرها'
            : 'جرّب البحث بكلمة مختلفة',
        accent: primary,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final realState = filtered[index];
        return RealStateCard(
          realState: realState,
          animationIndex: index,
          onDetailsTap: () =>
              Get.to(() => RealStateDetailsPage(realStateId: realState.id)),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int total;
  final int active;
  final bool isSearching;

  const _StatsRow({
    required this.total,
    required this.active,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;
    final secondary = AppColor().secondaryColor;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.apartment_rounded,
            label: isSearching ? 'نتائج البحث' : 'إجمالي المكاتب',
            value: '$total',
            color: primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.verified_rounded,
            label: 'مكاتب نشطة',
            value: '$active',
            color: secondary,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color accent;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: accent),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor().primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
