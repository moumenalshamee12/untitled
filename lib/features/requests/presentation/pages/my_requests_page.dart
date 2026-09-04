import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/features/requests/domain/entities/request_entity.dart';
import 'package:untitled/features/requests/domain/usecases/get_my_requests_usecase.dart';
import 'package:untitled/features/requests/presentation/manager/my_requests_cubit.dart';
import 'package:untitled/features/requests/presentation/pages/request_details_page.dart';
import 'package:untitled/features/requests/presentation/widgets/request_status_badge.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRequestsCubit(getIt<GetMyRequestsUseCase>())..load(),
      child: const MyRequestsView(),
    );
  }
}

class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<MyRequestsCubit, MyRequestsState>(
          builder: (context, state) {
            if (state is MyRequestsLoading || state is MyRequestsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyRequestsFailure) {
              return _MessageState(
                message: state.message,
                action: () => context.read<MyRequestsCubit>().load(),
              );
            }
            final requests = (state as MyRequestsLoaded).requests;
            if (requests.isEmpty) {
              return const _MessageState(message: 'لم يتم إرسال أي طلبات بعد');
            }
            return RefreshIndicator(
              onRefresh: context.read<MyRequestsCubit>().load,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                itemCount: requests.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _RequestsHeader(count: requests.length);
                  }
                  final request = requests[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RequestCard(
                      request: request,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RequestDetailsPage(requestId: request.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestEntity request;
  final VoidCallback onTap;

  const _RequestCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor().primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.handyman_outlined,
                    color: AppColor().primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.company?.commercialName ?? 'شركة التشطيبات',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor().primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        request.serviceType.isEmpty
                            ? 'خدمة تشطيب'
                            : request.serviceType,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'رقم الطلب #${request.id}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RequestStatusBadge(status: request.status?.statusName),
                    const SizedBox(height: 14),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RequestsHeader extends StatelessWidget {
  final int count;

  const _RequestsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تابع طلباتك بسهولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'جميع طلبات خدمات التشطيب في مكان واحد',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColor().secondaryColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    color: AppColor().primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'طلب',
                  style: TextStyle(
                    color: AppColor().primaryColor,
                    fontSize: 11,
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

class _MessageState extends StatelessWidget {
  final String message;
  final VoidCallback? action;

  const _MessageState({required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
