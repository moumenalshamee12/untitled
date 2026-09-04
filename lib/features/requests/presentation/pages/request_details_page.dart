import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:untitled/features/requests/presentation/widgets/request_status_badge.dart';

class RequestDetailsPage extends StatelessWidget {
  final int requestId;

  const RequestDetailsPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RequestEntity>(
      future: _loadRequest(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الطلب')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('تفاصيل الطلب')),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: _DetailsError(message: snapshot.error.toString()),
            ),
          );
        }
        return _RequestDetailsView(request: snapshot.data!);
      },
    );
  }

  Future<RequestEntity> _loadRequest() async {
    final result = await getIt<GetRequestByIdUseCase>()(requestId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}

class _RequestDetailsView extends StatelessWidget {
  final RequestEntity request;

  const _RequestDetailsView({required this.request});

  @override
  Widget build(BuildContext context) {
    final location = request.location;
    final companyName = request.company?.commercialName ?? 'شركة التشطيبات';
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
          children: [
            _RequestHero(
              companyName: companyName,
              serviceType: request.serviceType,
              status: request.status?.statusName,
              requestId: request.id,
            ),
            const SizedBox(height: 18),
            const _SectionHeading(
              icon: Icons.description_outlined,
              title: 'وصف الطلب',
            ),
            const SizedBox(height: 10),
            _SurfaceCard(
              child: Text(
                request.description.isEmpty
                    ? 'لا يوجد وصف مضاف'
                    : request.description,
                style: TextStyle(color: Colors.grey.shade700, height: 1.7),
              ),
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              icon: Icons.home_work_outlined,
              title: 'مواصفات المشروع',
            ),
            const SizedBox(height: 10),
            _SurfaceCard(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.2,
                children: [
                  _SpecItem(
                    icon: Icons.square_foot_rounded,
                    label: 'المساحة',
                    value: request.area,
                  ),
                  _SpecItem(
                    icon: Icons.meeting_room_outlined,
                    label: 'الغرف',
                    value: request.rooms.toString(),
                  ),
                  _SpecItem(
                    icon: Icons.layers_outlined,
                    label: 'الطابق',
                    value: request.floor.toString(),
                  ),
                  _SpecItem(
                    icon: Icons.design_services_outlined,
                    label: 'الخدمة',
                    value: request.serviceType,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              icon: Icons.location_on_outlined,
              title: 'موقع التنفيذ',
            ),
            const SizedBox(height: 10),
            _SurfaceCard(child: _LocationContent(location: location)),
          ],
        ),
      ),
    );
  }
}

class _RequestHero extends StatelessWidget {
  final String companyName;
  final String serviceType;
  final String? status;
  final int requestId;

  const _RequestHero({
    required this.companyName,
    required this.serviceType,
    required this.status,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor().primaryColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor().primaryColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  companyName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              RequestStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            serviceType.isEmpty ? 'خدمة تشطيب' : serviceType,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
          ),
          const SizedBox(height: 16),
          Text(
            'رقم الطلب #$requestId',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;

  const _SectionHeading({required this.icon, required this.title})
    : label = title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColor().secondaryColor, size: 21),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColor().primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffe3e9f0)),
      ),
      child: child,
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColor().secondaryColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? '-' : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor().primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationContent extends StatelessWidget {
  final RequestLocationEntity? location;

  const _LocationContent({required this.location});

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return Text(
        'لم يتم تحديد موقع التنفيذ',
        style: TextStyle(color: Colors.grey.shade600),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_rounded, color: AppColor().primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${location!.city}، ${location!.neighborhood}، ${location!.addressDetails}',
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _DetailsError extends StatelessWidget {
  final String message;

  const _DetailsError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
