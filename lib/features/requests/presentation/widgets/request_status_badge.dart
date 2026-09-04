import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class RequestStatusPresentation {
  final String label;
  final Color color;

  const RequestStatusPresentation({required this.label, required this.color});

  factory RequestStatusPresentation.fromValue(String? value) {
    final normalized = value?.trim().toLowerCase() ?? '';
    if (normalized == 'completed' || normalized == 'complete') {
      return const RequestStatusPresentation(
        label: 'مكتمل',
        color: Colors.green,
      );
    }
    if (normalized == 'in progress' ||
        normalized == 'in_progress' ||
        normalized == 'processing') {
      return const RequestStatusPresentation(
        label: 'قيد التنفيذ',
        color: Colors.amber,
      );
    }
    if (normalized == 'new' || normalized == 'pending') {
      return RequestStatusPresentation(
        label: 'جديد',
        color: AppColor().secondaryColor,
      );
    }
    return RequestStatusPresentation(
      label: value?.trim().isNotEmpty == true ? value!.trim() : 'جديد',
      color: AppColor().secondaryColor,
    );
  }
}

class RequestStatusBadge extends StatelessWidget {
  final String? status;

  const RequestStatusBadge({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final presentation = RequestStatusPresentation.fromValue(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: presentation.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        presentation.label,
        style: TextStyle(
          color: presentation.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
