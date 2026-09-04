import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/finishing_companies/domin/usecases/fetch_finishing_companies_case.dart';
import 'package:untitled/features/finishing_companies/presentoin/manager/finishing_companies_cubit.dart';
import 'package:untitled/features/finishing_companies/presentoin/manager/finishing_companies_states.dart';
import 'package:untitled/features/finishing_companies/presentoin/pages/finishing_company_details_page.dart';
import 'package:untitled/features/real_states/presentoin/widgets/search_bar.dart';

class FinishingCompaniesPage extends StatelessWidget {
  const FinishingCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FinishingCompaniesCubit(getIt<FetchFinishingCompaniesCase>())
            ..fetchFinishingCompanies(),
      child: const FinishingCompaniesView(),
    );
  }
}

class FinishingCompaniesView extends StatefulWidget {
  const FinishingCompaniesView({super.key});

  @override
  State<FinishingCompaniesView> createState() => _FinishingCompaniesViewState();
}

class _FinishingCompaniesViewState extends State<FinishingCompaniesView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinishingCompaniesCubit, FinishingCompaniesStates>(
      listener: (context, state) {
        if (state is FinishingCompaniesErrorState) {
          showErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is FinishingCompaniesLoadingState;
        final allCompanies = state is FinishingCompaniesLoadedState
            ? state.companies
            : const <FinishingCompanyEntity>[];

        final filteredCompanies = _searchQuery.trim().isEmpty
            ? allCompanies
            : allCompanies.where((company) {
                final name = company.commercialName.trim().toLowerCase();
                final query = _searchQuery.trim().toLowerCase();
                return name.startsWith(query);
              }).toList();

        final primary = AppColor().primaryColor;
        final secondary = AppColor().secondaryColor;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: RefreshIndicator(
            color: secondary,
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<FinishingCompaniesCubit>().fetchFinishingCompanies();
            },
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
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                              const Spacer(),
                              Text(
                                'شركات الاكساء',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اكتشف أفضل شركات الاكساء والديكور الموثوقة',
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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _StatsRow(
                    total: filteredCompanies.length,
                    active: allCompanies
                        .where((company) => company.isActive)
                        .length,
                    isSearching: _searchQuery.trim().isNotEmpty,
                  ),
                ),
                Expanded(
                  child: _buildListContent(
                    filteredCompanies: filteredCompanies,
                    isLoading: isLoading,
                    primary: primary,
                    secondary: secondary,
                    query: _searchQuery,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListContent({
    required List<FinishingCompanyEntity> filteredCompanies,
    required bool isLoading,
    required Color primary,
    required Color secondary,
    required String query,
  }) {
    if (isLoading && filteredCompanies.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, _) => _ShimmerCard(),
      );
    }

    if (filteredCompanies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                query.trim().isEmpty
                    ? Icons.build_rounded
                    : Icons.search_off_rounded,
                size: 68,
                color: primary.withValues(alpha: 0.65),
              ),
              const SizedBox(height: 16),
              Text(
                query.trim().isEmpty
                    ? 'لا توجد شركات الاكساء'
                    : 'لا توجد نتائج',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                query.trim().isEmpty
                    ? 'سيتم عرض الشركات هنا عند توفرها'
                    : 'جرّب البحث بكلمة مختلفة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: filteredCompanies.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final company = filteredCompanies[index];
        return GestureDetector(
          onTap: () =>
              Get.to(() => FinishingCompanyDetailsPage(companyId: company.id)),
          child: _FinishingCompanyCard(company: company),
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
            icon: Icons.business_rounded,
            label: isSearching ? 'نتائج البحث' : 'إجمالي الشركات',
            value: '$total',
            color: primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.verified_rounded,
            label: 'نشط',
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
            color: color.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
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
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _FinishingCompanyCard extends StatelessWidget {
  final FinishingCompanyEntity company;

  const _FinishingCompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;
    final secondary = AppColor().secondaryColor;
    final firstPortfolioImage = company.portfolios.isNotEmpty
        ? company.portfolios.first.imageUrl.trim()
        : '';
    final imageUrl = firstPortfolioImage.isNotEmpty
        ? firstPortfolioImage
        : 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.09),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: primary.withValues(alpha: 0.08),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_rounded),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: company.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      company.isActive ? 'نشط' : 'غير نشط',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          company.commercialName,
                          style: TextStyle(
                            color: primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone_rounded, size: 16, color: secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          company.contactInfo,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatWorkAreas(company.workAreas),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    company.profileDescription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(label: 'الخدمات: ${company.services.length}'),
                      _Tag(label: 'المناطق: ${company.workAreas.length}'),
                      _Tag(label: 'معرض: ${company.portfolios.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWorkAreas(List<FinishingWorkAreaEntity> workAreas) {
    if (workAreas.isEmpty) return 'لا توجد مناطق متاحة';
    return workAreas
        .where((area) => area.location != null)
        .map((area) => area.location!.city)
        .toSet()
        .join(' - ');
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColor().secondaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColor().secondaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
