import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/finishing_companies/domin/usecases/fetch_finishing_companies_case.dart';
import 'package:untitled/features/requests/presentation/pages/create_request_page.dart';

abstract class FinishingCompanyDetailsStates {}

class FinishingCompanyDetailsInitialState
    extends FinishingCompanyDetailsStates {}

class FinishingCompanyDetailsLoadingState
    extends FinishingCompanyDetailsStates {}

class FinishingCompanyDetailsLoadedState extends FinishingCompanyDetailsStates {
  final FinishingCompanyEntity company;

  FinishingCompanyDetailsLoadedState(this.company);
}

class FinishingCompanyDetailsErrorState extends FinishingCompanyDetailsStates {
  final String error;

  FinishingCompanyDetailsErrorState(this.error);
}

class FinishingCompanyDetailsCubit
    extends Cubit<FinishingCompanyDetailsStates> {
  final FetchFinishingCompanyByIdCase fetchFinishingCompanyByIdCase;

  FinishingCompanyDetailsCubit(this.fetchFinishingCompanyByIdCase)
    : super(FinishingCompanyDetailsInitialState());

  Future<void> fetchFinishingCompanyById(int id) async {
    emit(FinishingCompanyDetailsLoadingState());
    final result = await fetchFinishingCompanyByIdCase.call(id);
    result.fold(
      (failure) => emit(FinishingCompanyDetailsErrorState(failure.message)),
      (company) => emit(FinishingCompanyDetailsLoadedState(company)),
    );
  }
}

class FinishingCompanyDetailsPage extends StatelessWidget {
  final int companyId;

  const FinishingCompanyDetailsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FinishingCompanyDetailsCubit(getIt<FetchFinishingCompanyByIdCase>())
            ..fetchFinishingCompanyById(companyId),
      child: FinishingCompanyDetailsView(companyId: companyId),
    );
  }
}

class FinishingCompanyDetailsView extends StatelessWidget {
  final int companyId;

  const FinishingCompanyDetailsView({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      FinishingCompanyDetailsCubit,
      FinishingCompanyDetailsStates
    >(
      listener: (context, state) {
        if (state is FinishingCompanyDetailsErrorState) {
          showErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            backgroundColor: AppColor().primaryColor,
            title: const Text('تفاصيل الشركة'),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FinishingCompanyDetailsStates state) {
    if (state is FinishingCompanyDetailsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FinishingCompanyDetailsErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context
                    .read<FinishingCompanyDetailsCubit>()
                    .fetchFinishingCompanyById(companyId),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is FinishingCompanyDetailsLoadedState) {
      final company = state.company;
      final firstImage = company.portfolios.isNotEmpty
          ? company.portfolios.first.imageUrl.trim()
          : '';
      final imageUrl = firstImage.isNotEmpty
          ? firstImage
          : 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColor().primaryColor.withValues(alpha: 0.12),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _imagePlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
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
                            color: AppColor().primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: company.isActive
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          company.isActive ? 'نشط' : 'غير نشط',
                          style: TextStyle(
                            color: company.isActive ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.phone_android,
                    text: company.contactInfo,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: _formatWorkAreas(company.workAreas),
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'الوصف',
                    style: TextStyle(
                      color: AppColor().primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    company.profileDescription,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.7,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (company.services.isNotEmpty) ...[
              ElevatedButton.icon(
                onPressed: company.isActive
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CreateRequestPage(
                            companyId: company.id,
                            workAreas: company.workAreas,
                            services: company.services,
                          ),
                        ),
                      )
                    : null,
                icon: const Icon(Icons.handyman_rounded),
                label: const Text('طلب خدمة من الشركة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 18),
            ],
            _SectionCard(
              title: 'معرض الأعمال',
              icon: Icons.photo_library_outlined,
              child: company.portfolios.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('لا توجد صور متاحة في المعرض حالياً.'),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: company.portfolios.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                      itemBuilder: (context, index) {
                        final portfolio = company.portfolios[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            portfolio.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: AppColor().primaryColor.withValues(
                                    alpha: 0.08,
                                  ),
                                  child: const Icon(
                                    Icons.image_not_supported_rounded,
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'الخدمات',
              icon: Icons.construction_rounded,
              child: company.services.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('لا توجد خدمات مضافة لهذا الشركة حالياً.'),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: company.services
                          .map(
                            (service) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor().secondaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                service.serviceType,
                                style: TextStyle(
                                  color: AppColor().secondaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'مناطق العمل',
              icon: Icons.map_outlined,
              child: company.workAreas.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('لا توجد مناطق عمل مضافة حالياً.'),
                    )
                  : Column(
                      children: company.workAreas.map((workArea) {
                        final location = workArea.location;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_city_rounded,
                                color: AppColor().primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  location != null
                                      ? '${location.city} - ${location.neighborhood} - ${location.region}'
                                      : 'منطقة غير محددة',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatWorkAreas(List<FinishingWorkAreaEntity> workAreas) {
    if (workAreas.isEmpty) return 'لا توجد مناطق متاحة';
    return workAreas
        .where((area) => area.location != null)
        .map((area) => area.location!.city)
        .toSet()
        .join(' - ');
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 220,
      color: AppColor().primaryColor.withValues(alpha: 0.12),
      child: Center(
        child: Icon(
          Icons.business_center_rounded,
          size: 52,
          color: AppColor().primaryColor,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColor().secondaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor().primaryColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor().primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColor().primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
