import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/constant/images_paths.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/finishing_companies/domin/usecases/fetch_finishing_companies_case.dart';
import 'package:untitled/features/finishing_companies/presentoin/pages/finishing_company_details_page.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state_case.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_state_details_page.dart';
import 'package:untitled/features/real_states/presentoin/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> onOpenTab;

  const HomePage({super.key, required this.onOpenTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RealStateEntity>> _realStatesFuture;
  late Future<List<FinishingCompanyEntity>> _companiesFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _realStatesFuture = _loadRealStates(getIt<FetchRealStateCase>());
    _companiesFuture = _loadCompanies(getIt<FetchFinishingCompaniesCase>());
  }

  Future<List<RealStateEntity>> _loadRealStates(
    FetchRealStateCase useCase,
  ) async {
    final result = await useCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => items,
    );
  }

  Future<List<FinishingCompanyEntity>> _loadCompanies(
    FetchFinishingCompaniesCase useCase,
  ) async {
    final result = await useCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (items) => items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            children: [
              _HomeTopBar(),
              const SizedBox(height: 18),
              _WelcomeBanner(),
              const SizedBox(height: 24),
              SearchBarWidget(
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              _RequestsStrip(onTap: () => widget.onOpenTab(3)),
              const SizedBox(height: 24),
              _DataSection<RealStateEntity>(
                title: 'عقارات مقترحة',
                actionLabel: 'عرض الكل',
                onViewAll: () => widget.onOpenTab(1),
                future: _realStatesFuture,
                query: _query,
                emptyLabel: 'لا توجد عقارات متاحة حاليًا',
                itemBuilder: (item) => _RealStatePreview(
                  realState: item,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          RealStateDetailsPage(realStateId: item.id),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _DataSection<FinishingCompanyEntity>(
                title: 'شركات تشطيب مميزة',
                actionLabel: 'عرض الكل',
                onViewAll: () => widget.onOpenTab(2),
                future: _companiesFuture,
                query: _query,
                emptyLabel: 'لا توجد شركات متاحة حاليًا',
                itemBuilder: (item) => _CompanyPreview(
                  company: item,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          FinishingCompanyDetailsPage(companyId: item.id),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _HelpBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataSection<T> extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onViewAll;
  final Future<List<T>> future;
  final String query;
  final String emptyLabel;
  final Widget Function(T item) itemBuilder;

  const _DataSection({
    required this.title,
    required this.actionLabel,
    required this.onViewAll,
    required this.future,
    required this.query,
    required this.emptyLabel,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 138,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return _SectionMessage(label: 'تعذر تحميل البيانات');
        }
        final items = snapshot.data ?? <T>[];
        final filtered = query.trim().isEmpty
            ? items
            : items.where((item) {
                final value = item is RealStateEntity
                    ? item.commercialName
                    : (item as FinishingCompanyEntity).commercialName;
                return value.toLowerCase().contains(query.trim().toLowerCase());
              }).toList();
        if (filtered.isEmpty) return _SectionMessage(label: emptyLabel);
        return Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: onViewAll, child: Text(actionLabel)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 148,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filtered.take(5).length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) => itemBuilder(filtered[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RequestsStrip extends StatelessWidget {
  final VoidCallback onTap;

  const _RequestsStrip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.secondary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.34),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلباتي',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'تابع حالة طلبات التشطيب الخاصة بك',
                      style: TextStyle(color: AppColor.primary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: AppColor.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionMessage extends StatelessWidget {
  final String label;

  const _SectionMessage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffe3e9f0)),
      ),
      child: Text(label, style: const TextStyle(color: AppColor.muted)),
    );
  }
}

class _RealStatePreview extends StatelessWidget {
  final RealStateEntity realState;
  final VoidCallback onTap;

  const _RealStatePreview({required this.realState, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _PreviewCard(
      width: 250,
      icon: Icons.apartment_rounded,
      title: realState.commercialName,
      subtitle: realState.address,
      accent: AppColor.primary,
      onTap: onTap,
    );
  }
}

class _CompanyPreview extends StatelessWidget {
  final FinishingCompanyEntity company;
  final VoidCallback onTap;

  const _CompanyPreview({required this.company, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _PreviewCard(
      width: 250,
      icon: Icons.handyman_rounded,
      title: company.commercialName,
      subtitle: company.services.isEmpty
          ? 'خدمات تشطيب متخصصة'
          : company.services
                .map((service) => service.serviceType)
                .take(2)
                .join('، '),
      accent: AppColor.secondary,
      onTap: onTap,
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _PreviewCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xffe3e9f0)),
          ),
          child: Image.asset(AppImages().logo),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بك',
                style: TextStyle(color: AppColor.muted, fontSize: 13),
              ),
              SizedBox(height: 3),
              Text(
                'اكتشف منزلك المثالي',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'الإشعارات',
          icon: const Icon(Icons.notifications_none_rounded),
          color: AppColor.primary,
        ),
      ],
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColor.primary, AppColor.primary.withValues(alpha: 0.84)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'كل ما تحتاجه\nلمنزلك في مكان واحد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'تصفح العقارات وتواصل مع أفضل شركات التشطيب.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.home_work_rounded,
            size: 68,
            color: AppColor.secondary.withValues(alpha: 0.95),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const _QuickActions({required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.apartment_rounded,
            title: 'استكشف العقارات',
            color: AppColor.primary,
            onTap: () => onOpenTab(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.handyman_rounded,
            title: 'اطلب خدمة تشطيب',
            color: AppColor.secondary,
            onTap: () => onOpenTab(2),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 29),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.arrow_back_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesPreview extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const _ServicesPreview({required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ServiceTile(
            icon: Icons.search_rounded,
            title: 'بحث عن عقار',
            subtitle: 'مكاتب موثوقة',
            onTap: () => onOpenTab(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ServiceTile(
            icon: Icons.business_center_outlined,
            title: 'شركات التشطيب',
            subtitle: 'خدمات متخصصة',
            onTap: () => onOpenTab(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ServiceTile(
            icon: Icons.assignment_outlined,
            title: 'طلباتي',
            subtitle: 'تابع طلباتك',
            onTap: () => onOpenTab(3),
          ),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: AppColor.secondary, size: 25),
              const SizedBox(height: 9),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColor.muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: AppColor.secondary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'ابحث، قارن، ثم اتخذ قرارك بثقة.',
              style: TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColor.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
