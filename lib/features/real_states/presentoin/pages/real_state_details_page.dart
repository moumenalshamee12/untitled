import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_text.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';
import 'package:untitled/features/real_states/data/data_source/real_state_remote_data_source.dart';
import 'package:untitled/features/real_states/data/repo/real_state_repo_imp.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state-by_id_case.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_state_details_cubit/real_state_details_cubit.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_state_details_cubit/real_state_details_states.dart';
import 'package:untitled/features/real_states/presentoin/widgets/icon_and_column.dart';
import 'package:untitled/features/real_states/presentoin/widgets/icon_and_text.dart';

class RealStateDetailsPage extends StatelessWidget {
  final int realStateId;

  const RealStateDetailsPage({super.key, required this.realStateId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RealStateDetailsCubit(
        FetchRealStateByIdCase(
          realStateRepo: RealStateRepoImp(
            realStateRemoteDatasource: RealStateRemoteDatasourceImpl(
              apiService: ApiService(dio: Dio()),
            ),
          ),
        ),
      )..fetchRealStateById(realStateId),
      child: RealStateDetailsView(realStateId: realStateId),
    );
  }
}

class RealStateDetailsView extends StatelessWidget {
  final int realStateId;

  const RealStateDetailsView({super.key, required this.realStateId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RealStateDetailsCubit, RealStateDetailsStates>(
      listener: (context, state) {
        if (state is RealStateDetailsErrorState) {
          showErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            backgroundColor: AppColor().primaryColor,
            title: const Text('تفاصيل المكتب'),
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

  Widget _buildBody(BuildContext context, RealStateDetailsStates state) {
    if (state is RealStateDetailsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RealStateDetailsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Customtext(
              text: state.error,
              color: Colors.red,
              size: 16,
              weight: FontWeight.w500,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<RealStateDetailsCubit>()
                  .fetchRealStateById(realStateId),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state is RealStateDetailsLoadedState) {
      final office = state.realState;
      final firstPropertyImage = office.properties.isNotEmpty
          ? office.properties.first.images.firstOrNull?.imageUrl
          : null;

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
                child: firstPropertyImage != null
                    ? Image.network(
                        firstPropertyImage,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _propertyPlaceholder(),
                      )
                    : _propertyPlaceholder(),
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
                        child: Customtext(
                          text: office.commercialName,
                          color: AppColor().primaryColor,
                          size: 24,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: office.isActive
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Customtext(
                          text: office.isActive ? 'نشط' : 'غير نشط',
                          color: office.isActive ? Colors.green : Colors.red,
                          size: 12,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  IconAndText(
                    icon: Icons.location_on_outlined,
                    text: office.address,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: IconAndColumn(
                          icon: Icons.badge_outlined,
                          title: 'رقم الترخيص',
                          subtitle: office.licenseNumber,
                        ),
                      ),
                      Expanded(
                        child: IconAndColumn(
                          icon: Icons.phone_android,
                          title: 'رقم الهاتف',
                          subtitle: office.phoneNumber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Customtext(
                    text: 'الوصف',
                    color: AppColor().primaryColor,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    office.profileDescription,
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

            _InfoSection(
              title: 'العقارات المتاحة',
              icon: Icons.home_work_outlined,
              children: office.properties.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'لا توجد عقارات متاحة في هذا المكتب حالياً.',
                        ),
                      ),
                    ]
                  : [
                      ...office.properties.map(
                        (property) => _PropertyCard(property: property),
                      ),
                    ],
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _propertyPlaceholder() {
    return Container(
      height: 220,
      color: AppColor().primaryColor.withValues(alpha: 0.12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 48,
              color: AppColor().primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد صورة للعقار',
              style: TextStyle(color: AppColor().primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final PropertyEntity property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final primary = AppColor().primaryColor;
    final secondary = AppColor().secondaryColor;
    final imageUrl = property.images.isNotEmpty
        ? property.images.first.imageUrl
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: primary.withValues(alpha: 0.08),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_rounded),
                      ),
                    ),
                  )
                : Container(
                    height: 180,
                    color: primary.withValues(alpha: 0.08),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_rounded),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: TextStyle(
                          color: primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        property.offerType,
                        style: TextStyle(
                          color: secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  property.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.6),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PropertyTag(
                      icon: Icons.monetization_on_outlined,
                      label: '${property.price.toStringAsFixed(0)} ر.س',
                    ),
                    _PropertyTag(
                      icon: Icons.square_foot_outlined,
                      label: '${property.area.toStringAsFixed(0)} م²',
                    ),
                    _PropertyTag(
                      icon: Icons.bedroom_parent_outlined,
                      label: '${property.rooms} غرف',
                    ),
                    _PropertyTag(
                      icon: Icons.category_outlined,
                      label: property.type,
                    ),
                    _PropertyTag(
                      icon: Icons.gavel_outlined,
                      label: property.legalStatus,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PropertyTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor().primaryColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
